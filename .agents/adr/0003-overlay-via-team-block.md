# The team overlays Matt's skills through a `## Team` block, not through replacement skills

The user keeps invoking Matt's skills (`/grill-with-docs`, `/to-spec`, `/to-tickets`, `/implement`, `/triage`). What changes is who executes inside them: the main session wears a hat (Product Owner or Tech Lead) and dispatches the roster. Matt's skills know nothing about the team, so the bridge has to sit somewhere both harnesses load every session: `CLAUDE.md` / `AGENTS.md`.

Two constraints fix the shape:

- The hats need the human in the loop (the interview) or need to dispatch subagents (the build), and in both harnesses a subagent can do neither. So hats run on the **main session**, delivered as skills it loads.
- Matt's `to-spec`, `to-tickets`, `implement`, `handoff` are user-invoked: no skill or subagent can call them. Our hat skills must therefore be **model-invoked**, so the main session can load them from inside a user-invoked skill (Matt's own rule: user-invoked may call model-invoked). A model-invoked skill is also reachable by the human, which is what makes standalone use (`/team-grill`, `/team-implement`) work with the same files.

## Decision

`setup-team` writes a short `## Team` block into whichever of `CLAUDE.md` / `AGENTS.md` already exists (same selection rule as `setup-matt-pocock-skills`), beside Matt's `## Agent skills` block. The block states the mode (with or without Matt's skills), the active roster, the artifact language, the limits, and one pointer per overlaid skill: "when the user runs `/implement`, call the Skill tool with `team-implement` before doing anything else", and so on for `/grill-with-docs`, `/grill-me`, `/to-spec`, `/to-tickets`, `/triage`, `/diagnosing-bugs`, `/improve-codebase-architecture`.

Skills in this repo carry the `team-` prefix so none collides with a skill of Matt's; a colliding name would replace instead of overlay.

On Claude Code the plugin may additionally ship a `PreToolUse` hook on the `Skill` tool that injects the same pointer deterministically. It is a hardening, never the only bridge: Codex has only the block.

## Known risk

`implement` says "implement the work"; the block says "you are the Tech Lead, delegate". Models treat `CLAUDE.md` as project rules and the skill body as the task, so the block should win, but this is the most fragile point of the design and Phase 2 of `PLAN.md` tests it before anything is built on top.
