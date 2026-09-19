#!/usr/bin/env bash
# Completion evidence for one dispatch round: every support the hat dispatched
# wrote its contribution file, each file opens with its identity marker, and
# each carries the three sections. The hat runs this before closing the round;
# the exit code is the gate, and the output names what to re-dispatch.
#
#   bash <this-skill-dir>/check.sh <team-dir> <agent-slug>...
#
# Example:
#   bash check.sh .scratch/painel-projetos/team/grill qa-expert dba sre
set -uo pipefail

dir="${1:-}"; shift 2>/dev/null || true
if [ -z "$dir" ] || [ $# -eq 0 ]; then
  echo "usage: check.sh <team-dir> <agent-slug>..." >&2
  exit 2
fi

incomplete=0
for slug in "$@"; do
  f="$dir/$slug.md"
  bad=0
  if [ ! -f "$f" ]; then
    echo "MISSING     $f"
    incomplete=$((incomplete + 1))
    continue
  fi
  first=$(head -1 "$f")
  if [ "$first" != "**Collaborator:** $slug" ]; then
    echo "NO MARKER   $f (first line: ${first:-<empty>})"
    bad=1
  fi
  for section in Facts Contribution Positions; do
    grep -qE "^#{2,3} $section\$" "$f" || { echo "NO SECTION  $f has no '## $section'"; bad=1; }
  done
  if [ $bad -eq 0 ]; then
    echo "ok          $f"
  else
    incomplete=$((incomplete + 1))
  fi
done

if [ $incomplete -gt 0 ]; then
  echo "$incomplete of $# dispatches incomplete: re-dispatch these, then run this again"
  exit 1
fi
echo "all $# dispatches complete"
