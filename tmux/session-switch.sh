#!/usr/bin/env bash
# Quick MRU session switcher for Alt-j.
#   enter  → switch to highlighted session (or create it if the typed name has no match)
#   ctrl-x → kill highlighted session and reload the list

current=$(tmux display-message -p '#S')

# Two tab-separated columns: display ("● name" for current, "  name" otherwise)
# and the raw session name. fzf shows col 1, but accepts/kills/previews col 2.
# Current session is pushed to the bottom so the default highlight lands on the
# most-recently-used *other* session.
list="tmux list-sessions -F '#{session_activity} #{session_name}' | sort -rn \
    | awk -v c='$current' '{ \$1=\"\"; sub(/^ /,\"\"); n=\$0; \
        if (n==c) cur=\"● \" n \"\t\" n; else print \"  \" n \"\t\" n } \
        END { if (cur) print cur }'"

out=$(eval "$list" | fzf --reverse --print-query --delimiter '\t' \
    --with-nth 1 --accept-nth 2 \
    --prompt 'switch > ' \
    --bind 'start,change:transform-prompt([ -n "$FZF_QUERY" ] && [ "$FZF_MATCH_COUNT" -eq 0 ] && echo "create > " || echo "switch > ")' \
    --footer 'enter: switch/create   ctrl-x: kill' \
    --preview '~/.dotfiles/tmux/preview-helper.sh {2}' \
    --preview-window right:40% \
    --bind "ctrl-x:execute-silent(test {2} != '$current' && tmux kill-session -t {2})+reload($list)")

query=$(sed -n 1p <<< "$out")
match=$(sed -n 2p <<< "$out")

# Highlighted match wins; otherwise create/switch to whatever was typed.
target="${match:-$query}"
[[ -z "$target" ]] && exit 0

tmux has-session -t "$target" 2>/dev/null || tmux new-session -d -s "$target"
tmux switch-client -t "$target"
