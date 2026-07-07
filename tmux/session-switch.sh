#!/usr/bin/env bash
# Quick MRU session switcher for Alt-j.
#   enter  → switch to highlighted session
#   ctrl-x → kill highlighted session and reload the list

current=$(tmux display-message -p '#S')
list="tmux list-sessions -F '#{session_activity} #{session_name}' | sort -rn | cut -d' ' -f2- | grep -vxF '$current'"

selected=$(eval "$list" | fzf --reverse \
    --prompt 'switch > ' \
    --header 'enter: switch   ctrl-x: kill' \
    --preview '~/.dotfiles/tmux/preview-helper.sh {}' \
    --preview-window right:50% \
    --bind "ctrl-x:execute-silent(tmux kill-session -t {})+reload($list)")

[[ -n "$selected" ]] && tmux switch-client -t "$selected"
