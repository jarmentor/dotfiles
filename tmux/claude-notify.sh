#!/usr/bin/env bash
# Claude Code Stop/Notification hook → macOS notification that names the tmux pane.
# Stays quiet when you're already looking at that pane.
# Run it bare (no stdin) to test: `./claude-notify.sh`
set -u

[ -n "${TMUX_PANE:-}" ] || exit 0

if [ -t 0 ]; then
	event=Stop
else
	event=$(jq -r '.hook_event_name // "Stop"' 2>/dev/null || echo Stop)
fi

read -r pane_active window_active attached loc path <<<"$(
	tmux display-message -p -t "$TMUX_PANE" \
		'#{pane_active} #{window_active} #{session_attached} #S:#I.#P #{pane_current_path}'
)"

# ponytail: "attached" != "frontmost" — if Ghostty is behind your browser on the
# focused pane you get no ping. Add an `osascript` frontmost check if that bites.
if [ "$pane_active$window_active" = "11" ] && [ "$attached" != "0" ]; then
	exit 0
fi

case "$event" in
	Notification) title="Claude needs you"; sound="Funk" ;;
	*)            title="Claude done";      sound="Glass" ;;
esac

osascript - "$title" "$loc" "${path##*/}" "$sound" <<'APPLESCRIPT'
on run argv
	display notification (item 2 of argv) with title (item 1 of argv) subtitle (item 3 of argv) sound name (item 4 of argv)
end run
APPLESCRIPT
