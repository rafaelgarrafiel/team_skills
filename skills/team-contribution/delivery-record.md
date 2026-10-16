# Delivery record: the shape

Read this when you are the `knowledge-keeper`. One record per delivery and project, at `docs/deliveries/<slug>.md` in the project, in the project's language. Each section summarises what the cockpit holds and cites its path; none of it is pasted whole. A section with nothing for this project says "nothing for this project" so the reader knows it was checked.

```markdown
# <Delivery title>

Delivered: <date> | Branch: <branch> | Full delivery: <cockpit path or tracker link to the spec>

## Why
The problem and the decision, in the words of the spec, at most a short paragraph.

## What changed here
The part of the spec that concerns this project, as a summary. Name the behaviour, not the files.

## Tickets
| Ticket | What it did in this project | Status |
|---|---|---|

## Reviews
One line per review verdict that concerns this project: reviewer, verdict, the finding that mattered. Maintained objections are quoted verbatim, with the reviewer named.

## Decisions
Links to the ADRs written in this project for this delivery, each with its `Origin`.

## Terms
Glossary terms added or changed for this delivery.
```
