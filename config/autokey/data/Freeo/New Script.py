import time

#.set_global_value("is_active",False)

def toggle_wa():
    if store.get_global_value("is_active"):
        store.set_global_value("is_active",False)
        #keyboard.send_key("n")
        keyboard.press_key("w")
        keyboard.press_key("a")
    else:    
        store.set_global_value("is_active",True)
        #keyboard.send_key("f")
        keyboard.release_key("w")
        keyboard.release_key("a")

toggle_wa()

