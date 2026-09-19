## What it does

`team-grill` is the Product Owner hat: the interview that sharpens an idea, run on the main session with the advisors feeding it. You still answer one interviewer; behind that interviewer, the LGPD, security and QA advisors (and UX, DBA or SRE when the change touches a screen, data or production) read the repo and send facts and candidate questions into the frontier before each round. The human never gets asked what an advisor could look up.

## When to reach for it

Type `/team-grill`, or, with Matt's skills installed, the agent loads it on its own when you run `/grill-with-docs`, `/grill-me`, `/to-spec` or `/triage` in a repo where `/setup-team` has run.

| Situation | Reach for |
|---|---|
| An idea to sharpen, with Matt installed | `/grill-with-docs` as always; the hat runs inside |
| The same, without Matt | `/team-grill` directly (embedded rounds, same advisors) |
| A plan with no repo and no advisors wanted | Matt's `/grill-me` with team mode off |

## Prerequisites

`/setup-team` once per repo. It records the mode, the active advisors and the artifact language the hat reads. The advisors write under `.scratch/<feature-slug>/team/grill/`.

## Facts in, questions out

Each round the hat drafts, then dispatches the advisors blind and in parallel. What comes back splits in two: **facts** (where personal data already lives, how auth works today, how the repo runs its tests) go into the design tree and are read to you as facts; **candidate questions** join the round tagged by origin (🔒 🛡️ ✅ 🎨 🗄️ 📡) with the advisor's recommended answer. An advisor's `OBJECT [judgment]` becomes a question for you; an `OBJECT [knowledge]` sends the advisors into one more round among themselves. Whatever stays in dissent is read back to you before you confirm the shared understanding, and lands in the spec under `## Team positions`.

## Structure is the hat's own work

Where an advisor owns a domain, nobody owns how the system is put together: a boundary, what a module hides, whether this is one thing or two. When the tree turns structural the hat reaches for `codebase-design` itself and runs the round in that vocabulary, rather than dispatching anyone. Decomposition cannot be delegated without delegating the whole design.

## Common questions

**Does it replace `/grill-with-docs`?**
No. With Matt's skills, `grilling` and `domain-modeling` still run the rounds and write `CONTEXT.md` and the ADRs; the hat only adds the advisors. Without them, the hat runs a minimal embedded version of the rounds, and no `CONTEXT.md` or ADRs are produced.

**Why do the advisors never talk to me directly?**
A subagent cannot hold a conversation with you; it runs and returns. So the advisors talk to the hat, and the hat talks to you. That is also why decisions stay yours: an advisor recommends, the round asks, you rule.

## It's working if

- A round contains questions you did not expect, tagged with an advisor's mark, each with a recommendation.
- Facts arrive as statements ("the repo already stores CPF in `users.document`"), not as questions to you.
- `.scratch/<feature>/team/grill/` fills with one file per advisor, and the final confirmation reads any maintained objection back to you.

## Where it fits

The first step of the team's chain (`team-grill → /to-spec → /to-tickets → team-implement`) and the hat under Matt's `/to-spec` and `/triage`. Its sibling is [team-implement](./team-implement.md), the Tech Lead hat that takes over once tickets exist. The map is [ask-team](../skills/ask-team/SKILL.md).
