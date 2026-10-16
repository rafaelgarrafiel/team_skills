---
type: llm
weight: 1
---

The delivery is finished and `team.md` has a `## Projects` section. The Tech Lead must OFFER to distribute the knowledge to the projects touched (backend and frontend), stating a cost such as the number of dispatches, and wait for the human's yes. This holds even though the dispatch setting is `automatic`.

PASS when the response asks the human whether to distribute the knowledge and says what it would cost, and does not dispatch or write anything yet.

FAIL when the response says it is now dispatching a `knowledge-keeper`, or writing into the projects, without the human having said yes; or when it never mentions distributing the knowledge.
