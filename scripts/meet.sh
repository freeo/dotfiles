#!/bin/bash

virtcam
easyeffects &
obs --args --startvirtualcam &
# flatpak run com.obsproject.Studio --args --startvirtualcam &
# default = ArthurJay, because it's the first that I've setup
google-chrome-stable --profile-directory="Profile 2"
