# The other flows the hat wears

Read the section for the Matt skill the user ran. Steps 1 to 6 of `SKILL.md` do not apply to these.

## When the user ran `/to-tickets`

Steps 1 to 6 do not apply. Before `to-tickets` publishes, offer one dispatch with its cost ("a `senior-developer` implementability pass on the <n> tickets: 1 dispatch") and, on a yes or under `automatic`, dispatch `senior-developer` once on the draft ticket set (implementability: does each seam exist, what does each ticket assume that the code contradicts, which blocking edge is missing), file under `.scratch/<feature-slug>/team/tickets/`. Fold its facts into the tickets and its `OBJECT [judgment]` items into a question for the human, then let `to-tickets` publish.

## When the user ran `/diagnosing-bugs`

Wear the hat while `diagnosing-bugs` runs. Offer `qa-expert` for the tight loop (1 dispatch) and, on a yes or under `automatic`, dispatch it to produce the tight loop (one command that goes red on this bug) and record it as the loop the fix is judged against. Once the diagnosis names the fix, dispatch `senior-developer` on a branch with the loop command and the diagnosis; the QA expert reviews the returned branch as in step 4. Merge as in step 5.

## When the user ran `/improve-codebase-architecture`

Wear the hat while the survey runs. Offer the two dispatches with their cost and, on a yes or under `automatic`, dispatch `senior-developer` (deepening opportunities in the modules it knows from past tickets, seams that made building hard) and `dba` (data-layer debt) in parallel, blind, files under `.scratch/architecture/team/`. Their facts and candidates feed the survey; the ranking and the pick stay with the human.
