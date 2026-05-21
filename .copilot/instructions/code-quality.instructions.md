---
description: "Use when reviewing code quality of production or test code. Defines cross-cutting principles for readability, correctness, security, and maintainability."
---

# Code Quality

Use these rules when reviewing the quality of supplied production or test code. Apply them as working instructions rather than background reading. They do **not** replace test-proof review; questions about whether tests adequately prove the intended behavior still belong to `TestPlanner`.

## Cross-Cutting Principles

- Prefer clarity over cleverness.
- Preserve local readability before introducing helpers, constants, or abstraction.
- Make names, control flow, and surrounding comments tell the same story.
- Keep recommendations evidence-based and scoped to the supplied artifact.
- Prefer leaving code alone when the proposed cleanup adds indirection without earned payoff.

## Semantic Alignment

Look for places where:
- names do not match actual behavior,
- comments or docstrings drift from implementation,
- return values or control flow contradict surrounding expectations,
- type usage is looser or stranger than the local contract suggests.

## Readability and Structure

Look for local issues such as:
- branching that obscures the main path,
- deeply nested logic that could be clarified,
- inconsistent local patterns compared with nearby code,
- comments that compensate for confusing code rather than clarifying intent.

Prefer the smallest improvement that makes the code easier to understand.

## Naming, Local DRY, and Cleanup Judgment

Use naming and DRY recommendations only when they improve local comprehension or change safety.

Good cleanup signals:
- repeated local logic that is genuinely noisy or brittle,
- misleading or asymmetric names,
- repeated literals that are reused enough to justify one source of truth.

Leave the code alone when:
- duplication is clearer than the helper,
- a new constant would create a constants cemetery,
- abstraction would hide intent rather than clarify it.

## Abstraction Thresholds

Before recommending a helper, constant, or wrapper, check:
1. Does it improve readability where it is used?
2. Does it reduce real change risk?
3. Does it match nearby repo patterns?
4. Is the new indirection easier to understand than the repeated code?

If the answer is not clearly yes, prefer a bounded leave-it-alone judgment.

## Maintainability

Focus on local maintainability, not broad architecture critique.

High-signal issues include:
- brittle local structure,
- repeated branches that are hard to change safely,
- hidden assumptions inside a function or helper,
- type or model usage that weakens the local contract.

If the concern becomes systemic, proposal-level, or architectural, escalate to `AdversarialReviewer` instead of stretching a code-quality review beyond its lane.

## Test Code Notes

These same code-quality principles apply to:
- unit tests,
- E2E tests,
- test-support libraries,
- shared test helpers,
- harness utilities.

`CodeMaintainer` may review test code for clarity, maintainability, naming, and cleanup judgment.

Questions such as:
- do these tests prove the intended behavior,
- are the right scenarios covered,
- is this the right test level,
- does the fixture/mock strategy support the proof goal,

belong to `TestPlanner`, not this reference alone.
