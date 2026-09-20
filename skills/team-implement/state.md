# Estado: <feature-slug>

Written and read by the Tech Lead hat (`team-implement`). One row per ticket the
hat has touched. It exists so a session that dies mid-build can be resumed
without losing what was in flight: which builder is out, how many review loops a
ticket has already consumed, which reviewers have returned.

Update it at four moments, and never from memory: after dispatching a builder,
after a builder returns, after each review round, and after a merge or an
escalation.

Updated: <YYYY-MM-DD HH:MM>

| Ticket | State | Branch | Loops | Reviewers returned | Note |
|---|---|---|---|---|---|
| 01-slug | merged | team/<feature>/01-slug | 1 | qa, dba, security | |
| 02-slug | in review | team/<feature>/02-slug | 0 | qa | waiting on sre |
| 03-slug | building | team/<feature>/03-slug | 0 | | dispatched HH:MM |
| 04-slug | escalated | team/<feature>/04-slug | 2 | qa | awaiting human ruling on QA finding 3 |
| 05-slug | blocked | | 0 | | blocked by 03 |

States: `blocked`, `ready`, `building`, `in review`, `escalated`, `merged`,
`dropped`. `Loops` counts reviewer-to-builder round trips already spent against
the limit in `docs/agents/team.md`.

## Open rulings

One line per question waiting on the human, with the ticket it blocks. When two
reviewers raise the same judgment, it is one line with both cited.

## Rulings

One line per decision the human made, dated, moved here from Open rulings when
it lands: `- <date> <ticket> <question, short>: <ruling>`. The ruling also goes
into the ticket; this list is what a resumed session reads to know what was
already decided, so it never asks twice.

## Log

Append one line per event, newest last. `HH:MM verb ticket detail`.
