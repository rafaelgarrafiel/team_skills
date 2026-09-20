# Changelog

## 0.3.1

- Codex builders: the Tech Lead creates each builder's worktree with plain git when the dispatch has no isolation and briefs the path; `setup-team` installs `.codex/rules/default.rules` (pre-allowing `git worktree`, `commit`, `add`) with the TOMLs, because the sandbox keeps `.git` read-only and every commit would otherwise escalate; the model parameter is omitted on Codex; sequential building is the explicit floor. Bindings taken from AI-DLC's live-verified Codex harness.
- Cheaper per turn and per dispatch: the contract splits into a short `SKILL.md` for supports and a `BRIEFING.md` for hats, so every dispatch carries only what the support needs; the Tech Lead offers a fresh session after the second merge (state is complete at a merge, and a session's cost grows with every ticket it carries); a re-dispatched builder skips `code-review` because the reviewers' findings are that round's review; every test run is quiet, summary line only.
- Tech Lead hygiene: the local tracker's closing status is always `done`; a builder's worktree is checked out directly on the `team/<feature>/<NN-slug>` branch, and any throwaway `worktree-agent-*` branch the harness created is deleted with the worktree.
- Resume, from the second real recovery: `state.md` gains a `## Rulings` list the resumed session reads so it never asks a settled question twice; a `building` ticket whose branch has commits but whose summary died with the session is verified by the builder, not rebuilt; a review that blocks writes its findings and the human's ruling to `round-<N>-brief.md` before the builder is re-dispatched, so a resumed session re-dispatches against the same text.

## 0.3.0

- **Dispatch once, then on request.** The roster fires once by default, on the grill's first round; every later pass (grill rounds, the spec review, the ticket check, branch reviews, triage and bug helpers) is offered with its cost and runs only when the human says so. A branch merges on the builder's own review and suite; team reviews are one `review NN` away. `docs/agents/team.md` gains `Dispatch after the first grill round: on request | automatic`; `automatic` is the 0.2 behaviour. ADR 0006 has the numbers from the first project.
- Contribution files are capped: eight facts, six items, one line per position.
- **Cheaper dispatches** (ADR 0007): the hat collects the repo's shared facts once and puts them in every brief; supports read this repository only, from the named paths, and stop when they can answer (twenty files at most); advisors and reviewers run on the model set in `docs/agents/team.md` (`sonnet` by default), builders on theirs (`inherit`); `lgpd-analyst` joins by condition like UX, DBA and SRE.
- Codex: the `## Team` block goes into the file the harness reads (`AGENTS.md` on Codex), the agent TOMLs ship inside the `setup-team` skill, and their install into `.codex/agents/` is a command the skill hands to the human.
- Behavioural eval suite under `evals/`, run with `scripts/eval.sh`.

## 0.2.0

- `sre` advisor: observability, deploy and rollback, incidents, runtime capacity, CI/CD, and every scheduled behaviour the design tree assumes without naming its trigger. Joins by condition, like `ux-expert` and `dba`.
- The Product Owner hat reaches for `codebase-design` when the design tree turns structural; system decomposition is the hat's own work, never a dispatch.
- `team-implement` keeps a resumable state file per feature: tickets in flight, review loops spent, reviewers returned.
- `check.sh` in `team-contribution`: both hats verify every dispatched support left a well-formed contribution file before closing a round.

## 0.1.0

- Initial roster: Product Owner and Tech Lead hats (`team-grill`, `team-implement`), advisors `lgpd-analyst`, `security-analyst`, `qa-expert`, `ux-expert`, `dba`, builder `senior-developer`.
- `setup-team`, `ask-team`, `team-contribution`.
- Claude Code plugin with a `PreToolUse` overlay hook; Codex plugin with agents installed by `setup-team`.
