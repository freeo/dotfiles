c.TerminalInteractiveShell.editing_mode = 'vi'
# c.TerminalInteractiveShell.editing_mode = 'emacs'
c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.editor = 'nvim'
c.TerminalInteractiveShell.sphinxify_docstring = True
from pprint import pprint as pp

# c.TerminalIPythonApp.display_banner = False

# Vi mode cursor shape: Block & Line (CMD & INS mode)
# https://github.com/prompt-toolkit/python-prompt-toolkit/issues/192#issuecomment-557800620
import sys
from prompt_toolkit.key_binding.vi_state import InputMode, ViState
def get_input_mode(self):
    if sys.version_info[0] == 3:
        # Decrease input flush timeout from 500ms to 10ms.
        from prompt_toolkit.application.current import get_app
        app = get_app()
        app.ttimeoutlen = 0.01
    return self._input_mode
def set_input_mode(self, mode):
    shape = {InputMode.NAVIGATION: 2, InputMode.REPLACE: 4}.get(mode, 6)
    cursor = "\x1b[{} q".format(shape)
    if hasattr(sys.stdout, "_cli"):
        write = sys.stdout._cli.output.write_raw
    else:
        write = sys.stdout.write
    write(cursor)
    sys.stdout.flush()
    self._input_mode = mode
ViState._input_mode = InputMode.INSERT
ViState.input_mode = property(get_input_mode, set_input_mode)
print("Has: vi mode cursor shape")


