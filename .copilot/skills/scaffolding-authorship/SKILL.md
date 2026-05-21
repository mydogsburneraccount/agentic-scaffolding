---
name: scaffolding-authorship
description: "Use when creating, improving, or maintaining scaffolding artifacts (.instructions.md, .prompt.md, .agent.md files) — provides reusable methodology for instruction generation, prompt improvement, and agent design."
argument-hint: "Describe the scaffolding task: 'generate instructions for my project', 'improve this prompt', 'design an agent for X', 'create a prompt for Y'"
user-invocable: true
disable-model-invocation: false
---

# Scaffolding Authorship

Reusable methodology for creating and maintaining Copilot customization artifacts. This skill provides the taxonomies, evidence standards, and anti-patterns that agents need when working on `.instructions.md`, `.prompt.md`, or `.agent.md` files.

## Choose One Primary Lane

- **Generate project instructions** — analyze a codebase and produce per-module `.instructions.md` files
- **Improve instructions** — maintain `copilot-instructions.md` from workstream learnings and drift checks
- **Improve a prompt** — improve a `.prompt.md` file from evidence (workstream, review, or cross-pollination)
- **Design a new agent** — decide if an idea should be an agent, draft the contract, prepare `/create-agent` handoff
- **Create a new prompt** — scaffold a new `.prompt.md` file with correct lane placement and conventions

## Shared Standards

These apply across all lanes:

### Evidence Requirements

Every proposed change must cite:
1. **What happened / what you found** — the specific moment, finding, or gap
2. **What the artifact said (or didn't)** — the gap in the current state
3. **What to change** — exact text, section, and placement

Reject any proposal that doesn't meet all three. "This seems useful" is not evidence.

### Anti-Bloat Gates

- Would a competent senior engineer already know this? → Skip
- Is this already implied by existing content? → Maybe emphasize, don't duplicate
- Does this add a paragraph where a bullet point works? → Compress
- Is the artifact already long? → Something must go to make room
- Does the new content match the density of surrounding content? → Match it

### Confidence Markers

Tag findings with confidence level when judgment is involved:
- **High** — verified against actual code, file paths, or tool output
- **Medium** — inferred from patterns or partial evidence
- **Low** — plausible but unverified

### The Prompt-vs-Instruction-vs-Skill Boundary

- **Prompt** = user-invoked end-to-end workflow with intake, steps, and output contract
- **Instruction** = always-on cross-cutting behavioral rule that applies globally
- **Skill** = reusable procedures, taxonomies, and methodology that agents load when tasks match
- **Agent** = specialist subagent that the main agent delegates to for bounded expert consultation
- **Reference** = durable static knowledge loaded only when explicitly referenced

If content only applies to one workflow → it belongs in a prompt. If it applies across all sessions → instruction. If it's reusable methodology → skill. If it's a bounded specialist role → agent.

## Lane Details

### Lane 1: Generate Project Instructions

Full methodology in [references/instruction-authoring.md](references/instruction-authoring.md), section "Generation Methodology."

**Summary**: 7-stage workflow — discover module boundaries → build business context → trace architectural seams → extract conventions → interview the user → generate instruction files → validate and write. Each generated file uses `applyTo` scoping and follows a proven structure (patterns, domain context, NEVER section).

**When to use**: User wants to analyze a codebase and produce `.instructions.md` files for the first time or for new/changed modules.

### Lane 2: Improve Instructions

Full methodology in [references/instruction-authoring.md](references/instruction-authoring.md), section "Improvement Methodology."

**Summary**: Two sequential modes — workstream mode (extract behavioral lessons from conversation history, apply the global-behavior test) then audit mode (drift-check environment, behavioral directives, code style, communication, anti-patterns against current project state). Changes must pass anti-bloat gates and the global-behavior test.

**When to use**: `copilot-instructions.md` needs maintenance — either from session learnings or periodic drift audit.

### Lane 3: Improve a Prompt

Full methodology in [references/prompt-authoring.md](references/prompt-authoring.md), section "Improvement Methodology."

**Summary**: Three modes — retrospective (extract lessons from a session that used the target prompt), review (cold analysis against project state), cross-pollination (transfer lessons from a session guided by a different prompt). Uses the friction taxonomy and architecture-fit check to classify findings and decide the right fix shape.

**When to use**: A `.prompt.md` file needs improvement based on evidence.

### Lane 4: Design a New Agent

Full methodology in [references/agent-design.md](references/agent-design.md).

**Summary**: 5-step workflow — read the existing system (governance + roster) → decide if the idea should really be an agent (routing table) → draft the minimum viable contract → optional specialist review → prepare `/create-agent` handoff package. Non-agent ideas get routed to the right primitive.

**When to use**: User has an idea for a new specialist and needs to determine if it should be an agent, then design the contract.

### Lane 5: Create a New Prompt

Full methodology in [references/prompt-authoring.md](references/prompt-authoring.md), section "Creation Methodology."

**Summary**: 5-step workflow — understand the request → discover context (read AGENTS.md, existing prompts, copilot-instructions.md) → ask up to 3 clarifying questions → construct the prompt file matching local conventions → save to the correct lane.

**When to use**: User needs a new `.prompt.md` file created from scratch.

## Anti-Patterns

- ❌ Inventing conventions instead of extracting them from actual code or existing artifacts
- ❌ Adding generic software engineering advice that any competent agent already knows
- ❌ Duplicating content across prompts, instructions, and skills — each layer has its job
- ❌ Restructuring working sections just because you'd write them differently
- ❌ Adding speculative improvements without evidence from a workstream, project scan, or review
- ❌ Creating a new agent when a prompt, instruction, or reference asset is the better fit
- ❌ Treating this skill as a static reference instead of a workflow — follow the lane's steps
- ❌ Bloating artifacts past their natural density — prompts are instructions, not documentation
