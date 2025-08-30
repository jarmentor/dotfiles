#!/usr/bin/env bash

# tmux-sessionizer - custom for jarmentor's workflow
# Creates/switches to project sessions while preserving main session

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Search your main development paths
    selected=$(find /Volumes/Development -mindepth 1 -maxdepth 2 -type d \
        -not -path '*/\.*' \
        -not -path '*/node_modules' \
        -not -path '*/vendor' \
        -not -path '*/.git' \
        2>/dev/null | \
        fzf --reverse \
            --header="🚀 Select Project Directory" \
            --border=rounded \
            --height=40% \
            --preview='ls -la {}' \
            --preview-window=right:50%:wrap)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# If not in tmux and tmux isn't running, create new session
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

# If session doesn't exist, create it detached
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -d -s $selected_name -c $selected
fi

# Switch to the session
if [[ -z $TMUX ]]; then
    # Not in tmux, attach directly
    tmux attach -t $selected_name
else
    # In tmux, switch client
    tmux switch-client -t $selected_name
fi