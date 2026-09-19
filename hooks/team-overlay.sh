#!/usr/bin/env bash
# Claude Code hardening for ADR 0003: when the user invokes one of Matt's
# overlaid skills in a repo where team mode is on, add the same pointer the
# `## Team` block carries, so the main session loads the hat deterministically.
# Silent everywhere else. Never blocks: the decision is always "allow".
set -uo pipefail
input=$(cat)
skill=$(printf '%s' "$input" | sed -n 's/.*"skill"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
[ -n "$skill" ] || exit 0
skill="${skill##*:}"   # plugin skills arrive namespaced (mattpocock-skills:implement)
root="${CLAUDE_PROJECT_DIR:-$PWD}"
block=""
for f in "$root/CLAUDE.md" "$root/AGENTS.md"; do
  [ -f "$f" ] && grep -q '^## Team' "$f" && block="$f" && break
done
[ -n "$block" ] || exit 0
case "$skill" in
  grill-with-docs|grill-me|to-spec|triage) hat="team-grill" ;;
  implement|to-tickets|diagnosing-bugs|improve-codebase-architecture) hat="team-implement" ;;
  *) exit 0 ;;
esac
ctx="Team mode is on in this repo (see the ## Team block in $(basename "$block")). Before acting on /$skill, call the Skill tool with \"$hat\" and follow it: the main session wears the hat and delegates to the roster; it does not do the roster's work itself."
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","additionalContext":%s}}\n' "$(printf '%s' "$ctx" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
