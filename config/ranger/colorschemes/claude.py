# ~/.config/ranger/colorschemes/git_enhanced.py
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *


class GitEnhanced(ColorScheme):
    def use(self, context):
        fg, bg, attr = default_colors

        if context.in_browser:
            # GitHub-style colors
            github_added = 40  # Green background
            github_modified = 172  # Orange-ish
            github_deleted = 160  # Red
            github_renamed = 69  # Blue
            github_untracked = 128  # Purple
            github_conflicted = 196  # Bright red

            # Default attributes for files/directories
            if context.directory:
                fg = 27
            elif context.file:
                fg = 244

            # Git status coloring with GitHub-like colors
            # if context.vcscommitted:
            if context.vcscommit:
                fg = 28  # Dark green for committed files
            elif context.vcschanged:
                fg = github_modified
                bg = 235  # Slight background highlight for modified
                attr |= bold | reverse
            elif context.vcsunknown:
                fg = github_untracked
                bg = 235  # Slight background highlight
                attr |= bold
            elif context.vcsignored:
                fg = 242  # Dimmed color for ignored files
            elif context.vcsstaged:
                fg = github_added
                bg = 235  # Slight background highlight
                attr |= bold
            # elif context.vcsdirty:
            #     fg = github_modified
            #     bg = 235  # Slight background highlight
            #     attr |= bold | reverse
            elif context.vcsuntracked:
                fg = github_untracked
                attr |= bold
            # elif context.vcsdeleted:
            #     fg = github_deleted
            #     bg = 235  # Slight background highlight
            #     attr |= bold | reverse
            elif context.vcsconflict:
                fg = github_conflicted
                bg = 235  # Slight background highlight
                attr |= bold | reverse

        # Keep other context handlers from the default colorscheme
        if context.reset:
            return default_colors

        elif context.in_titlebar:
            if context.hostname:
                fg = 220 if context.bad else 120
            elif context.directory:
                fg = 33
            elif context.tab:
                fg = 47 if context.good else 196
            elif context.link:
                fg = cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 108
                elif context.bad:
                    fg = 174
            if context.marked:
                attr |= bold | reverse
                fg = 223
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 174
            if context.loaded:
                bg = 146
                fg = 0

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 116

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = 246
                    bg = 156
                else:
                    fg = 156
                    bg = 246

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 160
            elif context.vcschanged:
                fg = 172
            elif context.vcsunknown:
                fg = 128
            elif context.vcsstaged:
                fg = 40
            elif context.vcssync:
                fg = 28
            elif context.vcsignored:
                fg = 238

        return fg, bg, attr
