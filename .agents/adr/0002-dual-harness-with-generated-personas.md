# Ship for Claude Code and Codex from v1; generate personas from one source

Both harnesses are targets from the start. Facts that shape how, verified 2026-09-18:

- Claude Code's `.claude-plugin/plugin.json` takes `skills` as an array of paths and also ships `agents` (subagent Markdown files with frontmatter) and hooks.
- Codex's `.codex-plugin/plugin.json` takes `skills` as **one** path string. This repo keeps `skills/` flat for exactly that reason; Matt's bucketed layout is what blocked his Codex plugin (his ADR 0002).
- Codex has subagents (custom agents as TOML in `.codex/agents/` or `~/.codex/agents/`, dispatched with `spawn_agent`, concurrency capped by `[agents] max_concurrent_threads_per_session`), but its plugin manifest has **no `agents` field** (openai/codex#28491, open as of June 2026). Agents cannot ride the Codex plugin.
- Persona formats differ: Markdown with frontmatter on Claude, TOML plus an instructions file on Codex.

## Decision

- `agents/<role>.md` is the single source of truth for every persona. It is already Claude Code's format, and `agents/` is the folder Claude Code auto-discovers, so the Claude manifest carries no `agents` field: an explicit array passes `claude plugin validate --strict` but `claude plugin details` then reports zero agents, while auto-discovery lists all six. `scripts/build.sh` generates only the Codex surface, `skills/setup-team/codex-agents/<role>.toml` (`name`, `description`, `developer_instructions`, the shape AI-DLC verified live on codex-cli 0.139 and 0.142). Generated output is committed so the plugin installs without a build step, and `scripts/validate.sh` fails when it is stale.
- On Codex, `setup-team` hands the human the copy of the generated TOMLs into the target repo's `.codex/agents/` (the plugin manifest cannot ship them, and the sandbox cannot write there). On Claude the plugin manifest ships them.
- Every skill carries `agents/openai.yaml` from day one, mirroring Matt's convention.
- Codex parity of `team-implement` (worktree-isolated parallel builders) is verified in Phase 3 of `PLAN.md` before the Codex install path is documented as supported.

## Invariants

- Six personas in two formats by hand is drift; the build script is the only writer of `dist/`.
- `claude plugin validate . --strict` passes after any manifest change; the Codex equivalent (`codex plugin validate`, or a manual `codex plugin add` smoke test) runs in the same step.

## Update, 2026-09-18

The `codex` CLI is not installed on the machine that built v0.1.0, so the Codex leg (manifest accepted by `codex plugin add`, `spawn_agent` parity for parallel builders, `$team-grill` overlay through `AGENTS.md`) is written to the documented formats but unverified. Phase 3 of `PLAN.md` holds the checklist.

## Update, 2026-09-19: first real Codex run

`setup-team` and `$grill-with-docs` ran on Codex CLI (gpt-5.6, Linux) against a real repo. Three facts, all now built in:

- **Codex reads `AGENTS.md`, never `CLAUDE.md`.** The setup had followed Matt's rule (`CLAUDE.md` if it exists) and put the `## Team` block where Codex could not see it, so `$grill-with-docs` ran Matt's skills without the hat. The block now goes into the file the current harness reads, and into the other one too when it exists without importing it.
- **`npx skills add` copies skill folders only.** A top-level `dist/` never reached the machine, so the TOMLs were not there to install. They now live inside `skills/setup-team/codex-agents/` and travel with the skill under every installer.
- **The Codex sandbox refuses writes under `.codex/`** ("Read-only file system"). Installing the agents is a human step: the skill prints the one-line copy and verifies afterwards.

Codex's own subagent spawning works (the session spawned two read-only inspectors on its own), so parallel builders remain plausible and still unverified.
