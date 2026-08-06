#!/usr/bin/env bash
# Claude Code Stop/Notification hook → pushes the pane onto a stack rendered in
# the tmux status bar. `claude-notify.sh pop` (bound to M-c) jumps to the newest
# entry and drops it; `clear <loc>` (tmux pane-focus-in hook) drops one pane's
# entry without switching, so walking to a pane yourself counts as reading it.
# `back` (M-b) returns to wherever the last pop left from, and toggles.
#
# The same call also paints a state glyph on the window's tab, so the strip says
# which agent is mid-turn vs. waiting on you without popping anything. `install`
# (run from .tmux.conf) wires that into rose-pine's window format once.
# Run it bare with no stdin to test: `./claude-notify.sh`
set -u

STACK=@claude_alert
# Where the last pop jumped from. tmux's own last-pane/last-window/switch-client
# -l each only cover one axis, and a pop can cross all three at once.
BACK=@claude_back

# Per-window tab marker, holding the same kind of colour-carrying string as the
# stack. Deliberately a different axis from $STACK: the stack is per-pane and
# tracks what you haven't read, this tracks what the agent is doing right now —
# including while you sit and watch it, which never reaches the stack at all.
# ponytail: last writer wins if two panes in one window both run Claude. Go
# per-pane only if that stops being rare.
WIN_STATE=@claude_win_state

# Rose-pine: gold mid-turn, rose wants an answer, foam done, pine compacting.
# Gold doubles as the active-tab colour, but the glyph is what carries meaning.
WORKING='#[fg=#f6c177]◐'
WAITING='#[fg=#ebbcba]✻?'
DONE='#[fg=#9ccfd8]✻'
COMPACTING='#[fg=#31748f]◒'

# rose-pine writes inline #[fg=…] into window-status-format, and an inline colour
# beats window-status-style — so the marker has to live inside the format itself
# rather than being a style override. Wrapping keeps the theme's own colours.
MARKER='#{?@claude_win_state,#{@claude_win_state}#[default] ,}'

# Called from .tmux.conf after TPM, so it re-runs on every source-file. The
# substring check is what makes that idempotent: unlike the status-format block
# in §8 there's no built-in default to reset to first, so a second pass would
# otherwise wrap the marker around itself.
install() {
	for opt in window-status-format window-status-current-format; do
		cur=$(tmux show -gwv "$opt")
		# Empty means rose-pine deferred to tmux's built-in format. Prefixing
		# the marker would replace that and lose the window name entirely, so
		# leave it alone — no marker beats no name.
		[ -n "$cur" ] || continue
		case "$cur" in *"$WIN_STATE"*) continue ;; esac
		tmux set -gw "$opt" "$MARKER$cur"
	done
}

# $1 = window target, $2 = hook event, $3 = 1 when you're already watching the
# pane. Terminal states clear themselves when watched, matching the stack's own
# rule — otherwise a turn ending under your nose leaves a ✻ you'd have to switch
# away and back to dismiss. In-flight states paint regardless: those are exactly
# the ones worth seeing on a tab you're about to leave.
paint() {
	case "$2" in
		UserPromptSubmit) mark=$WORKING ;;
		PreCompact)       mark=$COMPACTING ;;
		Notification)     mark=$WAITING ;;
		Stop)             mark=$DONE ;;
		*)                mark= ;;   # SessionEnd, and anything added later
	esac
	case "$mark" in
		"$WORKING"|"$COMPACTING") ;;
		*) [ "$3" = 1 ] && mark= ;;
	esac
	if [ -n "$mark" ]; then
		tmux set -w -t "$1" "$WIN_STATE" "$mark"
	else
		tmux set -w -t "$1" -u "$WIN_STATE"
	fi
	tmux refresh-client -S
}

# Entries are whitespace-free, so plain word splitting is the entire parser. The
# gap you see between glyph and location is a non-breaking space, which IFS does
# not split on — that's what keeps one entry one word.
# ponytail: a session name containing a real space would break the split. tmux
# allows it via rename-session; nobody does it. Quote-and-eval if that changes.
SEP=$' '

# Sets $rest to the stack minus every entry for pane $1, space-separated with no
# leading space. Shared by push (prepends the new entry) and clear.
drop() {
	rest=
	for e in $(tmux show -gqv "$STACK"); do
		case "$e" in *"$SEP$1") continue ;; esac
		rest="${rest:+$rest }$e"
	done
}

clear_pane() {
	# Tab marker first, and independent of the stack below: a pane you were
	# watching when its turn ended carries a marker but never made it onto the
	# stack, so it can't ride the stack's early return. In-flight states stay —
	# walking over to a pane doesn't stop the work.
	win=${1%.*}
	cur=$(tmux show -wqv -t "$win" "$WIN_STATE" 2>/dev/null)
	case "$cur" in
		''|"$WORKING"|"$COMPACTING") ;;
		*) tmux set -w -t "$win" -u "$WIN_STATE"; tmux refresh-client -S ;;
	esac

	stack=$(tmux show -gqv "$STACK")
	[ -n "$stack" ] || return
	drop "$1"
	[ "$rest" = "$stack" ] && return   # nothing for this pane; don't churn the bar
	tmux set -g "$STACK" "$rest"
	tmux refresh-client -S
}

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
	tmux set -g "$BACK" "$(tmux display-message -p '#S:#I.#P')"
	# A dead pane just fails the switch, and it's off the stack either way — so
	# stale entries clear themselves rather than needing a prune pass.
	tmux switch-client -t "${newest#*$SEP}"
}

# Swap current location with the stored one, so M-C bounces between the two.
back() {
	there=$(tmux show -gqv "$BACK")
	if [ -z "$there" ]; then
		tmux display-message "no pane to go back to"
		return
	fi
	tmux set -g "$BACK" "$(tmux display-message -p '#S:#I.#P')"
	tmux switch-client -t "$there"
}

[ "${1:-}" = pop ] && { pop; exit; }
[ "${1:-}" = back ] && { back; exit; }
[ "${1:-}" = clear ] && { clear_pane "${2:-}"; exit; }
[ "${1:-}" = install ] && { install; exit; }

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

seen=0
if [ "$pane_active$window_active" = "11" ] && [ "$attached" != "0" ]; then
	seen=1
fi

paint "${loc%.*}" "$event" "$seen"

# Only the two "needs you" events earn a stack entry; the rest are tab-only, so
# they never inflate the count you're expected to work through with M-c.
case "$event" in Stop|Notification) ;; *) exit 0 ;; esac
[ "$seen" = 1 ] && exit 0

# Colour rides along inside the entry so the two states can differ; it has no
# whitespace, so it doesn't disturb the word-splitting above.
case "$event" in
	Notification) entry="#[fg=#ebbcba]✻?$SEP$loc" ;;   # rose — waiting on you
	*)            entry="#[fg=#9ccfd8]✻$SEP$loc"  ;;   # foam — finished
esac

# Newest first, dropping any older entry for this same pane so one busy pane
# can't flood the bar.
drop "$loc"
tmux set -g "$STACK" "$entry${rest:+ $rest}"
tmux refresh-client -S
