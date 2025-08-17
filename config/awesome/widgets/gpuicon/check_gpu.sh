#!/bin/bash
if lsmod | rg -q nvidia; then
    echo "/home/freeo/dotfiles/config/awesome/widgets/gpuicon/nvidia-icon.png"
elif lsmod | rg -q amdgpu; then
    echo "/home/freeo/dotfiles/config/awesome/widgets/gpuicon/ryzen-logo.png"
fi
# issue: suddenly it always shows just amd. Probably because AMD is loaded now by default as well. NOTE: grep -q is completely silent! Important for the "if" and how this message is processed in the calling parten (awm lua)
# OUTDATED, BROKEN
# if lsmod | grep -q amdgpu; then
#     echo "/home/freeo/dotfiles/config/awesome/widgets/gpuicon/ryzen-logo.png"
# elif lsmod | grep -q nvidia; then
#     echo "/home/freeo/dotfiles/config/awesome/widgets/gpuicon/nvidia-icon.png"
# fi
