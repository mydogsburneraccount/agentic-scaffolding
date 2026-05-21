# Instruction Authoring Reference

Methodology for generating and maintaining `.instructions.md` files and `copilot-instructions.md`.

---

## Generation Methodology

Use this when analyzing a codebase and producing per-module `.instructions.md` files.

### Hard Constraints

- DO NOT invent conventions. Extract them from actual code. If a pattern appears in 1 of 8 files, it's not a convention — it's an anomaly.
- DO NOT claim domain understanding from structural analysis alone. Tag every finding with confidence level.
- DO NOT generate instruction files for modules with fewer than ~3 files or no meaningful patterns to document.
- DO NOT skip the NEVER section. Every instruction file needs explicit anti-patterns — these are the highest-value lines because they prevent the most common agent mistakes.
- DO NOT produce generic instructions that could apply to any project. The whole point is project-specific knowledge.
- DO mark gaps with `<!-- TODO: [specific question] -->` rather than guessing at domain intent.
- DO cite real file paths, symbol names, and line ranges — not synthesized examples.

### Stage 1 — Discover Module Boundaries

Map the project's architectural layers by scanning directory structure, decorators, base classes, and naming patterns.

**If CodeGraphContext (CGC) is available**: Use CGC call chains and dependency analysis to identify module boundaries, importers/exporters, and architectural layers.

**If CGC is not available**: Fall back to directory listing, grep for decorators (`@router`, `@app`, `@error_handler`, `class.*Service`, `class.*Client`, `class.*Adapter`), and import graph tracing via file reads.

For each identified module, determine:
- Directory path and `applyTo` glob pattern
- Architectural role (router, service, adapter, client, model, test layer, etc.)
- Approximate file count and complexity
- Dependencies on other modules

**Output**: List of bounded modules with their paths, roles, and `applyTo` globs. Skip modules too thin to warrant their own instruction file.

### Stage 2 — Build Business Context

Gather domain knowledge from available sources, in priority order:

| Priority | Source | Confidence | What to extract |
|----------|--------|------------|-----------------|
| 1 | Code implementation | High | Actual behavior, not intended behavior |
| 2 | CGC structural analysis | High | Call paths, dependency trees, seam identification |
| 3 | README and in-repo docs | Medium | Domain terminology, architecture overview |
| 4 | OpenAPI specs / schema files | High | External contracts, endpoint groupings |
| 5 | Test fixtures and E2E scenarios | Medium | What the team thinks matters |
| 6 | Your wiki pages (via `wiki-access` skill) | Medium | Business context, may lag current code |

**Output**: Business context summary with sourced claims and confidence markers.

### Stage 3 — Trace Architectural Seams

For each module, trace:
- **Call chains**: How does a request flow through this module?
- **Dependency injection**: What gets injected and how?
- **Mocking seams**: Where would a test mock to isolate this module?
- **Error propagation**: How do errors flow through this module?

Use CGC for call chain and dependency analysis when available. Fall back to grep + file reading.

**Output**: Per-module dependency map with injection patterns and mocking boundaries.

### Stage 4 — Extract Conventions and Patterns

For each module, scan for recurring patterns:
- **Decorators and their configurations** — what decorators are consistently applied?
- **Exception handling patterns** — per-module or shared?
- **Response/return patterns** — status codes, headers, response model usage
- **Validation rules** — where does validation happen?
- **Test patterns** — fixture scopes, markers, parametrize usage, mock strategies
- **Naming conventions** — file naming, class naming, method naming

Verify each pattern is actually a convention (appears consistently) rather than a one-off.

**Output**: Per-module pattern catalog with example citations.

### Stage 5 — Present Findings and Interview

Present a structured summary organized by module, then ask ONE round of targeted questions via `vscode_askQuestions`. Questions must be grounded in specific findings:

Good: "Error handling differs between ServiceA and ServiceB — intentional or drift?"
Bad: "What does your app do?" (you should know this from Stages 1-4)

Accept partial answers. Mark gaps with TODO comments instead of blocking.

### Stage 6 — Generate Instruction Files

For each module, generate an `.instructions.md` file:

```markdown
---
applyTo: "path/to/module/**"
---

# Module Name — Role Summary (one line)

One-sentence description of what this module does and its key constraint.

## Patterns

- Pattern 1 with `code citations` and concrete details
- Pattern 2...

## [Domain-Specific Section]

Only include sections that earn their keep for this specific module.

## NEVER

- Anti-pattern 1 — why it's wrong and what to do instead
- Anti-pattern 2...
```

Key rules:
- Use real file paths, symbol names, and patterns from the actual codebase
- Keep each file concise — what a senior engineer would tell a new teammate in 5 minutes
- NEVER section should contain things agents actually get wrong, not theoretical risks
- Project-wide patterns belong in `copilot-instructions.md`, not per-module files

### Stage 7 — Validate and Write

Before writing each file:
- Verify the `applyTo` glob matches real paths
- Verify all cited files and symbols exist
- Spot-check at least 2 files per pattern claim
- Mark remaining gaps with `<!-- TODO: [specific question] -->`

Write all files to `.github/instructions/`. Produce a summary report with file table, open TODOs, and intentionally skipped areas.

### Generation Anti-Patterns

- ❌ "Follow best practices" — useless. Be specific to THIS project.
- ❌ Documenting what a framework does generically — document how THIS project uses it.
- ❌ One massive instruction file for the whole project — use per-module files with `applyTo`.
- ❌ Listing every file in a module — focus on patterns, conventions, and gotchas.
- ❌ Treating tests as ground truth for conventions — cross-reference against implementation.
- ❌ Skipping the interview — ~40% of instruction value requires human judgment.
- ❌ Generating files for utility modules or `__init__.py` that have no meaningful patterns.

---

## Improvement Methodology

Use this when maintaining `copilot-instructions.md` from workstream learnings or drift audits.

### Critical Rules

- This file affects ALL future agent sessions — every addition must be worth the cognitive load
- NEVER add environment-specific workarounds (transient tool issues)
- NEVER duplicate content from `.prompt.md` files
- NEVER add task-specific recipes that belong in a prompt file
- PRESERVE existing voice and style
- Keep the file under 500 lines

### Pattern Taxonomy

| Category | What to look for | Destination |
|----------|-----------------|-------------|
| **Missing behavioral directive** | Agent did something instructions should have prevented, across ALL tasks | BEHAVIORAL DIRECTIVES |
| **Missing tool guidance** | Agent used a tool incorrectly or missed an available tool | Tool Preference tables |
| **Missing workflow recipe** | Agent followed a reusable multi-step pattern not documented | WORKFLOW RECIPES |
| **Stale reference** | Instructions reference something that no longer exists | ENVIRONMENT |
| **Missing anti-pattern** | Agent made a mistake that should be prevented in ALL future sessions | ANTI-PATTERNS |
| **Communication gap** | Agent's tone/style drifted from instructions' intent | COMMUNICATION |

### The Global-Behavior Test

For EACH potential lesson: **"Would this improve agent behavior across ALL task types — not just the one in this session?"**

- ✅ "Always grep for conflict markers after file edits" → global
- ❌ "When merging, check for convergent changes" → task-specific, belongs in `mergeMain.prompt.md`

If it fails the global test, route it to the relevant `.prompt.md` instead.

### Audit Sections

**Environment**: Verify stack summary, build commands, customization paths, secrets path.

**Behavioral Directives**: Check primitive-selection guidance, verification expectations, memory use directives.

**Code Style / Communication / Anti-Patterns**: Check for stale references, missing globally-applicable anti-patterns, drift from intended behavior.

### Drift Report Format

```
## Audit Results

### Accurate ✓
- <item>: matches project state

### Stale / Inaccurate ✗
- <item>: instructions say X, reality is Y
  **Fix**: <what to change>

### Missing (should be documented)
- <item>: exists in project but not in instructions

### Orphaned (should be removed)
- <item>: documented but no longer exists
```

### Improvement Anti-Patterns

- ❌ Turning this into a rewrite — you're a maintainer, not an author
- ❌ Adding lessons that only apply to one specific workflow
- ❌ Adding "nice to have" documentation when the file is already long
- ❌ Changing the COMMUNICATION table tone
- ❌ Adding generic software engineering advice
- ❌ Removing anti-patterns that weren't violated — they may be preventing unseen errors
- ❌ Auditing things you can't verify — say "unable to verify" instead
- ❌ Adding environment workarounds
