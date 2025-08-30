#!/usr/bin/env bash

# session-fzf - popup session switcher for tmux

tmux list-sessions -F "#{session_name}" 2>/dev/null | \
    grep -v "^$(tmux display-message -p '#S')$" | \
    fzf --reverse \
        --header="🔄 Switch to Session" \
        --border=rounded \
        --height=40% \
        --preview='tmux list-windows -t {} -F "#{window_index}: #{window_name} #{window_flags}"' \
        --preview-window=right:50%:wrap | \
    xargs -I {} tmux switch-client -t {}