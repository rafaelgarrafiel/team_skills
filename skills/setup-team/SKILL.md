---
name: setup-team
description: "Configure this repo for the team: detect whether mattpocock/skills is installed, reuse its issue tracker and domain docs settings, and choose the profile, the active advisors, the artifact language and the loop limits. Run once per repo before the first team grill or build."
disable-model-invocation: true
---

# Setup Team

Scaffold the per-repo configuration the hats read: `docs/agents/team.md` and a `## Team` block in `CLAUDE.md` or `AGENTS.md`. Prompt-driven, not a script: explore, present what you found, confirm, then write.

## 1. Explore

Read what exists; assume nothing:

- Are Matt's skills installed? Look for `grilling`, `tdd`, `to-tickets` among the skills available to you, or a `skills/` folder carrying them. This sets the **mode**: `with-matt` or `standalone`.
- `docs/agents/issue-tracker.md` and `docs/agents/domain.md`: Matt's setup output. When present, the tracker and the domain layout are settled; never re-ask them.
- `docs/agents/team.md` and a `## Team` block: a previous run of this skill, to update in place.
- Which harness is this: Claude Code (a `.claude/` folder, or this skill loaded from a Claude plugin) or Codex (`.codex/`, `.agents/skills/`, or this skill loaded from `~/.codex`). It decides which file carries the block (step 3) and whether step 4 runs.
- `CLAUDE.md` and `AGENTS.md` at the root, and whether `CLAUDE.md` imports the other (`@AGENTS.md`).
- Signals for the conditional advisors: a frontend (templates, components, a `src/pages` or `app/` tree) and a data layer (migrations, models, an ORM). Not asked; recorded as hints.

## 2. Present and ask

Summarise mode, harness, and what Matt's setup already settled. Then one section at a time, leading with the recommended answer so the user can accept it in a word.

**A. Tracker and domain docs.** Skip when Matt's docs exist. Otherwise ask where tickets live, with the same choices Matt's setup offers (GitHub with `gh`, GitLab with `glab`, local markdown under `.scratch/<feature>/`, other described in a paragraph), and write `docs/agents/issue-tracker.md` in the same shape so both plugins read one file. Recommended: what the git remote points at; local when there is none.

**B. Profile.** Only matters under `automatic` dispatch (section E). `express` (recommended): advisors fire on round 1 and the final confirmation of a grill. `feature`: also on every round that opened a new area. Under `on request` the profile is recorded and ignored, because every pass after round 1 is the user's call.

**C. Advisors.** All six active by default: `lgpd-analyst`, `security-analyst`, `qa-expert`, `ux-expert`, `dba`, `sre`. `lgpd-analyst`, `ux-expert`, `dba` and `sre` are conditional by design (personal data, UI, persistence, runtime); an advisor switched off here is never dispatched. A repo may add its own advisor: a persona in the harness's agents folder that follows `team-contribution`; list it here to activate it.

**D. Artifact language.** The language of contribution files, specs, tickets and review verdicts. Recommended: the language the user wrote to you in.

**E. Dispatch after the first grill round.** `on request` (recommended): the roster is dispatched once, on the grill's first round; every later pass (more grill rounds, the spec review, the ticket check, branch reviews) is offered with its cost and runs only when the user says so. `automatic`: every hook fires without asking. Say why the default is what it is: a build that loops can produce several opinions per specialist per ticket, and the cost of advice overtakes the cost of the work.

**F. Models.** Advisors and reviewers: `sonnet` (recommended; a dispatch on it costs a fraction of one on the session's model, and an advisor's question is cheaper to get right than a builder's code). Builders: `inherit` (recommended; the session's model does the hard work). The hats pass these at dispatch; nothing is forked. Say that `inherit` for advisors is one line away if their advice turns out thinner than the project needs.

**G. Limits.** Review loop before escalation: 2. Builders in parallel: 3. Advisor rounds per artifact: 2. Accept or change.

## 3. Confirm and write

Show the draft of `docs/agents/team.md` (seed: [team.md](./team.md)) and of the `## Team` block (seed: [team-block.md](./team-block.md)) filled in. Let the user edit. Then write:

- `docs/agents/team.md`
- the `## Team` block, into **the file this harness reads**: Codex reads only `AGENTS.md`, so on Codex the block goes there, whatever else exists; Claude Code reads `CLAUDE.md`, so on Claude it goes into `CLAUDE.md` when it exists, else `AGENTS.md`. When the other file also exists and neither carries nor imports the block (a `CLAUDE.md` that is just `@AGENTS.md` imports it), write the block there too, so a repo used from both harnesses has it in both. When neither file exists, create `AGENTS.md`. Update an existing block in place; leave the surrounding sections, including Matt's `## Agent skills`, untouched.

## 4. Codex only: hand the agent install to the human

The Codex plugin manifest cannot ship agents, and the Codex sandbox refuses writes under `.codex/`, so this step is the human's. The TOMLs travel inside this skill folder, at [codex-agents/](./codex-agents/), one per role. Resolve this skill's absolute folder (the path you read this file from), then give the user one command to run in the repo root, with that path filled in:

```bash
mkdir -p .codex/agents .codex/rules && cp "<this skill folder>/codex-agents/"*.toml .codex/agents/ && cp "<this skill folder>/codex-rules/default.rules" .codex/rules/default.rules
```

The second copy matters as much as the first: Codex's `workspace-write` sandbox keeps `.git` read-only by design, so without [codex-rules/default.rules](./codex-rules/default.rules) (which pre-allows `git worktree`, `git commit` and `git add`) every builder commit escalates to the human and a parallel build stalls on the first one. When a `.codex/rules/default.rules` already exists, show the three `prefix_rule` lines and ask the user to append them instead of overwriting.

Attempt the copies yourself first only when the harness allows; on a refusal, show the command and wait. Then verify: list `.codex/agents/` (one file per active role) and `.codex/rules/`. Tell the user the files are generated and get replaced on the next run of this skill; local edits belong in a repo-owned persona instead. Two config notes for them, in one line each: `[agents] max_concurrent_threads_per_session` in `.codex/config.toml` caps the parallel builders; headless runs (`codex exec`) cannot escalate, so they need `writable_roots = ["<absolute repo path>/.git"]` under `[sandbox_workspace_write]`. The model settings from section F do not apply on Codex: roles inherit `config.toml`.

## 5. Done

Say which skills now overlay: with Matt, `grill-with-docs`, `grill-me`, `to-spec`, `triage` load `team-grill` and `implement`, `to-tickets`, `diagnosing-bugs`, `improve-codebase-architecture` load `team-implement`; standalone, the user invokes `team-grill` and `team-implement` directly (`/name` on Claude, `$name` on Codex). Point at `/ask-team` for the map. Re-running this skill is only needed to change a setting.
