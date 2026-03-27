#!/usr/bin/env bash
set -e

pip install --upgrade pip
pip install fastapi uvicorn python-multipart pillow numpy timm opencv-python-headless
pip install torch==2.1.0 torchvision==0.16.0 --index-url https://download.pytorch.org/whl/cpu

# Copy model checkpoint to a known location for runtime
echo "Copying model checkpoint..."
if [ -f "best.pth" ]; then
    cp best.pth /opt/render/.local/lib/python3.10/site-packages/best.pth || true
    echo "Model copied to site-packages"
fi

if [ -d "experiments" ]; then
    echo "Experiments directory exists"
fi

echo "Build complete!"