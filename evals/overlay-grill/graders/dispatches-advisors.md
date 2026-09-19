---
type: llm
weight: 1
---

The response runs the interview as a Product Owner who first sends specialists to gather facts, rather than interviewing from its own knowledge alone.

PASS when it names specialists it will consult or dispatch before or during the round (for example privacy/LGPD, security, QA, UX, DBA), or presents questions attributed to those specialties.

FAIL when it asks its questions with no mention of any specialist role at all.
