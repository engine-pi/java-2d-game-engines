

add_all: \
    (add_subtree "litiengine" "https://github.com/gurkenlabs/litiengine.git" "main") \
    (add_subtree "engine-alpha" "https://github.com/engine-alpha/engine-alpha.git" "4.x")

add_subtree prefix repository branch:
    -git subtree add --prefix {{prefix}} {{repository}} {{branch}}
