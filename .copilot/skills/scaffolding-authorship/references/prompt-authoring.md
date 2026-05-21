# Prompt Authoring Reference

Methodology for improving existing `.prompt.md` files and creating new ones.

---

## Improvement Methodology

Use this when improving a `.prompt.md` file from evidence — workstream, review, or cross-pollination.

### Three Modes

1. **Retrospective** (default when session history shows the target prompt being executed) — extract lessons from what actually happened. Evidence comes from the workstream.
2. **Review** (cold analysis, no relevant session history) — read the prompt, cross-reference against project state and related code, identify gaps/staleness. Evidence comes from reading.
3. **Cross-pollination** (session was guided by a *different* prompt, but behaviors may transfer) — mine the session for transferable patterns.

Auto-detect: conversation shows target prompt execution → retrospective. Session has a workstream from a different prompt → cross-pollination. No session history → review.

### Architecture-Fit Check

Before proposing section-level edits, decide which best describes the target prompt:

| Outcome | When |
|---------|------|
| **Keep** | Correctly shaped; only small evidence-backed edits needed |
| **Trim** | Right primitive, but repeats adjacent guidance or has stale sections |
| **Extract** | Shared static doctrine belongs in a reference or support asset |
| **Split** | Reusable workflow mechanics belong in a skill; prompt stays as front door |
| **No change** | Working and evidence doesn't justify edits |

Don't force the answer to be an in-file edit. If the best fix lives outside the prompt, say so.

### Friction Taxonomy

Classify each lesson into exactly one category:

| Category | Signal | Example |
|----------|--------|---------|
| **Missing pattern** | Agent encountered a situation the prompt doesn't cover | A conflict type not in the classification table |
| **Missing step** | Agent had to improvise a step the prompt should have included | Verifying conflict markers after resolution |
| **Imprecise instruction** | Prompt's instruction was too broad/vague, causing waste | "Check clean worktree" catching harmless untracked files |
| **Undersold step** | Prompt mentions something but doesn't emphasize importance | Backup-ref diff as primary verification tool |
| **Wrong default** | Prompt's default was suboptimal for the common case | Always stashing when only modified files need it |
| **Missing automation** | Agent did something manually that could be auto-detected | Checking for merge commits before choosing rebase |
| **Missing context source** | Agent lacked info the prompt should have told it to gather | Not fetching upstream PR descriptions |
| **Expectation calibration** | Prompt set wrong expectations | "Overlapping files" implying all will conflict |

### Cross-Pollination Transfer Test

For each candidate lesson from a different prompt's session: *"Is this about the domain/workflow the target prompt operates in, or is it specific to the session prompt's domain?"*

Only transfer lessons that pass. Most session lessons will NOT transfer — be ruthless.

### Anti-Bloat Check

Before proposing:
- Total prompt length increase is **< 20%** of original. If over, cut lowest-priority lessons.
- No lesson merely restates something the prompt already conveys differently.
- No lesson adds a paragraph where a sentence suffices.
- New content matches the **density** of surrounding content.

### Improvement Anti-Patterns

- ❌ Adding improvements you "think might be useful" without evidence
- ❌ Rewriting working prose in your preferred style
- ❌ Adding examples too narrow to generalize
- ❌ Adding tool-specific workarounds (environment issues, not prompt issues)
- ❌ Duplicating content — add in the most impactful section, cross-reference if needed
- ❌ Adding "nice to have" lessons when the prompt is already long
- ❌ Changing frontmatter without explicit user request
- ❌ Removing anti-patterns that weren't violated
- ❌ Assuming the fix must stay inside the prompt body when the real issue is primitive fit

---

## Creation Methodology

Use this when scaffolding a new `.prompt.md` file from scratch.

### Step 1 — Understand the Request

Parse the user's description:
- **What** the prompt should do (the task it automates)
- **Who** the AI should be (role/expertise)
- **How** it should work (agent mode, tools needed, workflow steps)
- **What it should NOT do** (failure modes to guard against)

### Step 2 — Discover Context

Search the codebase to inform the prompt design:
- Read the current `AGENTS.md` for the catalog, lane model, and authoring conventions
- Read 2-3 relevant `.prompt.md` files to match voice, density, and formatting conventions
- Read `.github/copilot-instructions.md` for project-level instructions
- Use standard VS Code prompt locations for placement: `.github/prompts/` for repo-specific, `~/Library/Application Support/Code/User/prompts/` for portable user prompts
- Read `.vscode/mcp.json` only when MCP/tool availability materially affects the design
- Look at relevant source files if the prompt targets a specific domain

### Step 3 — Ask Up to 3 Clarifying Questions (if needed)

If intent is ambiguous, ask targeted questions with smart defaults. Skip if clear.

Consider:
- Should this prompt edit files, or just analyze and report?
- What specific output format? (table, checklist, prose, code block)
- Should it have a handoff to another mode when done?

### Step 4 — Construct the Prompt File

Choose the correct destination using standard VS Code prompt locations and current lane guidance.

The prompt must:
- Use the smallest correct mode and frontmatter
- Match local naming and placement conventions
- Include only task-specific constraints, workflow, output contract, and anti-patterns
- Inline stable local context when it improves execution quality
- Avoid stale or version-sensitive tool inventories unless restriction is intentional

### Step 5 — Save and Confirm

Save to the correct destination where `<name>` matches the `name` field.

Confirm:
- File saved to: `<path>`
- How to invoke: `/<name> <argument>`
- What it does in one sentence
- Which mode/tools it uses and why

### Creation Anti-Patterns

- ❌ Creating a prompt for something an existing prompt already handles
- ❌ Duplicating rules from `copilot-instructions.md` into the prompt
- ❌ Building a prompt when the real need is an instruction, reference, or skill
- ❌ Over-engineering v1 — start minimal, iterate from workstream evidence
