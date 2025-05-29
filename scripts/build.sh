#!/bin/bash

PROJECT_NAME="my-game"
SRC_DIR="src"
ASSETS_DIR="assets"
BUILD_DIR="build"

# Create build directories
mkdir -p $BUILD_DIR/dev $BUILD_DIR/prod

# Development build
p8tool build $BUILD_DIR/dev/${PROJECT_NAME}_dev.p8.png \
    --lua $SRC_DIR/main.lua \
    --gfx $ASSETS_DIR/sprites.p8.png \
    --sfx $ASSETS_DIR/audio.p8.png \
    --music $ASSETS_DIR/audio.p8.png \
    --lua-format

# Production build
p8tool build $BUILD_DIR/prod/${PROJECT_NAME}_prod.p8.png \
    --lua $SRC_DIR/main.lua \
    --gfx $ASSETS_DIR/sprites.p8.png \
    --sfx $ASSETS_DIR/audio.p8.png \
    --music $ASSETS_DIR/audio.p8.png \
    --lua-minify \
    --keep-names-from-file=config/preserve_names.txt

# Copy final distribution
cp $BUILD_DIR/prod/${PROJECT_NAME}_prod.p8.png ${PROJECT_NAME}.p8.png

echo "Build complete!"
p8tool stats ${PROJECT_NAME}.p8.png


# Troubleshooting:
# - Make sure you have the p8tool installed and available in your PATH.
# - If you encounter permission issues, you may need to make this script executable:
#   chmod +x scripts/build.sh