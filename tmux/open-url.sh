#!/usr/bin/env bash
# Extract URLs from current pane and open selected one in browser
tmux capture-pane -pJ -S - \
  | grep -oE '(https?|ftp)://[^[:space:]"<>]+' \
  | sed -E 's/[.,;:!?)]+$//' \
  | sort -u \
  | fzf --prompt="open url > " --height=40% --reverse \
       --multi --bind 'a:select-all+accept' \
  | xargs -r open
