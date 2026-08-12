#!/usr/bin/env bash
# Centre a single-pane window on a wide monitor by flanking it with blank panes.
# tmux can shrink a window (window-size manual) but always draws it flush left,
# so padding panes are the only way to actually centre the text.
set -euo pipefail

win=$(tmux display -p '#{window_id}')

pads=$(tmux list-panes -t "$win" -F '#{pane_id} #{@zen_pad}' | awk '$2 == "1" { print $1 }')
if [ -n "$pads" ]; then
	for pad in $pads; do tmux kill-pane -t "$pad"; done
	tmux setw -t "$win" -u pane-border-style
	tmux setw -t "$win" -u pane-active-border-style
	exit 0
fi

target=$(tmux show -gv @zen_width || true)
read -r panes width <<<"$(tmux display -p '#{window_panes} #{window_width}')"

if [ "$panes" -ne 1 ]; then
	tmux display-message "zen: needs a single pane"
	exit 0
fi

# the two pane borders eat a column each, so back them out of the split size
pad=$(( (width - ${target:-120} - 2) / 2 ))
if [ "$pad" -lt 5 ]; then
	tmux display-message "zen: window is already narrow enough"
	exit 0
fi

# cat blocks forever without printing; a sleep would expire and drop the pane.
for side in -hb -h; do
	id=$(tmux split-window -dP -F '#{pane_id}' -t "$win" "$side" -l "$pad" cat)
	tmux set -p -t "$id" @zen_pad 1
done

border=$(tmux show -gv @zen_border || true)
tmux setw -t "$win" pane-border-style "fg=${border:-default}"
tmux setw -t "$win" pane-active-border-style "fg=${border:-default}"
