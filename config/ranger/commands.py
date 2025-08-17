# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import absolute_import, division, print_function

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()


class fzf_rg_search(Command):
    """
    :fzf_rg_search_documents
    Search in PDFs, E-Books and Office documents in current directory

    Usage: fzf_rga_search_documents <search string>
    """

    def execute(self):
        if self.arg(1):
            search_string = self.rest(1)
        else:
            self.fm.notify("Usage: fzf_rga_search_documents <search string>", bad=True)
            return

        import subprocess
        import os.path
        from ranger.container.file import File

        command = "rg '%s' . | fzf +m | awk -F':' '{print $1}'" % search_string
        fzf = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip("\n"))
            self.fm.execute_file(File(fzf_file))


from collections import deque


class fd_search(Command):
    """
    :fd_search [-d<depth>] <query>
    Executes "fd -d<depth> <query>" in the current directory and focuses the
    first match. <depth> defaults to 1, i.e. only the contents of the current
    directory.

    See https://github.com/sharkdp/fd
    """

    SEARCH_RESULTS = deque()

    def execute(self):
        import re
        import subprocess
        from ranger.ext.get_executables import get_executables

        self.SEARCH_RESULTS.clear()

        if "fdfind" in get_executables():
            fd = "fdfind"
        elif "fd" in get_executables():
            fd = "fd"
        else:
            self.fm.notify("Couldn't find fd in the PATH.", bad=True)
            return

        if self.arg(1):
            if self.arg(1)[:2] == "-d":
                depth = self.arg(1)
                target = self.rest(2)
            else:
                depth = "-d1"
                target = self.rest(1)
        else:
            self.fm.notify(":fd_search needs a query.", bad=True)
            return

        hidden = "--hidden" if self.fm.settings.show_hidden else ""
        exclude = "--no-ignore-vcs --exclude '.git' --exclude '*.py[co]' --exclude '__pycache__'"
        command = "{} --follow {} {} {} --print0 {}".format(
            fd, depth, hidden, exclude, target
        )
        fd = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = fd.communicate()

        if fd.returncode == 0:
            results = filter(None, stdout.split("\0"))
            if not self.fm.settings.show_hidden and self.fm.settings.hidden_filter:
                hidden_filter = re.compile(self.fm.settings.hidden_filter)
                results = filter(
                    lambda res: not hidden_filter.search(os.path.basename(res)), results
                )
            results = map(
                lambda res: os.path.abspath(os.path.join(self.fm.thisdir.path, res)),
                results,
            )
            self.SEARCH_RESULTS.extend(sorted(results, key=str.lower))
            if len(self.SEARCH_RESULTS) > 0:
                self.fm.notify(
                    "Found {} result{}.".format(
                        len(self.SEARCH_RESULTS),
                        ("s" if len(self.SEARCH_RESULTS) > 1 else ""),
                    )
                )
                self.fm.select_file(self.SEARCH_RESULTS[0])
            else:
                self.fm.notify("No results found.")


class fd_next(Command):
    """
    :fd_next
    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(fd_search.SEARCH_RESULTS) > 1:
            fd_search.SEARCH_RESULTS.rotate(-1)  # rotate left
            self.fm.select_file(fd_search.SEARCH_RESULTS[0])
        elif len(fd_search.SEARCH_RESULTS) == 1:
            self.fm.select_file(fd_search.SEARCH_RESULTS[0])


class fd_prev(Command):
    """
    :fd_prev
    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(fd_search.SEARCH_RESULTS) > 1:
            fd_search.SEARCH_RESULTS.rotate(1)  # rotate right
            self.fm.select_file(fd_search.SEARCH_RESULTS[0])
        elif len(fd_search.SEARCH_RESULTS) == 1:
            self.fm.select_file(fd_search.SEARCH_RESULTS[0])


class fzf_select(Command):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import subprocess
        import os
        from ranger.ext.get_executables import get_executables

        if "fzf" not in get_executables():
            self.fm.notify("Could not find fzf in the PATH.", bad=True)
            return

        fd = None
        if "fdfind" in get_executables():
            fd = "fdfind"
        elif "fd" in get_executables():
            fd = "fd"

        if fd is not None:
            hidden = "--hidden" if self.fm.settings.show_hidden else ""
            exclude = "--no-ignore-vcs --exclude '.git' --exclude '*.py[co]' --exclude '__pycache__'"
            only_directories = "--type directory" if self.quantifier else ""
            fzf_default_command = "{} --follow {} {} {} --color=always".format(
                fd, hidden, exclude, only_directories
            )
        else:
            hidden = (
                "-false" if self.fm.settings.show_hidden else r"-path '*/\.*' -prune"
            )
            exclude = r"\( -name '\.git' -o -iname '\.*py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
            only_directories = "-type d" if self.quantifier else ""
            fzf_default_command = (
                "find -L . -mindepth 1 {} -o {} -o {} -print | cut -b3-".format(
                    hidden, exclude, only_directories
                )
            )

        env = os.environ.copy()
        env["FZF_DEFAULT_COMMAND"] = fzf_default_command
        env["FZF_DEFAULT_OPTS"] = (
            '--height=40% --layout=reverse --ansi --preview="{}"'.format(
                """
            (
                batcat --color=always {} ||
                bat --color=always {} ||
                cat {} ||
                tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {}
            ) 2>/dev/null | head -n 100
        """
            )
        )

        fzf = self.fm.execute_command(
            "fzf --no-multi", env=env, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


class sk_select(Command):
    def execute(self):
        import subprocess
        from ranger.ext.get_executables import get_executables

        if "sk" not in get_executables():
            self.fm.notify("Could not find skim", bad=True)
            return

        sk = self.fm.execute_command(
            "sk ", universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = sk.communicate()
        if sk.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


class tv_files_select(Command):
    def execute(self):
        import subprocess
        from ranger.ext.get_executables import get_executables

        if "tv" not in get_executables():
            self.fm.notify("Could not find tv(television)", bad=True)
            return

        tv = self.fm.execute_command(
            "tv files ", universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = tv.communicate()
        if tv.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


class tv_text_select(Command):
    def execute(self):
        import subprocess
        from ranger.ext.get_executables import get_executables

        if "tv" not in get_executables():
            self.fm.notify("Could not find tv(television)", bad=True)
            return

        tv = self.fm.execute_command(
            "tv text ", universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = tv.communicate()
        if tv.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


class tv_ranger_select(Command):
    def execute(self):
        import subprocess
        from ranger.ext.get_executables import get_executables

        if "tv" not in get_executables():
            self.fm.notify("Could not find tv(television)", bad=True)
            return

        # 'fd --type d | tv dirs --preview "eza -a --icons=always --color=always --color-scale --oneline {}"',
        # tv ranger: defined here:
        # /home/freeo/dotfiles/config/television/custom_channels.toml
        # 'tv ranger --passthrough-keybindings "tab"', # passthrough was removed...
        tv = self.fm.execute_command(
            "tv ranger",
            universal_newlines=True,
            stdout=subprocess.PIPE,
        )
        stdout, _ = tv.communicate()
        if tv.returncode == 0:
            # tv: undo single quotes
            # tv wraps elements with space chars in general with single quotes
            # the passthrough-keybinding somehow add's "tab\n" to the tv output.
            # selected = os.path.abspath(stdout.strip().strip("'").strip("tab\n"))
            selected = os.path.abspath(
                stdout.strip().strip("'").replace("tab\n", "", 1)
            )
            self.fm.notify(selected, bad=False)
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


class tab_switch_or_create(Command):
    """
    :tab_switch_or_create <number>

    Switch to the tab number if it exists, otherwise create a new tab.
    """

    def execute(self):
        tab_number = int(self.arg(1))
        if tab_number <= len(self.fm.tabs):
            self.fm.tab_move(tab_number - 1)
        else:
            self.fm.tab_new()
            self.fm.tab_move(tab_number - 1)


class diff(Command):
    def execute(self):
        if len(self.fm.thistab.get_selection()) != 2:
            self.fm.notify("Please select exactly two files to diff", bad=True)
            return

        file1, file2 = self.fm.thistab.get_selection()
        self.fm.run(f"nvim -d '{file1.path}' '{file2.path}'")

    def tab(self, tabnum):
        return self._tab_directory_content()


# class vim_open(Command):
class v(Command):
    def execute(self):
        import subprocess
        from ranger.ext.get_executables import get_executables

        if "nvim" not in get_executables():
            self.fm.notify("Could not find neovim", bad=True)
            return

        r = self.fm.execute_command(
            "nvim -c 'lua Snacks.explorer({focus = \"input\"})'"
        )
        self.fm.notify(r, bad=True)


# Add this to your ~/.config/ranger/rc.conf file


class view_minimal(Command):
    def execute(self):
        self.fm.settings.viewmode = "miller"
        self.fm.settings.column_ratios = [1]
        self.fm.settings.preview_files = False
        self.fm.settings.preview_directories = False
        self.fm.settings.preview_images = False
        self.fm.settings.display_size_in_main_column = False
        self.fm.settings.display_size_in_status_bar = False
        # self.fm.notify("Minimal view enabled")
        self.fm.ui.redraw_window()


class view_normal(Command):
    def execute(self):
        self.fm.settings.viewmode = "miller"
        self.fm.settings.column_ratios = [1, 3, 4]
        self.fm.settings.preview_files = True
        self.fm.settings.preview_directories = True
        self.fm.settings.preview_images = True
        self.fm.settings.display_size_in_main_column = True
        self.fm.settings.display_size_in_status_bar = True
        # self.fm.notify("Normal view enabled")
        self.fm.ui.redraw_window()


class toggle_minimal(Command):
    """Toggle between minimal single column view and normal multi-column view"""

    def execute(self):
        # Check current state by looking at column ratios
        current_ratios = self.fm.settings.column_ratios

        # If we're in single column mode (minimal), switch to normal
        if current_ratios == [1, 1]:
            # Create instance and call execute with access to self.fm
            view_normal_cmd = view_normal("")
            view_normal_cmd.fm = self.fm
            view_normal_cmd.execute()
            # self.fm.notify("Switched to normal view")
        else:
            # Create instance and call execute with access to self.fm
            view_minimal_cmd = view_minimal("")
            view_minimal_cmd.fm = self.fm
            view_minimal_cmd.execute()
            # self.fm.notify("Switched to minimal view")
