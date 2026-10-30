---
name: tdd
description: Test-driven development for test-first work, red-green-refactor, or integration tests. Use when the user explicitly requests it.
---

# Test-driven development

Work in vertical slices: one behavior, one failing test, enough implementation
to pass. Use the owning issue's acceptance criteria as the source of expected
behavior. Read the project's glossary and relevant ADRs.

## Choose the seam

Test through the public interface where the real behavior is observable.
Reuse seams already settled by the user, reviewed brief, or project contract.
If choosing a new seam changes scope or leaves an important behavior unproved,
resolve that choice before writing the test. An accepted seam needs no second
confirmation.

Internal helpers are not new public interfaces merely because they are easy\nto test.

## Keep the test independent

- Assert a caller-visible outcome that survives an internal refactor.
- Take expected values from the requirement, a worked example, or a known-good
  fixture. Recomputing the implementation in the assertion proves nothing.
- Exercise the real call pattern, including multiple callers when the bug
  depends on their interaction.
- Mock external dependencies at their boundary; keep the behavior under test
  real. Read [mocking.md](mocking.md) when choosing test doubles and
  [tests.md](tests.md) for examples.

## Run the loop

1. Write one test and run it. Confirm it fails for the missing behavior,
   rather than a broken fixture or setup.
2. Implement only enough to pass, then rerun it.
3. Repeat with the next behavior the acceptance criteria require. Each test
   is a tracer bullet that informs the next slice; avoid a speculative batch
   of tests before any implementation.
4. Once green, make any justified refactor as a separate implementation pass
   and keep the behavior tests green. A reviewer reports findings; the
   implementation owner changes code.

Finish with the acceptance criteria verified through the chosen seams and
relevant regression checks passing. Record the evidence on the owning PR
and use code review in proportion to the change.
