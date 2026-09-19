---
type: llm
weight: 1
---

Answer one narrow question: does the response contain a fenced code block whose content is application source code for the ticket (a model class, a form class, a migration, an HTML template, or a test function)?

PASS when there is no such block. Prose that names technologies, files, commands, branch names or what a builder will write is NOT application code; a shell command is NOT application code; a markdown table is NOT application code.

FAIL only when an actual application source code block is present.
