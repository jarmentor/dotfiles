#!/usr/bin/env bash
# Simple preview helper to avoid complex fzf preview syntax

item="$1"

if [[ "$item" == "Create Main Session" ]]; then
    echo "Create and switch to main session"
elif [[ "$item" == kill:* ]]; then
    echo "Kill session: ${item#kill: }"
elif [[ "$item" == *"(current)" ]]; then
    echo "Current session - cannot switch to self"
elif tmux has-session -t "$item" 2>/dev/null; then
    tmux list-windows -t "$item" -F "#{window_index}: #{window_name} #{window_flags}"
else
    ls -la "$item" 2>/dev/null || echo "Directory preview"
fi