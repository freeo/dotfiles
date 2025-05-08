#!/usr/bin/python
#
# Select a rc config file with fzf and edit it

# from pyfzf.pyfzf import FzfPrompt
import subprocess
import json
import tempfile
import os

data_d = {
    "zsh": "$EDITOR ~/.zshrc",
    "neovim": "$EDITOR ~/.config/nvim/init.vim",
    "awesome": "$EDITOR ~/.config/awesome/rc.lua",
    "kitty": "$EDITOR ~/.config/kitty/kitty.conf",
}


data = [
    "$EDITOR ~/.zshrc",
    "$EDITOR ~/.config/nvim/init.vim",
    "$EDITOR ~/.config/awesome/rc.lua",
    "$EDITOR ~/.config/kitty/kitty.conf",
]

data = [
    "nvim ~/.zshrc",
    "nvim ~/.config/nvim/init.vim",
    "nvim ~/.config/awesome/rc.lua",
    "nvim ~/.config/kitty/kitty.conf",
]
#
# # Prepare the input
# input_data = "\n".join(data).encode()
#
# # Run tv in the foreground
# process = subprocess.Popen(
#     ["tv", "files", "--delimiter=;"],
#     stdin=subprocess.PIPE,
#     stdout=subprocess.PIPE,
#     stderr=subprocess.PIPE
# )
#
# # Send the input data
# stdout, stderr = process.communicate(input=input_data)
#
# # Get the selected value
# selected = stdout.decode().strip()
#
# print(f"Selected value: {selected}")

# -------------------


# Create a temporary file to store the input data
with tempfile.NamedTemporaryFile(mode="w", delete=False) as temp_file:
    temp_file.write("\n".join(data))
    temp_file_path = temp_file.name

# Run tv in the foreground
command = f"cat {temp_file_path} | tv files --delimiter=;"
selected = os.popen(command).read().strip()

# Clean up the temporary file
os.unlink(temp_file_path)

# print(f"Selected value: {selected}")

process = subprocess.run(selected, shell=True)
