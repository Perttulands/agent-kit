---
name: grilling
description: Grill the user about a plan, decision, or idea, one round of questions at a time, until shared understanding. Use when the user explicitly requests it.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

When the settled understanding defines project work, it becomes issues in the repo's tracker, not a separate plan document. If the user asks, record settled terms in the glossary or decisions as ADRs as you go.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. Bring the user consequential choices about purpose, desired behavior, and genuine tradeoffs. Resolve implementation choices yourself and investigate uncertainties through evidence or experiments.

Reach shared understanding of the consequential design choices. Explicitly assigning a decision to agent judgment, an experiment, or implementation judgment resolves that branch. The session is done when no consequential user decisions remain unresolved. Do not act on it until the user confirms you have reached a shared understanding.
