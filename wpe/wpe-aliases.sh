#!/bin/sh
# Regenerate WP-CLI aliases for every environment in wpe-cli's site cache
# (~/.cache/wpe-cli/sites.json, refreshed by any wpe command every 6h).
#
# Install names are client data, so they never land in this repo: cache in,
# ~/.wp-cli/config.yml out. Hand-written aliases above the marker survive.
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
	jq -r '.data[] | "@\(.name):\n  ssh: \(.name)@\(.name).ssh.wpengine.net/sites/\(.name)"' -- "$cache"
} >> "$tmp"

mv "$tmp" "$config"
echo "$(grep -c '^@' "$config") aliases in $config"
