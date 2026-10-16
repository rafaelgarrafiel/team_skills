#!/usr/bin/env bash
# Sets one version everywhere it is recorded: both manifests, package.json,
# metadata.version in every skill's frontmatter (the only place a skill
# installed by `npx skills` can read it from: that installer's lockfile keeps
# origin and hash, not a version), the README line, and the generated Codex
# agents. Usage: scripts/set-version.sh 0.4.1
set -euo pipefail
cd "$(dirname "$0")/.."
v="${1:?usage: scripts/set-version.sh <x.y.z>}"
[[ "$v" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "not a semantic version: $v" >&2; exit 1; }

python3 - "$v" <<'PY'
import glob, json, re, sys
v = sys.argv[1]
for p in ('.claude-plugin/plugin.json', '.codex-plugin/plugin.json', 'package.json'):
    s = open(p).read()
    s, n = re.subn(r'("version":\s*")[^"]+(")', rf'\g<1>{v}\g<2>', s, count=1)
    assert n == 1, f"{p}: no version field"
    open(p, 'w').write(s)
for p in glob.glob('skills/*/SKILL.md'):
    raw = open(p).read()
    head, sep, body = raw.partition('\n---\n')
    assert raw.startswith('---\n') and sep, f"{p}: no frontmatter"
    if re.search(r'^metadata:\n  version: "[^"]*"$', head, re.M):
        head = re.sub(r'^(metadata:\n  version: ")[^"]*(")$', rf'\g<1>{v}\g<2>', head, flags=re.M)
    else:
        head += f'\nmetadata:\n  version: "{v}"'
    open(p, 'w').write(head + sep + body)
s = open('README.md').read()
s, n = re.subn(r'^Version \d+\.\d+\.\d+\.', f'Version {v}.', s, count=1, flags=re.M)
assert n == 1, "README.md: no 'Version x.y.z.' line"
open('README.md', 'w').write(s)
PY
scripts/build.sh >/dev/null
echo "version $v set; add the CHANGELOG entry, then run scripts/validate.sh"
