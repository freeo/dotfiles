#!/usr/bin/env python3
import argparse, mido, subprocess, sys


def lua_quote(s: str) -> str:
    # Quote for Lua single-quoted string
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'") + "'"


def lua_num(x):
    return "nil" if x is None else str(int(x))


def build_lua(ev):
    # ev is a dict with type, note, velocity, control, value, channel, device
    return (
        "awesome.emit_signal('midi::event', {"
        f"type={lua_quote(ev['type'])}, "
        f"note={lua_num(ev.get('note'))}, "
        f"velocity={lua_num(ev.get('velocity'))}, "
        f"control={lua_num(ev.get('control'))}, "
        f"value={lua_num(ev.get('value'))}, "
        f"channel={lua_num(ev.get('channel'))}, "
        f"device={lua_quote(ev['device'])}"
        "})"
    )


def open_input(name_substr):
    names = mido.get_input_names()
    if name_substr is None:
        return mido.open_input()  # default
    for n in names:
        if name_substr in n:
            return mido.open_input(n)
    print("No matching MIDI input for:", name_substr, file=sys.stderr)
    print("Available:", *names, sep="\n  ", file=sys.stderr)
    sys.exit(1)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("-d", "--device", help="MIDI input port (substring match)")
    p.add_argument("-c", "--channel", type=int, help="Filter to this channel (1-16)")
    args = p.parse_args()

    with open_input(args.device) as port:
        for msg in port:
            # Keep only useful event types for button-y controllers
            if msg.type not in ("note_on", "note_off", "control_change"):
                continue
            ch = getattr(msg, "channel", None)
            if args.channel and ch is not None and (ch + 1) != args.channel:
                continue

            ev = {
                "type": msg.type,
                "note": getattr(msg, "note", None),
                "velocity": getattr(msg, "velocity", None),
                "control": getattr(msg, "control", None),
                "value": getattr(msg, "value", None),
                "channel": (ch + 1) if ch is not None else None,  # 1..16
                "device": port.name or "unknown",
            }
            lua = build_lua(ev)
            # Fire-and-forget; if you spam tons of messages, consider batching
            subprocess.run(["awesome-client", lua], check=False)


if __name__ == "__main__":
    main()
