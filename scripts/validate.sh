#!/usr/bin/env bash
# Repo checks: manifests, skill layout, generated output freshness, prose rules.
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0
say() { echo "  $1"; }
bad() { echo "FAIL: $1"; fail=1; }

echo "manifests"
if command -v claude >/dev/null 2>&1; then
  claude plugin validate . --strict >/tmp/team-skills-validate.log 2>&1 && say "claude plugin validate --strict: ok" || { cat /tmp/team-skills-validate.log; bad "claude plugin validate --strict"; }
else
  say "claude CLI not found, skipped"
fi
python3 - <<'PY' || bad "manifest JSON"
import json
c=json.load(open('.claude-plugin/plugin.json')); x=json.load(open('.codex-plugin/plugin.json')); p=json.load(open('package.json'))
assert c['version']==x['version']==p['version'], f"versions differ: claude={c['version']} codex={x['version']} package={p['version']}"
assert isinstance(x['skills'],str), "codex manifest: skills must be a single path"
import os
for s in c['skills']:
    assert os.path.isfile(os.path.join(s,'SKILL.md')), f"missing {s}/SKILL.md"
print("  versions in sync; every listed skill exists")
PY

echo "skills"
for d in skills/*/; do
  n=$(basename "$d")
  [ -f "$d/SKILL.md" ] || bad "$n: no SKILL.md"
  [ -f "$d/agents/openai.yaml" ] || bad "$n: no agents/openai.yaml"
  grep -q "^name: $n$" "$d/SKILL.md" || bad "$n: frontmatter name differs from folder"
  if grep -q 'disable-model-invocation: true' "$d/SKILL.md"; then
    grep -q 'allow_implicit_invocation: false' "$d/agents/openai.yaml" || bad "$n: user-invoked in Claude but not in Codex"
  else
    grep -q 'allow_implicit_invocation: false' "$d/agents/openai.yaml" && bad "$n: user-invoked in Codex but not in Claude"
  fi
  grep -q "\"./skills/$n\"" .claude-plugin/plugin.json || bad "$n: not listed in .claude-plugin/plugin.json"
done
say "layout and invocation parity checked"

echo "frontmatter"
python3 - <<'PY2' || bad "frontmatter YAML"
import glob, sys
try:
    import yaml
except ImportError:
    print("  pyyaml not installed, skipped"); sys.exit(0)
for f in glob.glob('skills/*/SKILL.md') + glob.glob('agents/*.md'):
    raw = open(f).read()
    assert raw.startswith('---\n'), f"{f}: no frontmatter"
    fm = raw.split('\n---\n', 1)[0][4:]
    d = yaml.safe_load(fm)
    assert d.get('name') and d.get('description'), f"{f}: name or description missing after YAML parse"
print("  every frontmatter parses with name and description")
PY2

echo "generated output"
tmp=$(mktemp -d); cp -R skills/setup-team/codex-agents "$tmp/gen"
scripts/build.sh >/dev/null && diff -r "$tmp/gen" skills/setup-team/codex-agents >/dev/null && say "codex-agents/ is fresh" || bad "skills/setup-team/codex-agents/ is stale: run scripts/build.sh and commit"
rm -rf "$tmp"

echo "prose"
emdash=$(printf '\342\200\224')
if grep -rn --include='*.md' --include='*.yaml' --include='*.json' --include='*.sh' --include='*.toml' -e "$emdash" . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=results >/tmp/team-skills-emdash.log; then cat /tmp/team-skills-emdash.log; bad "em-dashes found"; else say "no em-dashes"; fi

[ $fail -eq 0 ] && echo "ok" || { echo "failed"; exit 1; }
