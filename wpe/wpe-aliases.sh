#!/bin/sh
# wpe-cli's site cache in, ~/.wp-cli/config.yml out. Anything above the marker
# is yours and survives.
set -eu

cache=${XDG_CACHE_HOME:-$HOME/.cache}/wpe-cli/sites.json
config=$HOME/.wp-cli/config.yml
marker='# >>> wpe-aliases (generated, edits below are lost)'

if [ ! -r "$cache" ]; then
	echo "no site cache at $cache — run any wpe command first" >&2
	exit 1
fi

mkdir -p "$(dirname "$config")"
tmp=$config.$$
trap 'rm -f "$tmp"' EXIT

if [ -f "$config" ]; then
	sed "/^$marker\$/,\$d" "$config" > "$tmp"
fi

{
	echo "$marker"
	# Multisite refuses to run without --url.
	jq -r '.data[]
	       | "@\(.name):\n  ssh: \(.name)@\(.name).ssh.wpengine.net/sites/\(.name)"
	         + (if .is_multisite then "\n  url: \(.primary_domain)" else "" end)' -- "$cache"
} >> "$tmp"

mv "$tmp" "$config"
echo "$(grep -c '^@' "$config") aliases in $config"
