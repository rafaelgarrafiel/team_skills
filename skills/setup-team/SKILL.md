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
- `CLAUDE.md` and `AGENTS.md` at the root: which exists decides where the block goes.
- Which harness is this: Claude Code (a `.claude/` folder or this skill loaded from a Claude plugin) or Codex (`.codex/`, `.agents/skills/`). Codex needs step 4's agent install.
- Signals for the conditional advisors: a frontend (templates, components, a `src/pages` or `app/` tree) and a data layer (migrations, models, an ORM). Not asked; recorded as hints.

## 2. Present and ask

Summarise mode, harness, and what Matt's setup already settled. Then one section at a time, leading with the recommended answer so the user can accept it in a word.

**A. Tracker and domain docs.** Skip when Matt's docs exist. Otherwise ask where tickets live, with the same choices Matt's setup offers (GitHub with `gh`, GitLab with `glab`, local markdown under `.scratch/<feature>/`, other described in a paragraph), and write `docs/agents/issue-tracker.md` in the same shape so both plugins read one file. Recommended: what the git remote points at; local when there is none.

**B. Profile.** `express` (recommended for most repos): advisors join round 1 and the final confirmation of a grill; reviews are QA plus the conditional reviewers. `feature`: advisors also join every round that opened a new area. The profile changes how often supports are dispatched, never which gates exist.

**C. Advisors.** All six active by default: `lgpd-analyst`, `security-analyst`, `qa-expert`, `ux-expert`, `dba`, `sre`. `ux-expert`, `dba` and `sre` are conditional by design (UI, persistence, runtime); an advisor switched off here is never dispatched. A repo may add its own advisor: a persona in the harness's agents folder that follows `team-contribution`; list it here to activate it.

**D. Artifact language.** The language of contribution files, specs, tickets and review verdicts. Recommended: the language the user wrote to you in.

**E. Limits.** Review loop before escalation: 2. Builders in parallel: 3. Advisor rounds per artifact: 2. Accept or change.

## 3. Confirm and write

Show the draft of `docs/agents/team.md` (seed: [team.md](./team.md)) and of the `## Team` block (seed: [team-block.md](./team-block.md)) filled in. Let the user edit. Then write:

- `docs/agents/team.md`
- the `## Team` block, into `CLAUDE.md` if it exists, else `AGENTS.md`; when neither exists, ask which to create. Update an existing block in place; leave the surrounding sections, including Matt's `## Agent skills`, untouched.

## 4. Codex only: install the agents

The Codex plugin manifest cannot ship agents. Copy every `<plugin root>/dist/codex/agents/<role>.toml` for an active role (the six advisors and `senior-developer`) into the repo's `.codex/agents/`, creating the folder. Tell the user the files are generated and get replaced on the next run of this skill; local edits belong in a repo-owned persona instead.

## 5. Done

Say which skills now overlay: with Matt, `/grill-with-docs`, `/grill-me`, `/to-spec`, `/triage` load `team-grill` and `/implement`, `/to-tickets`, `/diagnosing-bugs`, `/improve-codebase-architecture` load `team-implement`; standalone, the user runs `/team-grill` and `/team-implement` directly. Point at `/ask-team` for the map. Re-running this skill is only needed to change a setting.
