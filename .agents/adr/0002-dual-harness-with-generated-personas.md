# Ship for Claude Code and Codex from v1; generate personas from one source

Both harnesses are targets from the start. Facts that shape how, verified 2026-09-18:

- Claude Code's `.claude-plugin/plugin.json` takes `skills` as an array of paths and also ships `agents` (subagent Markdown files with frontmatter) and hooks.
- Codex's `.codex-plugin/plugin.json` takes `skills` as **one** path string. This repo keeps `skills/` flat for exactly that reason; Matt's bucketed layout is what blocked his Codex plugin (his ADR 0002).
- Codex has subagents (custom agents as TOML in `.codex/agents/` or `~/.codex/agents/`, dispatched with `spawn_agent`, concurrency capped by `[agents] max_concurrent_threads_per_session`), but its plugin manifest has **no `agents` field** (openai/codex#28491, open as of June 2026). Agents cannot ride the Codex plugin.
- Persona formats differ: Markdown with frontmatter on Claude, TOML plus an instructions file on Codex.

## Decision

- `agents/<role>.md` is the single source of truth for every persona. It is already Claude Code's format, and `agents/` is the folder Claude Code auto-discovers, so the Claude manifest carries no `agents` field: an explicit array passes `claude plugin validate --strict` but `claude plugin details` then reports zero agents, while auto-discovery lists all six. `scripts/build.sh` generates only the Codex surface, `dist/codex/agents/<role>.toml` (`name`, `description`, `developer_instructions`, the shape AI-DLC verified live on codex-cli 0.139 and 0.142). Generated output is committed so the plugin installs without a build step, and `scripts/validate.sh` fails when it is stale.
- On Codex, `setup-team` copies the generated TOMLs into the target repo's `.codex/agents/` (the plugin manifest cannot). On Claude the plugin manifest ships them.
- Every skill carries `agents/openai.yaml` from day one, mirroring Matt's convention.
- Codex parity of `team-implement` (worktree-isolated parallel builders) is verified in Phase 3 of `PLAN.md` before the Codex install path is documented as supported.

## Invariants

- Six personas in two formats by hand is drift; the build script is the only writer of `dist/`.
- `claude plugin validate . --strict` passes after any manifest change; the Codex equivalent (`codex plugin validate`, or a manual `codex plugin add` smoke test) runs in the same step.

## Update, 2026-09-18

The `codex` CLI is not installed on the machine that built v0.1.0, so the Codex leg (manifest accepted by `codex plugin add`, `spawn_agent` parity for parallel builders, `$team-grill` overlay through `AGENTS.md`) is written to the documented formats but unverified. Phase 3 of `PLAN.md` holds the checklist.
