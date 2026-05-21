---
description: "Use when creating, reviewing, or normalizing custom agents. Defines shared governance rules, naming conventions, tool restrictions, and quality gates for .agent.md files."
---

# Custom Agent Governance

Use these rules when creating, reviewing, or normalizing custom agents. Treat this file as the personal default for agent standards across workspaces.

Use it to shape new agents before scaffolding, normalize `/create-agent` output after generation, and reject drift during review. If the active workspace provides its own agent governance or roster, follow the workspace-local guidance first and use this file as the fallback default.

## File and Naming Conventions

- Path: workspace `.github/agents/<Name>.agent.md` or user profile `~/.copilot/agents/<Name>.agent.md`
- Filename and `name` should match exactly
- `description` must start with strong trigger phrasing such as `Use when...`
- Names should be role nouns, not vague adjectives
- One file per role; do not combine multiple specialties in one agent

## Frontmatter Standard

Required:
- `name`
- `description`

Recommended:
- `tools`
- `argument-hint`
- `user-invocable`

Optional with caution:
- `model`
- `agents`
- `handoffs`
- `disable-model-invocation`

Defaults:
- specialist subagents should use `user-invocable: false`
- omit `agents` unless nested delegation must be restricted
- omit `model` unless there is a verified reason to force one

## Tool Policy

- Minimal tools by default
- Start specialists with `read` and `search`
- Add `web` only for agents that genuinely need outside research
- Agents with `web` access must explicitly forbid sending proprietary code, secrets, internal endpoints, unpublished architecture details, or other sensitive internal data into outside research prompts
- Avoid terminal or edit tools in the first version unless the workflow clearly requires them
- More tools require more justification in review

## Body Structure Standard

Every `.agent.md` body should follow this order:
1. Role statement
2. Constraints
3. Approach
4. Output Format
5. Anti-patterns

Keep each section short and operational. Do not repeat generic workspace rules unless the repetition is necessary for the role.

## Unified Return Schema

All specialist agents return these headings in this exact order:
- `## Summary`
- `## Findings`
- `## Risks / Unknowns`
- `## Next Best Step`

Allowed agent-specific `Findings` subsections:
- `TestPlanner` → `Test Matrix`
- `CodeMaintainer` → `Semantic Alignment`, `Clarity / Readability Issues`, `Maintainability / Structure Issues`, `Naming / Local DRY / Cleanup Judgment`, `Bounded Hardening Recommendations`
- `E2EDiagnoser` → `Classification`, `Evidence Trail`, `Likely Fault Domain`
- `ConflictAnalyst` → `Conflict Set`, `Intent Comparison`, `Resolution Recommendation`, `Escalation Triggers`
- `AdversarialReviewer` → `Critical Risks`, `Design Smells`, `Clarity Issues`, `Hardening Recommendations`
- `SemanticCleanupReviewer` → `Naming Issues`, `Literal / Constant Opportunities`, `Duplication / Local DRY Opportunities`, `Over-Abstraction Risks`
- `ChangeScribe` → `Verified Inputs`, `Draft Package`, `Escalation Triggers`
- `InstructionMaintainer` → `Drift / Inaccuracy`, `Scoping Problems`, `Bloat Risks`, `Recommended Changes`
- `ConsensusScout` → `Ranked Strategies`, `Source Quality`, `Consensus vs Disagreement`, `Repo Fit`

## Evidence Standard

Support important claims with concrete evidence: file paths, symbols, URLs, observed output, or explicit reasoning grounded in source material. Use confidence labels (`High`, `Medium`, `Low`) when judgment is involved. Do not present weak blog opinion as strong evidence.

For outside research, prefer abstracted strategy questions over repo-specific prompt dumps, and include only the minimum repo context needed to evaluate fit.

## Question-First Routing and Reviewer Precedence

Use **one primary specialist per unresolved question by default**. Add a secondary reviewer only when it answers a **different unresolved question** that the primary specialist does not own.

When a request is ambiguous, the orchestrator should first classify the **primary unresolved question** before delegating. If the user does not provide that question explicitly, the orchestrator should infer it, state which question it selected, and route accordingly.

| Primary unresolved question | Primary reviewer / primitive | Secondary reviewer allowed when... |
|---|---|---|
| Customization scope, drift, apply-to blast radius, agent/prompt/instruction/reference correctness | `InstructionMaintainer` | `AdversarialReviewer` only after a concrete proposal or diff exists and the unresolved question is hidden risk or overlap hardening |
| Code quality, clarity, readability, maintainability, naming, local DRY, abstraction judgment, and bounded cleanup on any supplied code artifact, including test code and test-support libraries | `CodeMaintainer` | `TestPlanner` only when the unresolved question is whether the tests prove the intended behavior or whether different scenarios, levels, or fixture/mock strategy are needed; `AdversarialReviewer` only when the unresolved question is systemic design / proposal hardening beyond local code review |
| Test proof model: what should be tested, whether existing tests adequately prove intended behavior, which test levels or scenarios earn their keep, and whether fixture/mock strategy matches the business logic and repo conventions | `TestPlanner` | `CodeMaintainer` only when code-quality or maintainability questions remain unresolved in the supplied test code |
| Cleanup-only judgment: whether a supplied file or diff should get bounded naming, constant, DRY, or over-abstraction cleanup without widening into broader code review | `SemanticCleanupReviewer` | `CodeMaintainer` only when broader code-quality questions remain unresolved |
| Plans, designs, proposals, and unresolved systemic hardening questions | `AdversarialReviewer` | `ConsensusScout` only when outside evidence is genuinely needed; `InstructionMaintainer` only when the artifact is a customization design |
| Generic repo discovery, ownership discovery, or pattern scouting | `Explore` | None by default |

If a request such as `review this test diff` or `look at this helper` does not clearly identify the unresolved question, the orchestrator should classify it using this order:

1. If the main concern is **code quality / readability / maintainability / cleanup judgment**, route to `CodeMaintainer`.
2. If the main concern is **whether the tests actually prove the intended behavior**, route to `TestPlanner`.
3. If the main concern is **plan/design/proposal risk or systemic hardening**, route to `AdversarialReviewer`.
4. If the artifact is a customization file, route to `InstructionMaintainer` regardless of filename ambiguity.
5. If the question is still ambiguous after minimal context gathering, say which default was selected and why before delegating.

Examples:
- `tests/e2e/common/assertions.py` with the question "is this helper code clear and maintainable?" → `CodeMaintainer`
- `tests/e2e/common/unit_tests/test_payloads.py` with the question "do these tests actually prove the payload behavior we care about?" → `TestPlanner`
- `api/app.py` with the question "is this implementation readable and locally maintainable?" → `CodeMaintainer`
- `api/app.py` with the question "does this setup introduce systemic hardening or operational risk?" → `AdversarialReviewer`

When a request contains multiple unresolved questions, split the review by question rather than forcing one specialist to cover everything. The orchestrator should:

1. identify the distinct unresolved questions,
2. assign one primary specialist per question,
3. avoid sending overlapping scopes to multiple specialists,
4. synthesize the outputs before acting or reporting back.

Do not use a single reviewer as the default owner of a heterogeneous diff when the real questions fall into different specialist lanes.

User-facing orchestration prompts that synthesize reviewer output must describe the result as a **scoped verdict** and name any intentionally excluded dimensions. For v1 of the `codeReview` workflow, security review is explicitly out of scope unless a separate security-specific lane is added later.

## Scope Boundaries and Anti-Patterns

Do not create:
- Swiss-army agents that try to do everything
- agents with overlapping scopes and no crisp trigger boundary
- circular delegation chains
- vague descriptions that do not help discovery
- output formats that drift from the unified schema
- generic research clones of `Explore`
- consensus agents that treat agreement as unanimity or flatten all sources into one evidence tier

## Creation Workflow

1. Define the role contract first
2. Scaffold with `/create-agent`
3. Normalize the result against this standard
4. Check overlap against existing agents, workspace rosters, and `Explore`
5. Validate tool minimization and output schema compliance
6. Only then accept the agent into the roster

## Review Checklist

Before merging a new or updated agent, verify:
- primary unresolved question identified?
- distinct role?
- clear invoke / do-not-invoke boundary?
- minimal tools?
- parseable output?
- evidence expectations clear?
- overlaps with `Explore` or another specialist?
- would this be better as a prompt or reference asset instead?

## Change Control

When a new cross-agent rule is introduced, update this file first or in the same change. Do not allow individual agent files to silently invent new standards.
