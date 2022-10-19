#/bin/python

import os
from pathlib import Path
import pathlib

SYMLINK_FOLDERS = {
        "~/dotfiles/config/autokey/data/Freeo": "~/.config/autokey/data/Freeo",
        "~/dotfiles/config/kitty":  "~/.config/kitty",
        }

SYMLINK_FILES = {
        "~/dotfiles/config/awesome/rc4.3-git.lua": "~/.config/awesome/rc.lua",
    }


def create_symlinks(symlink_dict):
    for src, dst in symlink_dict.items():
        p_src = os.path.expanduser(src)
        p_dst = os.path.expanduser(dst)
        if os.path.exists(p_dst):
            print(f"skip - already exists: {p_dst} ")
        else:
            Path(pathlib.PurePath(dst).parent).mkdir(parents=True, exist_ok=True)
            os.symlink(p_src, p_dst)
            if os.path.exists(p_dst):
                print(f"created symlink {p_dst}")


