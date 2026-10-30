---
name: handoff
description: Leave a concise, resumable handoff on the owning PR or issue for another agent or session. Use when the user asks for a handoff, or when work must continue in another session or after a context reset.
---

# Handoff

The handoff goes on the owning work in the repo's tracker, not in a parallel Markdown file.

Write a current-state summary, recording only what another agent cannot reconstruct cheaply:

- current status and the exact next action;
- changes made but not yet verified, committed, or pushed;
- verification already run and its result;
- blockers and decisions waiting on the user;
- linked follow-up issues;
- relevant paths, revisions, or runtime state.

Link ADRs, research, commits and diffs rather than copying them, and never include secrets. Push committed work first so the revisions you name resolve.

Place it on the owning work:

- **Owning PR:** rewrite the handoff section of the PR description, replacing stale content rather than appending. When the description belongs to someone else, comment instead.
- **Owning issue only:** comment on the issue.
- **Neither:** put the handoff in your final message.

Leave the PR's draft or ready state truthful, then return a link to the handoff.
