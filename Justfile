

add_all: \
    (add_subtree "litiengine" "https://github.com/gurkenlabs/litiengine.git") \
    (add_subtree "engine-alpha" "https://github.com/engine-alpha/engine-alpha.git")

add_subtree prefix repository:
    -git subtree add --prefix {{prefix}} {{repository}} main
