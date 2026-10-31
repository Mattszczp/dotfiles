---
name: "review-overengineering"
description: "Review a diff or change for over-engineering and reinvented wheels, then propose simpler code. Use when asked to review, simplify, or check code before committing."
---

# Review for over-engineering

Goal: find code that can be deleted, inlined, or replaced by a library.

## Process

1. Get the change: `git diff` (or `git diff --staged`) if the directory is a repo, otherwise the files the user named.
2. Run the checks below against the change, not the whole codebase.
3. Report only real findings, each with file and line.
4. For each finding, give the simpler option, concretely.
5. Apply fixes only if asked. Otherwise list them.

## Checks

- **Speculative generality**: interfaces or abstract classes with one implementation; generic parameters used with one type; factories or strategies for one case; extension points nothing calls.
- **Unneeded configuration**: options, flags or env vars with only one value ever used.
- **Pass-through layers**: functions or classes that only forward to another call.
- **Premature abstraction**: helpers used once; two similar lines pulled into a utility.
- **Dead code**: unused exports, unreachable branches, commented-out code, unused parameters.
- **Defensive code for impossible states**: null checks on values the types guarantee; try/catch that only rethrows or logs and continues.
- **Hand-rolled infrastructure**: custom HTTP client, retry loop, cache, date or timezone arithmetic, validator, parser, deep clone or deep equal, UUID generation, CLI parsing, crypto. For each, name the library that does it (see the prefer-libraries skill).
- **Long solutions**: a hand-written loop or class where a standard library call or a one-liner does the job.

## Output

Order findings by impact. For each: `file:line`, what is wrong, and the simpler option. End with the net effect (roughly how many lines could go). If nothing is over-engineered, say so in one line. Don't invent findings to fill the list.
