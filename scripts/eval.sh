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
claude plugin eval . --runs 3 --trust-plugin --no-publish --ablation none --threshold 0.67 --json /tmp/team-skills-eval.json "$@"
status=$?
# A rate-limited run scores zero with one turn and looks like a regression; name it.
python3 - <<'PYCHECK'
import json, sys
try:
    d = json.load(open('/tmp/team-skills-eval.json'))
except Exception:
    sys.exit(0)
hits = [(c['name'], i + 1, r['error']) for c in d['cases'] for arm in c['arms'].values() for i, r in enumerate(arm) if r.get('error') and 'limit' in r['error'].lower()]
for name, i, err in hits:
    print(f"RATE-LIMITED  {name} run {i}: {err[:80]}")
if hits:
    print(f"{len(hits)} run(s) hit a session limit: their zeros are not the plugin's. Re-run after the reset.")
    sys.exit(3)
PYCHECK
exit $status
