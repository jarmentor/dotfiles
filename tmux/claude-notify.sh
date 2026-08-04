#!/usr/bin/env bash
# Claude Code Stop/Notification hook → pushes the pane onto a stack rendered in
# the tmux status bar. `claude-notify.sh pop` (bound to M-c) jumps to the newest
# entry and drops it. Run it bare with no stdin to test: `./claude-notify.sh`
set -u

STACK=@claude_alert

# Entries are whitespace-free, so plain word splitting is the entire parser. The
# gap you see between glyph and location is a non-breaking space, which IFS does
# not split on — that's what keeps one entry one word.
# ponytail: a session name containing a real space would break the split. tmux
# allows it via rename-session; nobody does it. Quote-and-eval if that changes.
SEP=$' '

pop() {
	stack=$(tmux show -gqv "$STACK")
	if [ -z "$stack" ]; then
		tmux display-message "no Claude alerts"
		return
	fi
	newest=${stack%% *}
	case "$stack" in
		*" "*) rest=${stack#* } ;;
		*)     rest= ;;
	esac
	tmux set -g "$STACK" "$rest"
	tmux refresh-client -S
	# A dead pane just fails the switch, and it's off the stack either way — so
	# stale entries clear themselves rather than needing a prune pass.
	tmux switch-client -t "${newest#*$SEP}"
}

[ "${1:-}" = pop ] && { pop; exit; }

[ -n "${TMUX_PANE:-}" ] || exit 0

if [ -t 0 ]; then
	event=Stop
else
	event=$(jq -r '.hook_event_name // "Stop"' 2>/dev/null || echo Stop)
fi

read -r pane_active window_active attached loc <<<"$(
	tmux display-message -p -t "$TMUX_PANE" \
		'#{pane_active} #{window_active} #{session_attached} #S:#I.#P'
)"
[ -n "$loc" ] || exit 0   # pane died between the turn ending and this hook

if [ "$pane_active$window_active" = "11" ] && [ "$attached" != "0" ]; then
	exit 0
fi

# Colour rides along inside the entry so the two states can differ; it has no
# whitespace, so it doesn't disturb the word-splitting above.
case "$event" in
	Notification) entry="#[fg=#ebbcba]✻?$SEP$loc" ;;   # rose — waiting on you
	*)            entry="#[fg=#9ccfd8]✻$SEP$loc"  ;;   # foam — finished
esac

# Newest first, dropping any older entry for this same pane so one busy pane
# can't flood the bar.
rest=
for e in $(tmux show -gqv "$STACK"); do
	case "$e" in *"$SEP$loc") continue ;; esac
	rest="$rest $e"
done
tmux set -g "$STACK" "$entry$rest"
tmux refresh-client -S
