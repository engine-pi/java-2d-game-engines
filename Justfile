

add_all: \
    (add_subtree "engine-alpha" "https://github.com/engine-alpha/engine-alpha.git" "4.x") \
    (add_subtree "fastj" "https://github.com/fastjengine/FastJ.git" "main") \
    (add_subtree "fxgl" "https://github.com/AlmasB/FXGL.git" "dev") \
    (add_subtree "lionengine" "https://github.com/b3dgs/lionengine.git" "master") \
    (add_subtree "litiengine" "https://github.com/gurkenlabs/litiengine.git" "main") \
    (add_subtree "lwjgl3" "https://github.com/LWJGL/lwjgl3.git" "master") \
    (add_subtree "mage" "https://github.com/magefree/mage.git" "master") \
    (add_subtree "mini2dx" "https://github.com/mini2Dx/mini2Dx.git" "master") \
    (add_subtree "playn" "https://github.com/playn/playn.git" "master") \
    # (add_subtree "lgame" "https://github.com/cping/LGame.git" "master") \ zu groß!
add_subtree prefix repository branch:
    -git subtree add --prefix {{prefix}} {{repository}} {{branch}}
