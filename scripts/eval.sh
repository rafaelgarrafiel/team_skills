#!/usr/bin/env bash
# Runs the behavioural eval suite in evals/ against this plugin.
# Each run is a real Claude session on your own credential: it costs money
# (roughly US$ 0.20 to 0.30 per case per run) and takes minutes. This is why
# CI runs only scripts/validate.sh; run this by hand before a release, or
# after changing a hat, a persona or the Team block wording.
#
#   scripts/eval.sh                 # every case, 3 runs each, plugin arm only
#   scripts/eval.sh --case overlay-*  --runs 1
#   scripts/eval.sh --ablation with-without   # also a no-plugin baseline arm
set -euo pipefail
cd "$(dirname "$0")/.."
# The result file: ours unless the caller passed --json <path>.
json_out=/tmp/team-skills-eval.json
prev=""
for a in "$@"; do [ "$prev" = "--json" ] && json_out="$a"; prev="$a"; done
extra=(); [ "$json_out" = /tmp/team-skills-eval.json ] && extra=(--json "$json_out")

claude plugin eval . --runs 3 --trust-plugin --no-publish --ablation none --threshold 0.67 "${extra[@]}" "$@"
status=$?

# A run refused by the environment (session limit, logged out) scores zero with
# one turn and looks like a plugin regression. Name those runs and fail loudly.
JSON_OUT="$json_out" python3 - <<'PYCHECK'
import json, os, sys
try:
    d = json.load(open(os.environ['JSON_OUT']))
except Exception:
    sys.exit(0)
signatures = ('limit', 'not logged in', 'login')
hits = [(c['name'], i + 1, r['error']) for c in d['cases'] for arm in c['arms'].values()
        for i, r in enumerate(arm) if r.get('error') and any(k in r['error'].lower() for k in signatures)]
for name, i, err in hits:
    print(f"ENVIRONMENT  {name} run {i}: {err[:80]}")
if hits:
    print(f"{len(hits)} run(s) were refused by the environment (session limit or logged out): their zeros are not the plugin's. Fix that, then re-run.")
    sys.exit(3)
PYCHECK
exit $status
