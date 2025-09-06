# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

from __future__ import absolute_import, division, print_function
import subprocess
import signal

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black,
    blue,
    cyan,
    green,
    magenta,
    red,
    white,
    yellow,
    default,
    normal,
    bold,
    reverse,
    dim,
    BRIGHT,
    default_colors,
)


class AttrDict(dict):
    def __getattr__(self, name):
        if name in self:
            return self[name]
        raise AttributeError(f"'AttrDict' object has no attribute '{name}'")

    def __setattr__(self, name, value):
        self[name] = value

    def __delattr__(self, name):
        if name in self:
            del self[name]
        else:
            raise AttributeError(f"'AttrDict' object has no attribute '{name}'")


class Default(ColorScheme):
    progress_bar_color = blue

    palette_light = AttrDict({"directory": 0})
    palette_dark = AttrDict({"directory": 250})
    palette_dark.vcsignored = 70
    palette_light.vcsignored = 0

    colors = AttrDict({})

    darkmode: bool
    lightmode: bool

    _instance = None  # Singleton to access from signal handler

    def __init__(self):
        import os
        import shutil

        # Check if gsettings is available
        if shutil.which("gsettings"):
            try:
                result = subprocess.run(
                    ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
                    capture_output=True,
                    text=True,
                )
                gnome_mode = result.stdout.strip().strip("'")
                if gnome_mode in ("default", "prefer-light"):
                    self.colors = self.palette_light
                    self.darkmode = False
                    self.lightmode = True
                    return
                if gnome_mode == "prefer-dark":
                    self.colors = self.palette_dark
                    self.darkmode = True
                    self.lightmode = False
                    return
            except:
                pass

        # Fallback to environment variable or default dark theme
        kt_darkmode = os.environ.get("KT_DARKMODE", "darkmode")
        if kt_darkmode == "lightmode":
            self.darkmode = True
            self.lightmode = False

        Default._instance = self
        self._setup_signal_handler()
        self._update_theme()
        # result = subprocess.run(
        #     ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
        #     capture_output=True,
        #     text=True,
        # )
        #
        # gnome_mode = result.stdout.strip().strip("'")
        # if gnome_mode in ("default", "prefer-light"):
        #     self.colors = self.palette_light
        #     self.darkmode = False
        #     self.lightmode = True
        # if gnome_mode == "prefer-dark":
        #     self.colors = self.palette_dark
        #     self.darkmode = True
        #     self.lightmode = False

    def _setup_signal_handler(self):
        signal.signal(signal.SIGUSR2, Default._global_theme_reload_handler)

    @staticmethod
    def _global_theme_reload_handler(signum, frame):
        """Static signal handler that can access the instance"""
        print("git sigusr2")
        if Default._instance:
            print("git sigusr2: is Default._instance")
            Default._instance._update_theme()
            Default._instance._force_redraw()

    def _force_redraw(self):
        """Force ranger to redraw the interface"""
        try:
            # Try to access ranger's file manager instance
            import ranger.core.fm
            import ranger.api

            # This might work depending on ranger version
            fm = ranger.api.current_fm()
            if fm and hasattr(fm, "ui"):
                fm.ui.need_redraw = True
                fm.ui.redraw_window()
        except:
            # Fallback - just update colors, ranger will redraw eventually
            pass

    def _update_theme(self):
        result = subprocess.run(
            ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
            capture_output=True,
            text=True,
        )
        gnome_mode = result.stdout.strip().strip("'")
        if gnome_mode in ("default", "prefer-light"):
            self.colors = self.palette_light
            self.darkmode = False
            self.lightmode = True
        else:
            # Default to dark theme
            self.colors = self.palette_dark
            self.darkmode = True
            self.lightmode = False

    def use(self, context):  # pylint: disable=too-many-branches,too-many-statements
        fg, bg, attr = default_colors

        colors = self.colors

        lightmode = self.lightmode
        darkmode = self.darkmode

        github_added = 40  # Green background
        github_modified = 39  # DeepSkyBlue1 #00AFFF
        github_untracked = 129  # Purple
        github_conflicted = 196  # Bright red
        github_unknown = 196  # Bright red

        if context.reset:
            return default_colors

        elif context.in_browser:
            # if context.selected:
            #     # attr = reverse
            #     bg = 35
            #     fg = 118
            # else:
            #     attr = normal
            if context.empty or context.error:
                bg = red
            if context.border:
                fg = default
            if context.media:
                if context.image:
                    fg = yellow
                else:
                    fg = magenta
            if context.container:
                fg = red
            if context.directory:
                attr |= bold
                # fg = 20 # dark blue, works, but let's be more experimental for now.
                # fg = 240
                # fg = c["directory"]
                fg = colors.directory
                # fg = blue
                # fg += BRIGHT
                # bg = 253
            elif context.executable and not any(
                (context.media, context.container, context.fifo, context.socket)
            ):
                attr |= bold
                fg = 35
            if context.socket:
                attr |= bold
                fg = magenta
                fg += BRIGHT
            if context.fifo or context.device:
                fg = yellow
                if context.device:
                    attr |= bold
                    fg += BRIGHT
            if context.link:
                fg = 33 if context.good else 160
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
                fg += BRIGHT
            if (
                hasattr(context, "line_number")
                and context.line_number
                and not context.selected
            ):
                fg = default
                attr &= ~bold
            if not context.selected and (context.cut or context.copied):
                attr |= bold
                fg = black
                fg += BRIGHT
                # If the terminal doesn't support bright colors, use dim white
                # instead of black.
                if BRIGHT == 0:
                    attr |= dim
                    fg = white
            if context.main_column:
                # Doubling up with BRIGHT here causes issues because it's
                # additive not idempotent.
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    # fg = yellow
                    bg = 195
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

            if context.inactive_pane:
                fg = cyan

            if context.selected:
                attr |= bold
                if darkmode:
                    # attr = reverse
                    fg = 0
                    bg = 70
                elif lightmode:
                    # bg = 35
                    # fg = 118
                    # bg = 118  # Chartreuse1   #87ff00
                    bg = 154  # GreenYellow   #afff00
                    # bg = 76  # Chartreuse3 #5fd700
                    # fg = 15

        elif context.in_titlebar:
            if context.hostname:
                fg = red if context.bad else green
            elif context.directory:
                # fg = c["directory"]
                fg = 28
            elif context.tab:
                if context.good:
                    bg = 34
                    fg = 15
            elif context.link:
                fg = cyan
            attr |= bold

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = cyan
                elif context.bad:
                    fg = magenta
            if context.marked:
                attr |= bold | reverse
                fg = yellow
                fg += BRIGHT
            if context.frozen:
                attr |= bold | reverse
                fg = cyan
                fg += BRIGHT
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = red
                    fg += BRIGHT
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = blue
                attr &= ~bold
            if context.vcscommit:
                fg = 28  # Dark green for committed files
                # fg = yellow
                # attr &= ~bold
            if context.vcsdate:
                fg = cyan
                attr &= ~bold

        if context.text:
            if context.highlight:
                # attr |= reverse
                fg = 206

        if context.in_taskview:
            if context.title:
                fg = blue

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        # if context.vcsfile and not context.selected:
        if context.vcsfile:
            attr &= ~bold
            if context.vcsconflict:
                fg = 15
                bg = github_conflicted
            elif context.vcsuntracked:
                bg = 93
                fg = 200
            elif context.vcschanged:
                fg = 51
                bg = github_modified
            elif context.vcsunknown:
                fg = 15
                bg = github_untracked
            elif context.vcsstaged:
                fg = 154
                bg = github_added
            elif context.vcssync:
                fg = 28
            elif context.vcsignored:
                fg = colors.vcsignored

        # elif context.vcsremote and not context.selected:
        elif context.vcsremote:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = green
            elif context.vcsbehind:
                fg = 220  # gold
                bg = 202  # orange
            elif context.vcsahead:
                fg = 154
                bg = github_added
            elif context.vcsdiverged:
                fg = 196
                bg = 124
            elif context.vcsunknown:
                fg = 15
                bg = github_unknown

        return fg, bg, attr
