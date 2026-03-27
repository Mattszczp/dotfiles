---
name: testing
description: >
  Write high-quality unit, integration, and end-to-end tests. Use this skill whenever
  the user wants to add tests, improve test coverage, write a test suite, or asks about
  testing strategy. Covers TypeScript with Vitest and Playwright, and Go with testify
  and table-driven tests. Trigger on phrases like "write tests", "add tests for this",
  "test coverage", "unit test", "integration test", "e2e test", "test this function",
  "test this endpoint", "playwright test", "vitest", "testify", or any request to verify
  correctness of code — even if the word "test" is not used explicitly.
---

# Testing Skill

You are an expert at writing clean, maintainable, high-signal tests. Your goal is to
write tests that **catch real bugs**, not just satisfy coverage metrics. Every test
should have a clear reason to exist.

Before writing any tests, read the source code being tested. Understand the contracts,
edge cases, and failure modes — don't just test the happy path.

## Choose the Right Test Type

| Type | When to use |
|------|-------------|
| **Unit** | Pure functions, business logic, utilities — anything with clear inputs/outputs |
| **Integration** | Multiple units working together — DB queries, service layers, API handlers |
| **E2E** | Full user flows through the UI — critical paths only, not exhaustive |

Prefer unit tests where possible. They're fast, precise, and easy to debug. Integration
tests are valuable but slower. E2E tests are expensive — use them for critical user
journeys only.

## Identify the Stack

Look at the imports and config files (package.json, go.mod, vitest.config.ts, etc.) to
detect the stack before writing anything. Then read the relevant reference:

- **TypeScript + Vitest** → read `references/vitest.md`
- **TypeScript + Playwright** → read `references/playwright.md`
- **Go + testify** → read `references/go.md`

If both TypeScript and Go are present, read both relevant files.

## Universal Principles

These apply regardless of language or framework:

**Test behavior, not implementation.** Tests should verify *what* the code does, not
*how* it does it internally. If you can refactor the internals without changing the
tests, you've written good tests.

**One concept per test.** Each test should verify exactly one thing. If a test fails,
it should be immediately obvious what broke.

**Descriptive names.** Test names should read like documentation:
- ✓ `should return 401 when token is expired`
- ✗ `test auth`

**Arrange-Act-Assert.** Structure every test with a clear setup, a single action, and
focused assertions. Use blank lines to separate the three phases when helpful.

**Test the unhappy paths.** Errors, empty inputs, boundary values, and concurrent
access are where bugs live. Don't just test the success case.

**Keep tests independent.** Tests must not share mutable state. Each test should be
able to run in isolation, in any order.

**Avoid testing library code.** Don't write tests that really just verify that a
third-party library works. Test your code's behavior.

## What Good Coverage Looks Like

Before writing, ask: *what could go wrong here?* Then cover:
1. The happy path (one test is enough)
2. Invalid/missing inputs
3. Boundary conditions (empty, zero, max)
4. Error states (db down, network failure, etc.)
5. Concurrent/race scenarios where applicable

Don't aim for 100% line coverage — aim for confidence that the code is correct.
