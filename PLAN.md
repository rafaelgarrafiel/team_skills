# Implementation plan

## Status, 2026-09-18

Everything buildable without a real repo is built and passes `scripts/validate.sh`: manifests, build and validate scripts, the overlay hook, five skills, six personas, the Codex TOMLs, docs pages, README. What remains is exactly the pilots, which need a human in a real repo:

| Phase | Built | Pending |
|---|---|---|
| 0 scaffold | manifests validate, `build.sh` round-trips, hook exercised with sample input | `claude plugins install` from a marketplace add of this repo |
| 1 grill | `setup-team`, `team-contribution`, `team-grill`, `ask-team`, five advisor personas, docs | the pilot below |
| 2 build | `team-implement`, `senior-developer`, the Claude hook | the pilot below, and the ADR 0003 risk observed |
| 3 Codex | Codex manifest, TOML generation, `setup-team` Codex branch, `openai.yaml` on every skill | everything: no `codex` CLI on the build machine |
| 4 v1.0 | README, docs pages, CHANGELOG, versions in sync | skills.sh listing, official marketplace, a second real repo |

Simplification adopted during the build: personas are already in Claude's format, so only the Codex TOML is generated (`dist/codex/agents/`), and `.claude-plugin/plugin.json` lists the persona files explicitly, which `claude plugin validate --strict` requires. The contribution contract moved from `.agents/` into the `team-contribution` skill, its single source of truth.

Resolved open items: `team/` folders always live under `.scratch/<feature-slug>/team/` whatever the tracker (Matt's `to-spec` publishes the spec as an issue on GitHub, so there is no spec file to sit beside); on a real tracker the hat also quotes maintained objections into the issue. UX and DBA conditions are detected by the hat from the tree or the diff; `setup-team` records hints and lets the user switch an advisor off.

Phases ship in order; each ends on a pilot in a real repo, and the next phase starts only when the pilot's criteria hold. Decisions the plan relies on are in `.agents/adr/`; the contracts the deliverables implement are `.agents/roster.md` and the `team-contribution` skill.

## Phase 0: scaffold

Deliverables:

- `.claude-plugin/plugin.json` and `marketplace.json`; `.codex-plugin/plugin.json` with `skills: "./skills"`.
- `scripts/build.sh`: reads `agents/*.md`, writes `.claude/agents/*.md` and `.codex/agents/*.toml` (+ instructions files). `scripts/validate.sh`: `claude plugin validate . --strict`, a Codex manifest check, and a link check over `README.md`.
- `README.md` with the install block (plugin by URL, `npx skills add`), `CHANGELOG.md`, `package.json` for the version.
- An empty `skills/` and `agents/` layout with one placeholder each so both manifests validate.

Done when: both manifests validate, `build.sh` round-trips a placeholder persona into both formats, and `claude plugins install` from the local path loads the placeholder skill.

## Phase 1: the grill (v0.1)

Deliverables:

- `setup-team` (user-invoked). Explore: is `mattpocock-skills` installed; do `docs/agents/issue-tracker.md` and `docs/agents/domain.md` exist (reuse, never re-ask); which of `CLAUDE.md` / `AGENTS.md` exists. Ask, one section at a time with a recommended answer: profile (`express` default, `feature`), active advisors (all five by default), artifact language, limits (2 review iterations, 3 parallel builders, 2 advisor rounds). Write `docs/agents/team.md` and the `## Team` block (ADR 0003). On Codex, also copy the generated agents into `.codex/agents/`.
- `team-contribution` (model-invoked): the contribution contract as a skill, loaded by every support at dispatch.
- `team-grill` (model-invoked): the Product Owner hat. With Matt: call the Skill tool with `grilling` and `domain-modeling`. Without: the embedded minimal protocol (rounds, frontier, numbered questions with a recommended answer). Before each round, dispatch the active advisors in parallel per the contract, blind; merge their facts into the tree and their questions into the round, tagged by origin; run objection triage; end when the frontier is empty and the human confirms shared understanding.
- Personas: `lgpd-analyst`, `security-analyst`, `qa-expert`, `ux-expert`, `dba` (the advisors). Each: domain, what it looks up in the repo before asking, what a good candidate question looks like, when it stays silent (the condition in the roster).
- `ask-team` (user-invoked): the router, in the shape of `ask-matt`, including what is unavailable standalone.

Pilot: one real feature grilled in a real repo, with Matt installed, via `/grill-with-docs`. Done when: the main session loaded `team-grill` without being told to in chat; each advisor produced a contribution file with the identity marker; at least one advisor question reached a round tagged by origin; `CONTEXT.md` and an ADR came out of `domain-modeling` as usual. Then the same feature standalone via `/team-grill` in a repo without Matt: the interview runs on the embedded protocol.

## Phase 2: the build (v0.2)

Deliverables:

- `team-implement` (model-invoked): the Tech Lead hat. Read the tracker per `docs/agents/issue-tracker.md` (or the tickets the human names). Pick tickets whose blockers are closed, up to the parallel limit. Brief one `senior-developer` per ticket (ticket, spec section, `CONTEXT.md`, ADRs, artifact language), worktree-isolated. On each return, dispatch `qa-expert` (always), and `ux-expert` / `dba` / `security-analyst` by condition. Reviewer verdict NOT-READY re-dispatches the same builder with the findings, at most the loop limit, then escalate to the human with the findings verbatim. On READY, merge, close the ticket, pick the next. Never write production code on the main session.
- Persona `senior-developer`, with Matt (inline of `implement`: `tdd`, `code-review`, commit) and without (embedded red-green slice).
- Optional Claude hardening: a plugin `PreToolUse` hook on `Skill` that injects the `## Team` pointer for the overlaid skill names (ADR 0003).

Pilot: the tickets from Phase 1's grill, via `/to-spec`, `/to-tickets`, `/implement`. Done when: the main session delegated instead of implementing (the ADR 0003 risk, observed, not assumed); two tickets built in parallel on separate worktrees and merged; one reviewer NOT-READY round-tripped to the builder; the escalation path was exercised once (force it with a ticket that cannot pass).

## Phase 3: Codex (v0.3)

- Verify `spawn_agent` parity for `team-implement`: parallel builders, isolation, return summaries. Record the result in ADR 0002 (update section).
- `setup-team` Codex branch tested end to end: agents land in `.codex/agents/`, `$team-grill` and `$implement` overlay through `AGENTS.md`.
- `agents/openai.yaml` reviewed for every skill.

Done when: the Phase 1 and Phase 2 pilots pass on Codex, or the gaps are written down in the README's harness table.

## Phase 4: v1.0

- `README.md` complete: what it is, install, setup, the roster table, standalone vs with-Matt table, harness table.
- Docs page per skill in `docs/` in the shape of Matt's `writing-docs.md` sections (What it does, When to reach for it, Common questions, It's working if).
- `CHANGELOG.md`, version bump in both manifests and `package.json`.
- Listing on skills.sh; submission to Claude's official marketplace after v1.0 has run in a second real repo.

## Open items, to settle during Phase 1

- Exact `## Team` block wording; keep it under ten lines.
- Where `team/` folders land per tracker: beside `.scratch/<feature>/` for the local tracker; for GitHub, beside the spec file `to-spec` writes (confirm where that is).
- Whether `ux-expert` and `dba` conditions are detected by the hat (from the design tree) or declared by the human in `setup-team`. Default: detected, with the human able to force them on.
