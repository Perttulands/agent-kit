---
name: code-review
description: Review a code change against its owning issue or PR and repository standards. Use when the user asks for a review, or when you bring in a reviewer for a concrete risk.
---

# Code review

Review two separate questions:

- **Intent:** does the change satisfy the owning issue or PR without missing requirements or adding unapproved scope?
- **Quality:** is the implementation correct, simple, maintainable, and consistent with repository standards?

## Establish the review

1. Read the owning issue and PR description, and their acceptance criteria.
2. Identify the fixed point: the revision the user or requesting agent gave, the PR's base, or ask for the missing boundary.
3. Verify the revision resolves and inspect the complete diff and commit list.
4. Read the repository instructions, relevant domain docs, standards, tests, and affected callers.

Review in large chunks: a feature or a milestone's worth of work, not every PR. Findings outside the owning issue's goal go into new issues, not into the work under review, so the review doesn't cause drift.

For a small focused change, one reviewer may evaluate both axes. For substantial or subtle work, use independent reviewers so intent and quality do not mask one another. Separate-agent review is proportional, not mandatory ceremony.

## Intent review

Check every acceptance criterion against code and fresh verification evidence. Report missing or partial behavior, incorrect behavior, and scope that the issue did not authorize. Treat the owning issue, or the PR description when there is no issue, as the specification, not a plan document or branch name.

## Quality review

Look for correctness failures, broken invariants, inadequate tests, unnecessary complexity, poor module boundaries, and violations of documented repository standards. Distinguish concrete defects from optional improvements. Do not demand speculative abstraction or hardening unrelated to the owning work.

## Report and persist

Lead with actionable findings, ordered by severity, with precise file and evidence references. Then state the verdict: `pass` or `revise`.

For a substantial review with an owning PR, record the fixed point, verdict and findings that change the work as a comment on the PR. Code Review is read-only unless the user also asked for fixes; findings become work on the existing PR or a linked follow-up issue as appropriate.
