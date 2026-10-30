# Skill mechanics

The skill-specific branch of [writing-for-agents](SKILL.md). Use it for
frontmatter, invocation, and routing; the main reference governs the writing.

## Frontmatter

Every shared skill has a `SKILL.md` with YAML `name` and `description`. Match
the name to its directory. Preserve existing optional metadata.

The description is the context pointer. For automatic discovery, front-load
the use case and distinct trigger branches. For a deliberately human-facing
command, use a short summary. A shorter description changes the pointer; it
does not itself enforce an invocation restriction.

## Invocation

The description is the only invocation control in this catalog. Every skill in
the repository is visible to the model, and reading its description must tell
the operator when it loads.

End each description with a plain use-when clause. Skills come in two kinds:

- **Workflows the user invokes** (an interview, a review campaign, an
  orchestration pattern) end with "Use when the user explicitly requests it."
  A plain-language request counts, and so does a mission or brief that names
  the skill. Once invoked, the workflow runs through without asking again.
- **Operating knowledge** (facts about tools and services, preferences, formats)
  stays loadable on its own. It carries no mandatory stages, gates or required
  hand-offs to other skills, because capable agents follow such steps to a
  fault.

Do not add harness switches such as Claude Code's
`disable-model-invocation` frontmatter or Codex's
`policy.allow_implicit_invocation: false` in `agents/openai.yaml`; they hide a
skill in one harness and make loading impossible to read from the description.

A smaller model may still load a request-only skill on a content match. Accept
that, or tighten the description; do not reach for a switch.

## Composition

A router names a capability and the condition for reaching it. Use the current
catalog name and an exact reference, not a remembered display title. Use the
harness's supported invocation mechanism; when file reading is the supported
mechanism, read the referenced instructions. Honor enforced invocation
restrictions rather than working around a refused invocation.

If a restricted skill cannot be invoked by another workflow, put the shared
reference in a plain file both workflows can reach. A router can instead tell
the human which command to invoke when the timing belongs to them.

Split a skill when a distinct trigger or a real sequence boundary earns the
extra document. Keep common steps in the entrypoint and disclose branch-only
reference behind a pointer. A router earns its place by reducing the choices
the human must remember, not by adding another mandatory phase.

## Verify the route

Check frontmatter, local links, and the target harness's discovery metadata.
Try representative requests for the intended branch and a nearby request
that should not select it. Distinguish a catalog listing or successful file
read from evidence that the agent followed the workflow correctly.
