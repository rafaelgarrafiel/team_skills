# team-skills

A plugin for Claude Code and Codex that adds a **team** (Product Owner and Tech Lead hats on the main session, plus advisor and builder subagents) on top of [mattpocock/skills](https://github.com/mattpocock/skills). It overlays Matt's skills when they are installed and runs standalone when they are not. The decisions behind that are ADRs in `.agents/adr/`; read the ones touching the area you change.

## Layout

- `skills/<name>/SKILL.md`: one flat folder per skill, no buckets (Codex's manifest takes a single skills path). Every skill folder also carries `agents/openai.yaml`.
- `agents/<role>.md`: the canonical persona files, auto-discovered by Claude Code (the manifest carries no `agents` field on purpose, see ADR 0002). `skills/setup-team/codex-agents/*.toml` is **generated** from them by `scripts/build.sh` and committed; it lives inside the skill so every installer ships it. Never edit generated output.
- `.claude-plugin/`, `.codex-plugin/`: the two manifests. Run `claude plugin validate . --strict` after touching either.
- `.agents/adr/`: decisions. `.agents/roster.md`: who leads and supports where. The contribution contract is the `team-contribution` skill.
- `hooks/`: the Claude Code `PreToolUse` overlay hook (ADR 0003). `docs/<skill>.md`: one human-facing page per skill, in the shape of Matt's docs pages (What it does, When to reach for it, Common questions, It's working if, Where it fits).
- `evals/`: behavioural eval cases for `claude plugin eval`, run with `scripts/eval.sh` (costs money, so not in CI; run before a release and after changing a hat, a persona or the Team block). `evals/README.md` lists what each case catches.
- `PLAN.md`: the phased implementation plan, kept current until v1.0 ships. `scripts/validate.sh` before any commit.

## Conventions

- Skill names carry the `team-` prefix (`team-grill`, `team-implement`), except `setup-team` and `ask-team`. Agent names carry no prefix (`lgpd-analyst`, `qa-expert`).
- A skill is either user-invoked (`disable-model-invocation: true` plus `policy.allow_implicit_invocation: false` in `agents/openai.yaml`) or model-invoked. The hat skills (`team-grill`, `team-implement`) are model-invoked so the main session can load them from inside Matt's user-invoked skills; `setup-team` and `ask-team` are user-invoked. Dependencies between skills are an explicit "call the Skill tool with `<name>`", never a bare `/name`.
- Source prose (skills, personas, ADRs, README) is English. The language of the artifacts the team produces in a target repo is a `setup-team` setting.
- No em-dashes anywhere in this repo's prose. Rewrite with a comma, colon, period, parentheses, or a conjunction.
- Write skills and personas per the `writing-for-agents` skill: steps end on a checkable completion criterion, reference is disclosed behind pointers, positive phrasing over prohibition.
