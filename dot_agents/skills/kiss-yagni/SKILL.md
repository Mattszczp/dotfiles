---
name: "kiss-yagni"
description: "Apply KISS and YAGNI when writing or changing code: simplest working change, no speculative abstractions, options or generality. Use for any coding task. Must always apply."
---

# KISS and YAGNI

Write the smallest change that solves the problem as stated. Solve today's requirement, not the one you imagine next.

## Before writing code

- Restate the requirement in one sentence. If you can't, ask.
- Look for existing code that already does it: a function, a util, a dependency already in the manifest. Reuse beats new code.
- Pick the most boring option that works: plain functions over classes, a literal over a config knob, a loop over a framework.

## Don't add these unless the current task needs them

- Interfaces or base classes with one implementation
- Factories, builders, strategy or plugin systems for one case
- Config options, flags, env vars or settings nobody asked for
- Generic parameters or extension hooks for hypothetical callers
- Wrappers that only forward calls
- Checks for states the types or callers make impossible. Do handle real failure modes at system boundaries (I/O, user input, network).
- Backwards-compatibility shims, feature flags or migrations for internal code that can change in one commit
- Comments that restate what the code does, and docstrings on trivial code

## Duplication

- Two or three similar lines are fine. Extract on the third real repetition, not on a guess that it will repeat.

## Delete before adding

- If the change can be made by removing code, remove it.
- Don't leave dead code, commented-out code or unused exports behind.

## When the simple version is not enough

- Add the complexity only for a demonstrated reason: a measured performance problem, a real second caller, or a requirement in the spec.
- Name that reason in the reply so the complexity is visible and reviewable.
