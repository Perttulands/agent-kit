---
name: diagnosing-bugs
description: Diagnose bugs and performance regressions through a symptom-specific feedback loop. Use when the user explicitly requests it.
---

# Diagnosing bugs

Build a **tight** signal for the user's exact symptom, then let evidence choose
the fix. Record the verified cause and fix on the owning bug issue or PR. Read the relevant code, glossary, and ADRs before changing it.

## Build the feedback loop

State expected and observed behavior. Choose the cheapest observation that
can distinguish them: a failing test, CLI fixture, HTTP request, browser
journey, trace replay, or small isolated harness. Inspecting code to construct
that observation is part of diagnosis.

Run it before fixing anything. Record the command, relevant output, and why
its failure is the reported bug rather than a setup error. Keep credentials
in their normal environment and extract only non-secret diagnostic fields;
never dump an entire authenticated request or private log.

Tighten the loop by reducing setup, pinning inputs and time where useful, and
asserting on the actual symptom. Prefer seconds to minutes, but use the
credible signal the system permits. For intermittent bugs, record trials and
failure rate, then improve reproduction under controlled conditions. A
statistical signal needs a rate and sample size, not a claim of determinism.

When the symptom cannot currently be reproduced, distinguish observations
from hypotheses. Logs, a captured trace, or a known transition may support a
bounded investigation, including a failure that preflight already healed.
State what causal claim remains unverified. If no discriminating evidence is
available, report the attempts and request the specific missing evidence or
access. Do not certify a fix from a plausible explanation alone.

For a human-only reproduction, adapt `scripts/hitl-loop.template.sh` so the
manual steps and returned evidence remain repeatable. Production
instrumentation or stress requires authority for that environment.

## Reproduce and minimize

Confirm the signal catches the user's failure. Reduce inputs, callers, data,
and steps one at a time, keeping the failure after each reduction. Stop when
further cuts would remove the interaction that matters or cost more than they
clarify. Preserve the original scenario for final verification.

An in-suite flake that passes in isolation is not exonerated. A name filter
skips earlier tests and changes shared state, such as an unseeded random
sequence; rerun the whole file. To prove a change to a randomized engine moved
nothing else, seed the random source and diff old and new outcomes exactly;
repeated statistical runs of identical code differ on their own.

When a producer's data shape changes, check each consumer's falsy guards too:
a removed field reads as `NaN` or `undefined`, and `|| 0` turns it into a
plausible zero.

For performance, establish the environment, baseline, workload, and metric
before comparing revisions. Profile the expensive path or bisect against the
measurement; logs alone do not measure a regression.

## Test hypotheses

Rank the plausible causes that fit the evidence. Give each a falsifiable
prediction: changing or observing what would distinguish it from the others?
Use competing hypotheses when uncertainty warrants them; inventing extra
theories to fill a quota adds no evidence.

State the leading prediction before testing it. Use a debugger, a focused
probe, or tagged temporary instrumentation, changing one relevant variable at
a time. Update the ranking when evidence disagrees. Keep the user informed
without turning each probe into a routine approval request.

## Fix and verify

When a test seam can exercise the real bug pattern, turn the reproduction into
a failing regression test before the fix. Include the actual caller
interaction; a shallow helper test may miss the failure entirely. If no such
seam exists, record that limitation rather than add a test that proves less.

To prove the test bites, break the source deliberately and restore it from a
copy; `git checkout` restores HEAD and discards other uncommitted edits in the
file.

Apply the smallest correction supported by the evidence. Verify the regression
test, then rerun the original scenario and relevant neighboring checks.
Separate a recovered current state from proof that the cause was eliminated.

Before closing the bug:

- remove your tagged instrumentation and disposable harnesses unless retained
  as deliberate diagnostic tools;
- record the verified cause, change, and evidence, plus any unresolved limit;
- confirm every acceptance criterion with fresh results.

Diagnosis authorizes only the assigned work. Link unrelated discoveries as
follow-up issues and leave them outside the fix.
