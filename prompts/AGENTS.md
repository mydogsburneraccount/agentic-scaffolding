# Prompt Files — Agent Reference

> This directory contains reusable `/command` prompts for VS Code Copilot Chat agent sessions. If you're an agent working in this directory, read this first.

## How It Works

- Prompt files are `*.prompt.md` files loaded via `.vscode/settings.json` → `chat.promptFilesLocations`
- Users invoke them with `/filename` in chat (e.g., `/mergeMain`)
- Each file is a standalone instruction set — the agent receives it as the system prompt for that interaction
- Global behavioral rules live in `.github/copilot-instructions.md` — prompt files handle **task-specific** workflows

## Customization Lanes

This setup now uses multiple customization lanes on purpose:

- `.github/prompts/` = repo-local prompts for this project only
- `~/Library/Application Support/Code/User/prompts/` = user-level prompt files available across workspaces
- `~/.copilot/instructions/`, `~/.copilot/agents/`, and `~/.copilot/skills/` = user-level instructions, agents, and skills

If you're not sure whether the current workspace is fully wired, read `.github/references/workspace-bootstrap.reference.md` first (this file is created by `/onboardProject` in the target project, not in the scaffolding repo itself).

## Conventions

| Rule | Detail |
|------|--------|
| **Naming** | `camelCase.prompt.md` — the filename (minus extension) becomes the `/command` |
| **Scope** | Each prompt handles ONE workflow end-to-end. Don't combine unrelated tasks; bounded specialist delegation is fine when the prompt still owns evidence gathering, decisions, and final output. |
| **Structure** | Frontmatter with `description:` → sections for context, steps, anti-patterns |
| **Voice** | Match the project's direct tone (see `references/communication-preferences.md` for reference) |
| **No duplication** | Don't repeat rules from `copilot-instructions.md` — those are always active |
| **Self-contained** | A prompt should work without the user providing extra context (agent gathers it) |

Default intake and orchestration behavior that should apply across tasks belongs in `.github/copilot-instructions.md`; prompts should add only workflow-specific mechanics, constraints, or output contracts.

## Creating New Prompts

Use the `scaffolding-authorship` skill (Lane 5: Create a New Prompt) — it'll guide you through intent, scope, and structure, then scaffold the file. You can invoke it directly via `/scaffolding-authorship create a prompt for X` or agents will auto-load it when the task matches.

## Creating New Agents

Use the `scaffolding-authorship` skill (Lane 4: Design a New Agent) — it decides whether the idea should really become a custom agent, drafts the minimum agent contract, and prepares a handoff package for built-in `/create-agent`. You can invoke it via `/scaffolding-authorship design an agent for X`. Shared agent standards live in `~/.copilot/instructions/agent-governance.instructions.md`; workspace-local agent rosters, when present, can still add repo-specific routing.

## Improving Existing Prompts

Use `/improvePrompt` — it reviews a prompt file, extracts lessons from the current session, and proposes targeted edits. Uses the `scaffolding-authorship` skill for friction taxonomy and evidence standards.

## Archive Safety

- Treat existing files in `personal/` as potentially historical artifacts unless the user explicitly says to update that exact file.
- Archive deprecated prompts outside the active user prompt folder (for example `personal/archive/prompts/`) so they are preserved for review without remaining active slash commands.
- When saving a new PR description draft under `personal/`, prefer a new feature-specific filename (for example `pr-<topic>.md`) instead of overwriting a generic or older draft file.

## PR Description Conventions

- The PR-description checklist block is standardized across PRs. Keep the three checklist item labels/commands exactly as defined in `references/prDescriptionTemplate.reference.md` (installed to `.github/references/` in onboarded projects).
- Do not invent PR-specific checklist bullets. Only the checkbox state may change, and only when backed by verified evidence.

## Current Catalog

Repo-local prompts also exist in `.github/prompts/` in onboarded projects.
For a live example, a service-under-test repo can host repo-local prompts like `/diagnoseE2E` and `/e2eFlowTest`.
The table below is the current user-level prompt catalog in `~/Library/Application Support/Code/User/prompts/`.

| Command | File | Purpose |
|---------|------|---------|
| `/auditConfigComplexity` | `auditConfigComplexity.prompt.md` | Audit configuration for unnecessary complexity, dead code, and over-engineering |
| `/auditPRDescription` | `auditPRDescription.prompt.md` | Verify every claim in a PR description against the actual diff and code state |
| `/codeReview` | `codeReview.prompt.md` | Orchestrate a bounded pre-human-review quality pass on a concrete code change |
| `/changeReport` | `changeReport.prompt.md` | Report on changes against upstream with suggested commit message |
| `/draftPRDescription` | `draftPRDescription.prompt.md` | Draft a PR description from scratch from the actual diff using the shared PR-description reference |
| `/handoff` | `handoff.prompt.md` | Structured agent shutdown — dump state to memory before archiving |
| `/discoverBusinessLogic` | `discoverBusinessLogic.prompt.md` | Use your corporate MCP-assisted story/wiki intake plus codebase evidence to derive business rules, domain flows, and E2E test scenario candidates |
| `/generateProjectInstructions` | `generateProjectInstructions.prompt.md` | Analyze codebase and generate per-module `.instructions.md` files with `applyTo` scoping (uses `scaffolding-authorship` skill) |
| `/recommendScaffolding` | `recommendScaffolding.prompt.md` | Assess a project and recommend which scaffolding tools to adopt, plus identify project-specific gaps |
| `/improveInstructions` | `improveInstructions.prompt.md` | Maintain `copilot-instructions.md` from workstream learnings and targeted drift checks (uses `scaffolding-authorship` skill) |
| `/improvePrompt` | `improvePrompt.prompt.md` | Improve a prompt file from workstream learnings, direct review, or fit/overlap analysis (uses `scaffolding-authorship` skill) |
| `/mergeMain` | `mergeMain.prompt.md` | Merge/rebase from main with intelligent conflict resolution and safe post-rewrite push guidance |
| `/toolCheck` | `toolCheck.prompt.md` | Verify baseline agent tools and configured MCP servers are accessible |
| `/prFeedbackReport` | `prFeedbackReport.prompt.md` | Fetch, investigate, and report on PR review comments |
| `/onboardProject` | `onboardProject.prompt.md` | Onboard this scaffolding bundle to a target repo: inspect, fill templates, wire tooling |
| `/generateOnboardingReport` | `generateOnboardingReport.prompt.md` | Generate structured post-onboarding analysis |
| `/evaluateOnboardingReport` | `evaluateOnboardingReport.prompt.md` | Evaluate an onboarding report against a rubric |
| `/test` | `test.prompt.md` | Dummy prompt to verify prompt loading works |

`/recipes` is now provided by the `recipes` skill in `~/.copilot/skills/recipes/`, not by a prompt file.

## Supporting Files

| File | Purpose |
|------|---------|
| `references/communication-preferences.md` | Communication preferences reference — how I communicate and how I want the agent to communicate with me |
| `references/prDescriptionTemplate.reference.md` | Shared PR description structure/example for drafting and auditing prompts |
| `references/mcp-setup.reference.md` | MCP server inventory, setup steps, and troubleshooting |
| `~/.copilot/instructions/agent-governance.instructions.md` | Shared governance for agent standards, schema, findings taxonomy, and reviewer precedence |
| `~/.copilot/instructions/code-quality.instructions.md` | Shared code-quality rubric used by review orchestration and future reviewer agents |
| `~/.copilot/instructions/quorum-pattern.instructions.md` | Deeper playbook for quorum-style lane design, context packaging, convergence, and execution-brief synthesis |
| `AGENTS.md` | This file |

> **Note**: `/onboardProject` copies `references/prDescriptionTemplate.reference.md` to `.github/references/` in the target project and creates `.github/references/workspace-bootstrap.reference.md` there. Those paths are target-project artifacts, not files in this scaffolding repo.
