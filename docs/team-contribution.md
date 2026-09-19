## What it does

`team-contribution` is the contract every advisor, reviewer and builder follows: what a brief contains, the one file each support writes (`Facts`, `Contribution`, `Positions`), the two kinds of objection and how each is triaged, the two-round limit, and the return summaries. It is what makes a dispatch checkable: a support that did not write its file did not contribute.

## When to reach for it

The agent reaches for it on its own: every persona loads it at dispatch, and the hats follow it when they brief and read returns. You read it when you want to know what a file under `.scratch/<feature>/team/` means.

## Positions, not opinions

Each support ends with `AGREE` or `OBJECT` lines. An objection is tagged `[judgment]` (both positions are legitimate; the human rules) or `[knowledge]` (an expert can settle it; the objecting supports get one more round with each other's positions). Whatever survives is quoted verbatim where the decision is made: the spec, the ticket, the review verdict. Dissent stays on disk.

## Checked, not trusted

Before a hat closes a round it runs `check.sh` against the directory and the slugs it dispatched: every support has a file, every file opens with its identity marker and carries the three sections. One re-dispatch for what fails, then you hear about it. A dispatch that produced no file produced no advice, and a return summary cannot tell you which happened.

## It's working if

- Every file under `.scratch/<feature>/team/` opens with `**Collaborator:** <role>`.
- A maintained objection is findable in the spec or ticket, not only in a chat summary.
- The hat names the check's result before showing you a round, and re-dispatches rather than proceeding short.

## Where it fits

The vocabulary underneath [team-grill](./team-grill.md) and [team-implement](./team-implement.md). A repo adding its own advisor writes a persona that follows this contract.
