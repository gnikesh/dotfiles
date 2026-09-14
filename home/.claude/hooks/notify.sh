#!/usr/bin/env sh
# Claude Code notification hook, wired from ~/.claude/settings.json for the
# Stop and Notification events. Reads the hook JSON payload on stdin.
#
# Darwin  -> Notification Center via osascript
# Linux   -> notify-send when a session bus is available
# Fallback-> terminal bell on the controlling tty (headless / SSH sessions)
set -u

title="Claude Code"
payload=$(cat)

body=""
if command -v jq >/dev/null 2>&1; then
  body=$(printf '%s' "$payload" \
    | jq -r '.last_assistant_message // .message // empty' 2>/dev/null \
    | tr '\n' ' ' | head -c 160)
fi
[ -n "$body" ] || body="Needs your attention"

case "$(uname -s)" in
  Darwin)
    escaped=$(printf '%s' "$body" | sed 's/[\\"]/\\&/g')
    if osascript -e "display notification \"$escaped\" with title \"$title\"" >/dev/null 2>&1; then
      exit 0
    fi
    ;;
  *)
    if command -v notify-send >/dev/null 2>&1 && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
      if notify-send "$title" "$body" >/dev/null 2>&1; then
        exit 0
      fi
    fi
    ;;
esac

{ printf '\a' >/dev/tty; } 2>/dev/null || true
exit 0
