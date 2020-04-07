# jk smash escape
# https://ipython.readthedocs.io/en/stable/config/details.html#keyboard-shortcuts
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import HasFocus, ViInsertMode
from prompt_toolkit.key_binding.vi_state import InputMode


# print(getattr(ip, 'pt_app', None))

def switch_to_navigation_mode(event):
   vi_state = event.cli.vi_state
   vi_state.input_mode = InputMode.NAVIGATION

if getattr(ip, 'pt_app', None):
    registry = ip.pt_app.key_bindings
    registry.add_binding(u'j',u'k', filter=(HasFocus(DEFAULT_BUFFER) & ViInsertMode()))(switch_to_navigation_mode)
    print("jk smash escape initialized!")
