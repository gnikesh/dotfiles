#!/usr/bin/env bash
# Claude Code status line, wired from ~/.claude/settings.json (statusLine).
# Reads the session JSON on stdin and prints two rows:
#   1. model | context bar + % + tokens | cost | duration | dir | git branch
#   2. configured MCP servers for this project (user + project + .mcp.json scopes)
# Row 2 is the configured list, not live health; use /mcp for connection status.
set -u

input=$(cat)
[ -n "$input" ] || exit 0

IFS=$'\t' read -r model pct used size cost dur_ms cur_dir proj_dir < <(
  printf '%s' "$input" | jq -r '[
    (.model.display_name // .model.id // "?"),
    ((.context_window.used_percentage // 0) | floor),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 200000),
    (.cost.total_cost_usd // 0),
    (.cost.total_duration_ms // 0),
    (.workspace.current_dir // .cwd // ""),
    (.workspace.project_dir // .cwd // "")
  ] | @tsv'
)

dim=$'\033[2m'; reset=$'\033[0m'
green=$'\033[32m'; yellow=$'\033[33m'; red=$'\033[31m'; cyan=$'\033[36m'

fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then printf '%.1fM' "$(echo "$n / 1000000" | bc -l)"
  elif [ "$n" -ge 1000 ]; then printf '%dk' $((n / 1000))
  else printf '%d' "$n"; fi
}

fmt_duration() {
  local s=$(( $1 / 1000 ))
  if [ "$s" -ge 3600 ]; then printf '%dh%02dm' $((s / 3600)) $((s % 3600 / 60))
  elif [ "$s" -ge 60 ]; then printf '%dm' $((s / 60))
  else printf '%ds' "$s"; fi
}

# Context bar, colored by pressure.
width=10
filled=$(( pct * width / 100 )); [ "$filled" -gt "$width" ] && filled=$width
empty=$(( width - filled ))
bar=""
if [ "$filled" -gt 0 ]; then printf -v fill '%*s' "$filled" ''; bar="${fill// /▓}"; fi
if [ "$empty" -gt 0 ]; then printf -v pad '%*s' "$empty" ''; bar="${bar}${pad// /░}"; fi
if   [ "$pct" -ge 80 ]; then bar_color=$red
elif [ "$pct" -ge 50 ]; then bar_color=$yellow
else bar_color=$green; fi

branch=""
if [ -n "$cur_dir" ] && [ -d "$cur_dir" ]; then
  branch=$(git -C "$cur_dir" symbolic-ref --short -q HEAD 2>/dev/null || true)
fi

line1="${cyan}${model}${reset}"
line1+="  ${bar_color}${bar}${reset} ${pct}% ${dim}$(fmt_tokens "$used")/$(fmt_tokens "$size")${reset}"
line1+="  ${dim}\$${reset}$(printf '%.2f' "$cost")"
line1+="  ${dim}$(fmt_duration "$dur_ms")${reset}"
[ -n "$cur_dir" ] && line1+="  ${dim}${cur_dir/#$HOME/\~}${reset}"
[ -n "$branch" ] && line1+="  ${dim}${branch}${reset}"
printf '%s\n' "$line1"

# Configured MCP servers: user scope + this project's local scope + .mcp.json,
# minus servers toggled off for this project.
cfg="$HOME/.claude.json"
names=""
if [ -r "$cfg" ]; then
  names=$(jq -r --arg p "$proj_dir" '
    ((.mcpServers // {}) | keys) as $user
    | ((.projects[$p].mcpServers // {}) | keys) as $local
    | ((.projects[$p].disabledMcpServers // [])) as $off
    | ($user + $local) | unique | map(select(. as $n | $off | index($n) | not)) | .[]
  ' "$cfg" 2>/dev/null)
fi
if [ -n "$proj_dir" ] && [ -r "$proj_dir/.mcp.json" ]; then
  names+=$'\n'$(jq -r '(.mcpServers // {}) | keys[]' "$proj_dir/.mcp.json" 2>/dev/null)
fi
names=$(printf '%s\n' "$names" | sed '/^$/d' | sort -u | tr '\n' ' ' | sed 's/ $//')
if [ -n "$names" ]; then
  printf '%s\n' "${dim}mcp:${reset} ${names}"
else
  printf '%s\n' "${dim}mcp: none${reset}"
fi
