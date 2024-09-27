#!/bin/bash
if lsmod | grep -q amdgpu; then
    echo "/home/freeo/dotfiles/config/awesome/widgets/gpuicon/ryzen-logo.png"
elif lsmod | grep -q nvidia; then
    echo "/home/freeo/dotfiles/config/awesome/widgets/gpuicon/nvidia-icon.png"
fi
