param(
    [string]$FtpServer,
    [string]$FtpUser,
    [string]$FtpPass
)

$manifestName = ".deploy-manifest"

function New-Creds {
    return New-Object System.Net.NetworkCredential($FtpUser,$FtpPass)
}

function Get-HashManifest($root) {
    $map=@{}
    Get-ChildItem $root -Recurse -File | ForEach-Object {
        $rel=$_.FullName.Substring($root.Length).TrimStart('\') -replace '\\','/'
        $map[$rel]=(Get-FileHash $_.FullName -Algorithm SHA1).Hash
    }
    return $map
}

function Download-Manifest($remoteRoot) {
    try {
        $tmp=Join-Path $env:RUNNER_TEMP "remote_manifest.txt"

        $req=[System.Net.FtpWebRequest]::Create("ftp://$FtpServer$remoteRoot/$manifestName")
        $req.Method=[System.Net.WebRequestMethods+Ftp]::DownloadFile
        $req.Credentials=New-Creds

        $resp=$req.GetResponse()
        $stream=$resp.GetResponseStream()
        $file=[System.IO.File]::Create($tmp)
        $stream.CopyTo($file)
        $file.Close()
        $resp.Close()

        $map=@{}
        Get-Content $tmp | ForEach-Object {
            $p=$_ -split '\|'
            $map[$p[0]]=$p[1]
        }
        return $map
    } catch {
        return @{}
    }
}

function Upload-File($local,$remote) {

    $req=[System.Net.FtpWebRequest]::Create("ftp://$FtpServer$remote")
    $req.Method=[System.Net.WebRequestMethods+Ftp]::UploadFile
    $req.Credentials=New-Creds
    $req.UseBinary=$true
    $req.KeepAlive=$false

    $bytes=[System.IO.File]::ReadAllBytes($local)
    $req.ContentLength=$bytes.Length

    $stream=$req.GetRequestStream()
    $stream.Write($bytes,0,$bytes.Length)
    $stream.Close()

    $req.GetResponse().Close()
}

function Delete-File($remote) {
    try {
        Write-Host "DELETE $remote"
        $req=[System.Net.FtpWebRequest]::Create("ftp://$FtpServer$remote")
        $req.Method=[System.Net.WebRequestMethods+Ftp]::DeleteFile
        $req.Credentials=New-Creds
        $req.GetResponse().Close()
    } catch {}
}

function Ensure-Dirs($remoteFile) {
    $parts=$remoteFile.Split('/')
    $path=""

    for($i=0;$i -lt $parts.Length-1;$i++){
        $path+="/"+$parts[$i]
        try{
            $req=[System.Net.FtpWebRequest]::Create("ftp://$FtpServer$path")
            $req.Method=[System.Net.WebRequestMethods+Ftp]::MakeDirectory
            $req.Credentials=New-Creds
            $req.GetResponse().Close()
        } catch {}
    }
}

function Save-Manifest($manifest,$remoteRoot){

    $tmp=Join-Path $env:RUNNER_TEMP "manifest.txt"

    $manifest.GetEnumerator() |
        ForEach-Object { "$($_.Key)|$($_.Value)" } |
        Set-Content $tmp

    Upload-File $tmp "$remoteRoot/$manifestName"
}

function Mirror($localRoot,$remoteRoot){

    Write-Host "=== MIRROR $localRoot -> $remoteRoot ==="

    Write-Host "Build local manifest..."
    $local=Get-HashManifest $localRoot

    Write-Host "Download remote manifest..."
    $remote=Download-Manifest $remoteRoot

    # Upload nouveaux / modifiés
    foreach($file in $local.Keys){

        if($remote[$file] -eq $local[$file]){
            continue
        }

        Write-Host "UPLOAD $file"

        Ensure-Dirs "$remoteRoot/$file"
        Upload-File "$localRoot/$file" "$remoteRoot/$file"
    }

    # Purge fichiers supprimés
    foreach($file in $remote.Keys){

        if(-not $local.ContainsKey($file)){
            Delete-File "$remoteRoot/$file"
        }
    }

    Save-Manifest $local $remoteRoot
}

# ---- DEPLOIEMENTS ----

Mirror "releng/com.b3dgs.lionengine.editor.repository/target/repository" ""
Mirror "releng/com.b3dgs.lionengine.editor.product/target/products" "/product"

Write-Host "FTP mirror finished."