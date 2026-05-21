---
name: recipes
description: "Use when you want a repeatable front door for testing and debugging work: understanding a module, writing router/Kafka/database tests, debugging failures, raising coverage, or reviewing testability."
argument-hint: "Describe the test or debug task and include anchors like a file path, endpoint, symbol, or failing test"
user-invocable: true
disable-model-invocation: true
---

# Recipes

Use this skill as a reusable testing and debugging workflow. It replaces the old `/recipes` prompt without losing the lane selection and execution brief that made that prompt useful.

## Choose One Primary Lane

- understand a new module
- write tests for a REST or router endpoint
- write tests for a Kafka consumer or producer path
- write tests for database or repository behavior
- debug a failing test
- increase coverage
- review code for testability

## Intake

Gather only the anchors that materially change the workflow:

- target file, symbol, endpoint, module, adapter, or test suite
- failing test name and error output
- coverage target or uncovered file
- whether the user wants tests written, diagnosis only, or review-only feedback

## Workflow

1. Choose one primary lane and say which one you are using if it is not obvious.
2. Inspect existing project tests, fixtures, helpers, and repo conventions before inventing new patterns.
3. When the active workspace provides repo-local testing instructions, follow the most specific one that applies:
   - router or endpoint work → `.github/instructions/router-tests.instructions.md`
   - general tests → `.github/instructions/tests.instructions.md`
   - scoped test folders → the matching `.github/instructions/*.instructions.md`
4. Reuse existing project helpers, factories, mocks, dependency overrides, and fixtures before adding new ones.
5. Keep the implementation and validation loop tight: gather evidence, make the smallest justified change, and validate with the repo's standard test or lint flow.
6. If the best lane is still unclear after basic discovery, state the lane choice you are making and why.

## Lane-Specific Reminders

### Understand a New Module

- trace the production path first, then inspect existing tests
- identify seams, dependencies, and current test gaps
- summarize the most likely test levels before writing code

### Router or Endpoint Tests

- prefer existing TestClient and dependency override patterns
- assert response contracts and error paths, not just happy-path status codes
- keep service mocking aligned with existing router test patterns

### Kafka Tests

- identify whether the value is producer contract, consumer behavior, or handler orchestration
- mock integrations at the established repo seam
- test message shape, routing, and failure handling intentionally

### Database or Repository Tests

- decide whether the behavior needs integration-style proof or can be isolated
- use existing DB test setup and fixture patterns
- assert meaningful persistence behavior, not ORM trivia

### Debug a Failing Test

- start from the exact failure output and isolate the failing assumption
- verify whether the bug is in the test, fixture, or production code before editing
- prefer root-cause fixes over patching assertions until they stop screaming

### Increase Coverage

- target uncovered business behavior or branch risk, not easy filler lines
- prefer adding tests near existing suites unless a new file materially improves structure
- say what risk or branch the new coverage buys

### Review Testability

- identify hidden dependencies, brittle setup, or unclear seams
- recommend the smallest change that improves test proof or maintainability
- separate code-quality concerns from test-proof concerns

## Output

Report progress in a concise execution brief:

- chosen lane
- anchors used
- key repo evidence gathered
- work performed or next blocking question
- validation run or validation still needed

## Anti-Patterns

- treating this as a static reference instead of a workflow
- mixing multiple lanes when one primary lane will do
- inventing repo fixtures, tools, or helpers without verifying they exist
- writing tautological tests or low-value coverage filler
- ignoring more specific repo-local instructions when the workspace provides them
