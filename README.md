# Agentic Scaffolding

An introduction to encoding quality expertise as agent scaffolding.

This repo is a working example of the **agent-coordinator pattern**: agents, instructions, skills, prompts, and hooks that compose into a coordinated system for GitHub Copilot in VS Code. It accompanies a workshop series on agentic scaffolding.

## The Pattern

Every phase of work repeats the same two moves:

1. **Define quality** -- what does "good" look like for this phase?
2. **Put up guardrails** -- what enforcement ensures it?

Research, planning, execution, review. Same duality at every step. The scaffolding in this repo implements both halves.

| Phase | Quality (define it) | Guardrail (enforce it) |
|-------|--------------------|-----------------------|
| **Research** | ConsensusScout (agent) | Source-quality rules (instruction) |
| **Planning** | Code-quality principles (instruction) | AdversarialReviewer (agent) |
| **Execution** | Working-style constraints (instruction) | block-destructive hook (hook) |
| **Retrospective** | improveInstructions (prompt) | InstructionMaintainer (agent) |

## How the Pieces Fit Together

Agents are attitudes. Instruction files are substance. The separation makes both reusable.

**ConsensusScout** brings a research perspective and defers to `source-quality.instructions.md` for what counts as evidence. **AdversarialReviewer** brings an adversarial perspective and defers to `code-quality.instructions.md` for what "good" means. The instruction files route between agents: `code-quality.instructions.md` says "escalate to AdversarialReviewer" when concerns become systemic. The scaffolding coordinates itself. No boss agent needed.

## What's in Here

| Layer | Path | What it does |
|-------|------|--------------|
| **Agents** | `.copilot/agents/` | 9 specialist subagents the main Copilot agent delegates to |
| **Instructions** | `.copilot/instructions/` | Behavioral rules that auto-fire when you work in a project |
| **Skills** | `.copilot/skills/` | Reusable domain knowledge bundles |
| **Prompts** | `prompts/` | Slash commands for multi-step workflows |
| **Hooks** | `hooks/` | Deterministic enforcement -- the agent literally cannot do the thing you blocked |
| **Workshops** | `workshops/` | Presentation decks and companion materials from the training series |
| **Examples** | `examples/` | Templates for personal role, communication preferences, MCP config, VS Code settings |

## Prerequisites

- **VS Code** 1.99+ with the GitHub Copilot extension
- **GitHub Copilot plan**: Business or Enterprise (custom agents require these tiers; prompts and instructions work on any tier)
- **OS**: macOS, Linux, or Windows

## Setup

### Quick start

```bash
# Clone
git clone https://github.com/mydogsburneraccount/agentic-scaffolding.git
cd agentic-scaffolding

# Create user-level directories (first time only)
mkdir -p ~/.copilot/agents ~/.copilot/instructions ~/.copilot/skills

# Copy agents, instructions, and skills to your user profile
cp -r .copilot/agents/ ~/.copilot/agents/
cp -r .copilot/instructions/ ~/.copilot/instructions/
cp -r .copilot/skills/ ~/.copilot/skills/

# Copy prompts to VS Code user prompts folder (macOS)
cp -r prompts/ ~/Library/Application\ Support/Code/User/prompts/

# Linux alternative:
# cp -r prompts/ ~/.config/Code/User/prompts/

# Windows alternative:
# Copy prompts/ to %APPDATA%/Code/User/prompts/
```

### Configure VS Code

Add prompt discovery to your **project** workspace settings. In the project you want to use Copilot with, copy `examples/vscode-settings.json.example` to `.vscode/settings.json`, or merge the `chat.promptFilesLocations` setting into your existing settings. Alternatively, run `/onboardProject` from Copilot Chat and it will do this for you.

### Restart VS Code

After copying files, restart VS Code for Copilot to pick up the new agents, instructions, and prompts.

### Verify it works

1. Open any workspace in VS Code
2. Open Copilot Chat
3. Type `/test hello` -- if the prompt loads, you'll see "Prompt loaded successfully"
4. Check the Copilot settings gear icon -- your agents and instructions should appear in the "Local" tab

## How the Layers Work

```
+---------------------------------------------------+
|  User-level (this repo)                           |
|  ~/.copilot/agents/instructions/skills/           |
|  ~/Library/.../Code/User/prompts/                 |
|  Available in EVERY workspace                     |
+---------------------------------------------------+
|  Repo-level (.github/ in each project)            |
|  .github/copilot-instructions.md                  |
|  .github/instructions/ prompts/ references/       |
|  Available only in THAT repo                      |
+---------------------------------------------------+
|  VS Code built-in Copilot behavior                |
|  Model receives all layers merged into context    |
+---------------------------------------------------+
```

User-level scaffolding provides your portable quality standards. Repo-level scaffolding adds project-specific conventions. Both get injected into every Copilot chat session.

## Agent Roster

Agents are not invoked directly. The main Copilot agent delegates to them based on the routing rules in `agent-governance.instructions.md`.

| Agent | When it activates | Perspective |
|-------|------------------|-------------|
| `ConsensusScout` | Need expert consensus on an approach decision | Research specialist with source-quality rigor |
| `AdversarialReviewer` | Plan or design needs stress-testing | Challenges proposals for hidden assumptions |
| `CodeMaintainer` | Code artifact needs quality review | Readability, naming, DRY, maintainability |
| `TestPlanner` | Need test strategy or adequacy evaluation | Smallest strong proof model for a change |
| `ConflictAnalyst` | Merge/rebase has overlapping files | Stage-aware semantic conflict analysis |
| `E2EDiagnoser` | E2E test is failing or flaky | Evidence-based root cause tracing |
| `InstructionMaintainer` | Scaffolding may have drift or overlap | Quality-gates your scaffolding changes |
| `SemanticCleanupReviewer` | File needs naming/DRY cleanup only | Bounded cleanup without broader review |
| `ChangeScribe` | Need commit message or PR description | Drafts change documentation from evidence |

## Prompt Catalog

| Command | What it does |
|---------|-------------|
| `/onboardProject` | Analyze your project and suggest scaffolding |
| `/generateProjectInstructions` | Generate per-module instruction files from your codebase |
| `/recommendScaffolding` | Get recommendations for your workflow |
| `/codeReview` | Orchestrate pre-human-review quality pass |
| `/mergeMain` | Merge/rebase from main with conflict resolution |
| `/draftPRDescription` | Draft PR description from actual diff |
| `/improveInstructions` | Audit and improve your instruction files |
| `/improvePrompt` | Improve a prompt from workstream learnings |
| `/changeReport` | Report on changes with suggested commit message |
| `/auditPRDescription` | Verify every PR description claim against the diff |
| `/prFeedbackReport` | Investigate and report on PR review comments |
| `/discoverBusinessLogic` | Extract business rules and E2E scenario candidates |
| `/handoff` | Structured agent shutdown with state dump |
| `/toolCheck` | Verify all agent tools and MCP servers are accessible |
| `/mcpSetup` | MCP setup, safety checks, and troubleshooting |
| `/auditConfigComplexity` | Audit config for unnecessary complexity |
| `/test` | Verify prompt loading works |

## Hooks

Hooks are the one scaffolding type that gives you guarantees. Instructions guide. Hooks enforce.

This repo includes a working example:

| Hook | Event | What it does |
|------|-------|--------------|
| `block-destructive` | `PreToolUse` | Blocks dangerous terminal commands (`rm -rf /`, `git push --force`, `DROP TABLE`, etc.) before the agent can execute them |

```bash
# Install to your project
mkdir -p .github/hooks
cp hooks/block-destructive.json .github/hooks/
cp -r hooks/scripts/ .github/hooks/scripts/
chmod +x .github/hooks/scripts/block-destructive.sh
```

See the [VS Code hooks docs](https://code.visualstudio.com/docs/copilot/customization/hooks) for the full lifecycle event list. Use `/create-hook` in Copilot Chat to generate new hooks.

## Personalization

The scaffolding separates team-shared configuration from personal preferences:

**Team-shared** (committed to each project repo):
- `copilot-instructions.md` -- project facts, conventions, anti-patterns
- Per-module instruction files -- architecture, patterns, gotchas

**Personal** (user-level, not committed):
- `my-role.instructions.md` -- your role, focus areas, priorities
- `communication-preferences.instructions.md` -- how you want the agent to communicate

The `examples/` directory has annotated templates for all of these.

## MCP Servers (Optional)

MCP servers extend agent capabilities. All are optional.

| Server | What it adds | Privacy |
|--------|-------------|---------|
| **CodeGraphContext + Neo4j** | Structural code analysis (call chains, dependency trees) | Fully local |
| **context7** | Library documentation lookup (prevents API hallucination) | Sends library names only |

See `prompts/references/mcp-setup.reference.md` for setup details.

## Key Design Decisions

- **Agents are attitudes, instructions are substance.** Agents bring a perspective (research, adversarial review, cleanup). Instruction files bring the knowledge (what counts as evidence, what good code looks like). The separation makes both reusable.
- **Question-first routing**: agents are selected by the unresolved question, not by file path or artifact type.
- **Evidence-based everything**: agents must cite file paths, symbols, or observed output. Confidence markers are required when judgment is involved.
- **Anti-pattern sections**: every agent and prompt includes explicit anti-patterns to prevent known failure modes.
- **Minimal tools by default**: agents start with `read` and `search` only. More tools require justification.

## Getting Started

Pick one frustration. One thing the agent keeps getting wrong. Turn it into an instruction file. That's your first piece of scaffolding. Start with one, and it compounds from there.

If `/onboardProject` suggests instruction files, that's the planning phase quality definition. If it suggests hooks, that's the execution guardrail. Each suggestion is one piece of the cycle.

## Troubleshooting

**First step for any issue:** Run `/test hello` in Copilot Chat. If it responds with "Prompt loaded successfully," your prompt wiring is working. If not, start with the prompts section below.

**Prompts don't appear as /commands**:
- Check `chat.promptFilesLocations` in `.vscode/settings.json`
- Restart VS Code after adding prompt files
- Verify prompt files are `*.prompt.md` with valid YAML frontmatter
- Run `/test hello` to confirm prompt discovery is working

**Agents don't appear in Copilot settings**:
- Verify files are in `~/.copilot/agents/` (not a subdirectory)
- Restart VS Code
- Check that your Copilot plan supports custom agents (Business/Enterprise)

**Instructions not taking effect**:
- Verify files are in `~/.copilot/instructions/` with `.instructions.md` extension
- Check that `description:` frontmatter is present
- Restart VS Code

## Related repos

Three repos at different fractal levels of the same work:

- **[la-bella-machina](https://github.com/mydogsburneraccount/la-bella-machina)** — the methodology. The THINKING: *why* scaffolding works and how to reason about it.
- **[claude-scaffolding-bootstrap](https://github.com/mydogsburneraccount/claude-scaffolding-bootstrap)** — the same patterns as a Claude Code toolkit.
- **agentic-scaffolding** (this repo) — the GitHub Copilot toolkit and workshop materials.

## License

CC-BY-NC-4.0 (Creative Commons Attribution-NonCommercial 4.0). Use, share, and build on these materials with attribution, for non-commercial purposes. See [LICENSE](LICENSE).
