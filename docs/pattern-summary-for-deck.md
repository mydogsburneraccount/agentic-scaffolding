# Agentic Scaffolding — Pattern Summary

A non-proprietary overview of the scaffolding system's architecture, layering strategy, and design philosophy. Use this as source material for presentations and deck-building.

---

## Core Philosophy

### What Works for Agents Is What Works for People

An agent joining your codebase faces the same problems a new team member does:
- Where do I start?
- What patterns does this project follow?
- What's the happy path? What's forbidden?
- Who owns what? How do I validate my work?

The difference: a person gets onboarding, a Slack channel, and three weeks of osmotic absorption. An agent gets whatever is written down — or nothing.

**Scaffolding is onboarding documentation that agents can actually consume.**

### Quality Agent Outputs Require Quality-Focused Humans

AI doesn't inherently know what "good" looks like. It needs:
- Clear success criteria (what does a correct output look like?)
- Boundary definitions (what must never happen?)
- Validation procedures (how do I prove my work is right?)
- Domain patterns (what does this team do vs. what's generic?)

These are exactly the skills that QA professionals spend their careers developing. QA professionals are uniquely positioned to define what "good" means for agents — because that's what they've always done for humans.

### AI Can't Replace You — It Needs You to Teach It

The scaffolding system exists because:
- An agent without instructions produces generic output that requires heavy human correction
- An agent with scaffolding produces context-aware output that aligns with team conventions
- The gap between the two IS the value a quality-focused human provides
- The scaffolding itself is a durable artifact that compounds over time

---

## Scaffolding File Taxonomy

### Instructions (`.instructions.md`)

**What they are:** Always-on behavioral rules that fire automatically when an agent is working in a matching file scope.

**When they fire:** Based on `applyTo` glob patterns. Edit a file in `tests/e2e/**` → the E2E instruction auto-loads.

**What they're for:**
- Defining conventions, patterns, and boundaries for a directory or file scope
- Establishing "NEVER do X" constraints that prevent common agent mistakes
- Codifying validation procedures ("run THIS command to prove your work")
- Encoding architectural knowledge that agents need when making changes

**Layering:**
- **User-level** (`~/.copilot/instructions/`): Cross-workspace behavioral defaults — working style, review discipline, tool usage policies
- **Project-level** (`.github/instructions/`): Directory-scoped rules for this specific codebase

**Example roles:**
- "This directory is a standalone test harness, not production code"
- "Always use make targets, never raw commands"
- "Services must use @error_handler on all public methods"
- "Before writing tests, trace the production code path first"

### Custom Agents (`.agent.md`)

**What they are:** Specialist subagents that the main orchestrator delegates to for focused, expert work.

**When they fire:** Invoked explicitly by the main agent (or user) when a task falls within the agent's domain.

**What they're for:**
- Providing domain-specific expertise without bloating the main agent's context
- Enforcing output format contracts (diagnosis reports, test plans, code reviews)
- Restricting tool access per role (read-only analysts vs. editing agents)
- Creating reviewable, attributable decision chains

**Design principles:**
- Minimal tool grants (start with read + search, add only what's needed)
- One role per agent — don't combine specialties
- Constraint-first body structure: what you MUST NOT do, then approach, then output format
- Non-invasive by default: specialist subagents should be `user-invocable: false`

**Example roles:**
- Test strategy planner (designs what to test, doesn't implement)
- Code quality reviewer (reviews supplied artifacts, doesn't rewrite)
- Failure diagnoser (traces root cause from symptoms, doesn't fix)
- Adversarial reviewer (stress-tests plans before implementation)
- Consensus scout (researches established practices when local context is insufficient)

### Prompts (`.prompt.md`)

**What they are:** Opt-in workflows triggered by name. They compose context (references, instructions, files) and define a multi-step procedure.

**When they fire:** User explicitly invokes them (e.g., `/diagnoseE2E <failure output>`).

**What they're for:**
- Encoding repeatable multi-step workflows that have a defined input → output contract
- Composing multiple references and reading orders into a single coherent task
- Defining the exact procedure, evidence standard, and output format for complex work
- Providing argument hints so the user knows what to supply

**Key difference from instructions:** Instructions are guardrails (always-on). Prompts are tools (opt-in).

**Example roles:**
- "Scaffold a new E2E test for process rule X" (reads adapters, builds payload, writes test)
- "Diagnose this test failure" (parses output, traces code, classifies root cause)
- "Draft a PR description from these changes" (reads diff, applies template, formats)
- "Generate an onboarding report for this codebase" (explores, maps, summarizes)

### Skills (`SKILL.md` + supporting files)

**What they are:** Self-contained knowledge packages with references, configs, and sometimes scripts. Loaded on-demand when the task matches the skill's domain.

**When they fire:** The agent reads the skill file when it recognizes the task falls in the skill's domain (via description matching).

**What they're for:**
- Packaging complex domain knowledge that's too large for an instruction file
- Bundling reference material (templates, schemas, API docs) alongside the behavioral guidance
- Encoding procedural knowledge for specific tools or integrations (e.g., JIRA field mappings, MCP server auth)
- Providing scripts or config files that the agent can reference or execute

**Structure:**
```
skills/
  my-skill/
    SKILL.md          ← entry point with description + instructions
    references/       ← supporting docs, templates, schemas
    config/           ← field mappings, defaults
    scripts/          ← automation helpers
```

**Example roles:**
- "How to create/update JIRA work items" (includes field mappings, payload templates, auth patterns)
- "How to author scaffolding files" (includes instruction/prompt/agent authoring guides)
- "How to use the code graph context" (includes query patterns, relationship analysis)

### References (`.reference.md`)

**What they are:** Stable factual context that prompts and instructions point to. Not behavioral — purely informational.

**When they fire:** Loaded by prompts that reference them, or read by agents when instructions point to them.

**What they're for:**
- Process-rule crosswalks, file maps, architecture diagrams
- Failure taxonomies, signal guides, propagation maps
- Templates (PR descriptions, communication formats)
- Stable context that multiple prompts need without duplicating

**Key difference from instructions:** References describe *what is*. Instructions describe *what to do*.

### Hooks (Chat hooks / `hooks/`)

**What they are:** Pre/post command hooks that intercept agent actions and enforce safety constraints.

**What they're for:**
- Blocking destructive commands (force-push, drop table, rm -rf)
- Preventing accidental commits of local-only files
- Enforcing review gates before shared-system mutations

---

## Layering Strategy

### Two-Tier Hierarchy

```
User-level (~/.copilot/)
  ├── instructions/     → Working style, review discipline, tool policies
  ├── agents/           → Reusable specialist subagents (role-based)
  └── skills/           → Complex domain knowledge packages

Project-level (.github/)
  ├── copilot-instructions.md  → Workspace identity + prime directives
  ├── instructions/            → Directory-scoped rules (applyTo patterns)
  ├── prompts/                 → Project-specific workflows
  └── references/              → Stable project facts for prompt consumption
```

### What goes where

| Concern | Level | Why |
|---|---|---|
| "Always use subagents for non-trivial work" | User | Applies everywhere |
| "Run make targets, never raw commands" | Project | Project-specific toolchain |
| "E2E tests are a standalone harness" | Project (scoped) | Applies only to `tests/e2e/**` |
| "How to review code quality" | User (agent) | Reusable across projects |
| "How to scaffold a domain flow test" | Project (prompt) | Domain-specific workflow |
| "Domain process rule crosswalk" | Project (reference) | Stable project facts |

### Scoping principle

Put guidance at the **narrowest applicable scope**:
- If it applies everywhere → user-level instruction
- If it applies to this project → `copilot-instructions.md`
- If it applies to one directory → scoped instruction with `applyTo`
- If it's a workflow → prompt
- If it's facts → reference

---

## The Orchestrator Pattern (Subagent/Quorum)

### Core Idea

The main chat agent is an **orchestrator**, not a solo executor. For non-trivial work:

1. Frame the problem and identify what expert lenses are needed
2. Delegate to specialist subagents with packaged context
3. Synthesize their outputs into a coherent result
4. Own the final decision and delivery

### When to orchestrate vs. stay local

**Stay local when:**
- Direct answer, lookup, or obvious single-file edit
- One bounded read answers the question
- Delegation adds more ceremony than signal

**Orchestrate when:**
- Task spans multiple concerns or ownership boundaries
- Unresolved questions benefit from different specialist lenses
- A deliverable needs review before the user sees it
- The work would benefit from adversarial stress-testing

### Review discipline

Every non-trivial deliverable gets a review pass through an appropriate specialist before delivery:

| Deliverable type | Reviewer |
|---|---|
| Code (production or test) | Code quality specialist |
| Test strategy | Test planning specialist |
| Plan or proposal | Adversarial reviewer |
| Instruction/scaffolding file | Instruction maintainer |

### Context packaging for subagents

Subagents don't inherit full context. Package each with:
- The exact question it owns
- The relevant files and constraints
- Expected output format
- What tools it should use

---

## The Two-Phase Discovery Workflow

### Problem

When writing tests for a live system (especially as an isolated tester), you need to understand:
1. What the feature is **supposed to do** (business intent)
2. What the code **actually does** (implementation reality)

Agents typically jump straight to code, miss the intent, and produce tests that verify implementation details rather than business behavior.

### Solution: Intent First, Then Implementation

**Phase 1 — Business Intent:**
- Read user stories, acceptance criteria, definition of done
- Read architecture docs, sequence diagrams, team decision records
- Read PR discussions and code review comments for design choices
- Build the mental model of *what should happen*

**Phase 2 — Implementation Trace:**
- Identify the entry point (route, endpoint, event handler)
- Trace through the business logic layers (service → adapter → client)
- Identify valid inputs, state transitions, and terminal states
- Map error paths and edge cases

**Why this order matters:**
- Phase 1 tells you what *should* happen
- Phase 2 tells you what *does* happen
- The test proves they match
- When they don't match → you've found a bug or an undocumented change

### Application to QA work

This is the exact workflow a quality engineer uses with or without AI:
1. Understand requirements
2. Understand implementation
3. Design tests that verify the gap between them is zero

The scaffolding encodes this workflow so agents follow it naturally instead of skipping step 1.

---

## Demonstration Talking Points

### The Before/After Gap

Give two agents the same task ("write an E2E test for flow X") in the same codebase:
- **Without scaffolding:** Agent guesses at patterns, uses wrong helpers, skips validation, produces a test that may not even run
- **With scaffolding:** Agent reads the business context first, traces the production code, uses established helpers, validates by execution, produces a test that follows team conventions

The delta between these two outputs IS the value of scaffolding — and of the human who wrote it.

### Key demo beats

1. Show the agent reading the scoped instruction automatically when it touches a file
2. Show the two-phase workflow in action (intent discovery → code trace → test)
3. Show the subagent review pattern catching an issue the main agent missed
4. Show the NEVER constraints preventing a common mistake
5. Compare the final output quality

### The QA angle

- "What works for agents is what works for people"
- Scaffolding IS quality engineering applied to AI workflows
- The person who defines "good" controls the output quality ceiling
- AI amplifies the quality bar you set — it doesn't set one for you

---

## File Inventory (Bootstrap Repo)

```
.copilot/
  agents/          — 9 specialist subagents
  instructions/    — 6 behavioral rule files
  skills/          — 3 knowledge packages (scaffolding-authorship, code-graph-context, wiki-access)

prompts/           — 17 workflow prompts + AGENTS.md routing index
  references/      — 4 reference files consumed by prompts

hooks/             — 1 destructive-command blocker + script

examples/          — Template files for new project onboarding
docs/              — This pattern summary
```
