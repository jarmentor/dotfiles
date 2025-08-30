#!/usr/bin/env bash

# session-fzf - popup session switcher for tmux

current_session=$(tmux display-message -p '#S')
sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -v "^$current_session$")

# Check if main session exists
has_main=$(echo "$sessions" | grep -c "^main$" || true)

# Build options list
options=""
if [[ $has_main -eq 0 ]]; then
    options="Create Main Session"$'\n'
fi

# Ensure spotify session appears if it exists (even if hidden)
if tmux has-session -t spotify 2>/dev/null && [[ "$current_session" != "spotify" ]]; then
    sessions=$(echo -e "$sessions\nspotify" | sort -u)
fi

options="$options$sessions"

# Show fzf picker
selected=$(echo "$options" | \
    fzf --reverse \
        --header="Switch to Session" \
        --border=rounded \
        --height=40% \
        --preview='if [[ {} == "Create Main Session" ]]; then echo "Create and switch to main session"; else tmux list-windows -t {} -F "#{window_index}: #{window_name} #{window_flags}" 2>/dev/null || echo "Session not found"; fi' \
        --preview-window=right:50%:wrap)

if [[ -n "$selected" ]]; then
    if [[ "$selected" == "Create Main Session" ]]; then
        tmux new-session -d -s main
        tmux switch-client -t main
    else
        tmux switch-client -t "$selected"
    fi
fi