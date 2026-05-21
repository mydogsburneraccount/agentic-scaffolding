# Agent Design Reference

Methodology for deciding whether an idea should become a custom agent and designing the contract.

---

## When to Use

User has an idea for a new specialist capability and needs to determine the right primitive type. If it's an agent, this methodology produces the minimum viable contract and a `/create-agent` handoff package.

## Critical Rules

- This workflow is AGENT-ONLY. Do not broaden into general customization design.
- Read `~/.copilot/instructions/agent-governance.instructions.md` FIRST for shared standards.
- Use `/create-agent` for scaffolding. Do not hand-write `.agent.md` files.
- Do not restate the whole agent standard — apply it and cite relevant parts.
- Do not create a new agent when an existing agent, `Explore`, a prompt, an instruction, or a reference is the better fit.
- Prefer the smallest asset set. Do not add extra references, reviewers, or companion workflows unless evidence justifies them.

## Step 1 — Read the Existing System

Read:
- `~/.copilot/instructions/agent-governance.instructions.md`
- Any workspace-local `AGENTS.md` or `.github/agents/AGENTS.md` that exists
- Relevant existing files in `.github/agents/`

Read only what's needed to classify overlap and contract shape.

## Step 2 — Decide: Agent or Not?

Use agent governance as the primary standards source. Use any workspace-local roster for overlap checks.

### Routing Table

| If the idea is really... | Route to |
|--------------------------|----------|
| Generic repo scouting | `Explore` subagent |
| User-invoked end-to-end workflow | Create a prompt (use the `scaffolding-authorship` skill, Lane 5) |
| Broad always-on guidance | Create an instruction file |
| Durable static knowledge | Create a reference asset |
| Minor extension of existing specialist | Extend the existing agent, don't create a new one |
| Bounded specialist with distinct trigger | **New agent** ✓ |

If the answer is NOT agent, stop and route clearly. Do not force an agent just because the user asked in agent-shaped words.

## Step 3 — Draft the Minimum Viable Contract

If the idea IS a good agent, draft:

- **Name** — descriptive, PascalCase
- **Use-when description** — the trigger condition (when should the main agent delegate to this?)
- **Minimal tools** — start with read + search only; justify additional tools
- **User-invocable recommendation** — usually false for specialist agents
- **Argument hint** — what input the agent expects
- **Role boundary** — what this agent does and does NOT do
- **Overlap check** — against existing agents and `Explore`
- **Minimal asset set** — for v1, usually just the `.agent.md` file

## Step 4 — Optional Review

If there's a distinct unresolved question, follow reviewer-precedence guidance from agent governance:
- `InstructionMaintainer` for drift / overlap / scope questions
- `AdversarialReviewer` for hidden risk / duplication / anti-pattern hardening (only after a concrete contract exists)

## Step 5 — Prepare `/create-agent` Handoff

Package for `/create-agent`:
- Agent name
- One-sentence trigger description
- Tools
- `user-invocable` recommendation
- Argument hint
- Exact role boundary
- Required findings subsections
- Overlap / do-not-invoke notes
- Deferred assets or follow-up reviews

This workflow ends at the handoff package. `/create-agent` does the scaffolding.

## Output Format

```
### Primitive Decision
- Agent or Not Agent
- 2-4 bullets explaining why

### Agent Fit Checklist
- Short checklist against agent-fit criteria

### Proposed Agent Contract (if Agent)
- Name, Description, Path, Tools, User-invocable, Argument hint
- Role boundary, Minimal asset set
- Governance checks for /create-agent normalization

### Better Fit (if Not Agent)
- Name the better primitive
- Explain why
- Point to the correct workflow or asset

### /create-agent Handoff Package (if Agent)
- Compact, copyable package

### Risks / Unknowns
- List ambiguity, overlap concerns, or missing evidence

### Next Best Step
- 1-3 bullets
```

## Agent Design Anti-Patterns

- ❌ Re-implementing `/create-agent` instead of feeding it
- ❌ Skipping review when the agent might duplicate an existing specialist
- ❌ Naming the role broadly but describing it narrowly (or vice versa)
- ❌ Creating an agent whose scope overlaps an existing specialist without a crisp trigger boundary
- ❌ Creating an agent for generic repo exploration that `Explore` already handles
- ❌ Copying standards from governance into this workflow instead of applying them
- ❌ Adding reference assets, tests, or companion workflows before the core role is proven
- ❌ Treating "the user asked for an agent" as sufficient evidence that a new agent is the right primitive
