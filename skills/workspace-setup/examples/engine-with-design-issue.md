# A game engine with a settled-design issue (Rust, GitHub tracker)

Agents build it in parallel, locally and in cloud sessions.

**Setup**
- Tracker: GitHub. The settled design is one issue, and `AGENTS.md` points to it first. Work is issues under the current milestone, one branch and PR per issue.
- `AGENTS.md`: about ten lines. One line per principle (light, reference box is the floor, data first, game makers never compile, deterministic, CLI is the product), each with its reason or the CI job that enforces it, then the exact pre-push commands.

**What held up**
- A single design issue instead of a design doc: when the goal was re-aimed, only that issue and a few `AGENTS.md` lines changed.

**Watch**
- The design issue carries the re-aim history as well as the settled design. Keep the settled part at the top so an agent can stop reading there.
