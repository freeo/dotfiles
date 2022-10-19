import os
import pathlib

from .install import create_symlinks
# import .install

TEST_DIR=os.path.expanduser("~/dotfiles/config/tmp_test")

def setup():
    pathlib.Path(pathlib.PurePath(TEST_DIR)).mkdir(parents=True, exist_ok=True)
    print(TEST_DIR)

    return {
            TEST_DIR:  "~/.config/tmp_test_hurr",
            "~/dotfiles/config/test_install.py": "~/.config/test_install.py",
        }

def teardown():
    os.rmdir(TEST_DIR)
    os.remove("~/.config/test_install.py")

def test_create_symlink():
    i = setup()
    create_symlinks(i)
    teardown()
