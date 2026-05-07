#!/bin/bash

if ! command -v jq >/dev/null; then
    echo "jq is required to update Windows Terminal settings" >&2
    exit 1
fi

settings="$LOCALAPPDATA/Packages"
settings+="/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
action_id="User.sendInput.CtrlSpace"

if [ ! -f "$settings" ]; then
    exit 0
fi

if jq -e ".actions[]? | select(.id == \"$action_id\")" \
    "$settings" >/dev/null 2>&1
then
    echo "@ windows terminal"
    exit 0
fi

tmp="$settings.tmp"
jq --arg id "$action_id" '
    .actions += [{
        "command": {
            "action": "sendInput",
            "input": "\u001b[32;5u"
        },
        "id": $id
    }]
    | .keybindings += [{
        "id": $id,
        "keys": "ctrl+space"
    }]
' "$settings" > "$tmp"
mv "$tmp" "$settings"
echo "+ windows terminal"
