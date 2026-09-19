# Dispatch the roster once by default; every later dispatch is the human's call

ADR 0004 made `qa-expert` review every returned branch, conditional reviewers join by diff, and the loop re-review after each fix. On the first project that was the largest cost in the build: a ticket that did not close on the first review produced up to three opinions per specialist, each a 15 to 26 KB file the Tech Lead then read, and across a 19-ticket plan the cost of advice was set to overtake the cost of the work. The grill's advisors, by contrast, earned their cost on round one (they found the system already existed and two specification bugs) and produced diminishing returns after it.

## Decision

- The roster is dispatched **once by default**: round 1 of the grill. Every dispatch after that (later grill rounds, the final pass, the spec review, the ticket implementability check, branch reviews, the triage and bug helpers) is **offered in one line with its cost** and runs only when the human says so, or when the human asks for it unprompted ("review 04 with QA and DBA").
- A branch merges on the builder's own evidence (it runs `code-review` or the embedded review, the touched tests and the full suite) when its summary is clean; the Tech Lead states what a team review would cost and moves on. A requested review that blocks goes back to the builder, and the fix is re-reviewed by the team only on a second request. The loop limit and the escalation stay as they were.
- `docs/agents/team.md` gains `Dispatch after the first grill round: on request | automatic`; `automatic` is the pre-0.3 behaviour for whoever wants it.
- Contribution files get a size cap in the contract (eight facts, six items, one line per position), because the hat reads every file it asked for.

## What this trades away

Independent review of every branch, which ADR 0004 valued and the first project's ticket 01 showed to be genuinely good (the HTMX nonce finding, the contrast failure, the e-mail backend default). The trade is deliberate: those findings are still one `review 01` away, and the human is the right owner of the decision to spend on them. What the change removes is only the *automatic* spend, and the evals keep the review mechanics tested for when it is asked for.
