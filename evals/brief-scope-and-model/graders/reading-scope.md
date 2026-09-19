---
type: llm
weight: 1
---

Does the brief shown to the user tell the dba where and how much to read?

PASS when the brief (a) restricts reading to this repository, or names the paths to start from (for example `painel/migrations/`), and (b) tells the support to stop reading once it can answer, or sets a cap on files read.

FAIL when the brief says nothing about reading scope, or invites the support to search beyond the repository.
