---
agent: 'agent'
name: handoff
description: 'Structured agent shutdown — dump state to memory before archiving'
argument-hint: 'Optional: reason for archiving (e.g., "task complete", "switching to infra work", "end of day")'
---

You are performing a **structured shutdown** before this agent session is archived. Your job: capture everything a fresh agent would need to continue seamlessly.

## HARD CONSTRAINTS

- DO NOT skip steps. A sloppy handoff means the next agent wastes 20 minutes rediscovering context.
- DO NOT dump raw file contents — write concise summaries with file paths and line numbers.
- DO NOT leave durable handoff state only in session memory — write durable context to **repo memory** (`/memories/repo/`) so it persists.
- DO check existing repo memory files before creating new ones — update existing files when possible.

## PROCESS

### 1. Assess Current State

Determine what's in flight:
- What task(s) were active? What's their status (done, blocked, partially complete)?
- Are there uncommitted changes? (`git status` + `git diff --stat`)
- Separate **this session's changes** from **pre-existing dirty state** — only document both if they exist
- Run the repo's standard verification command only if source code or test files were modified this session (skip for docs, prompts, config-only changes)
- Any TODO items still tracked?

### 2. Write Handoff Note to Repo Memory

Create or update `/memories/repo/<relevant_title>.md` with this structure:

```markdown
# Last Handoff — {date}

## Completed This Session
- {what was done, with file:line references}

## In Progress / Blocked (omit if nothing pending)
- {what's partially done, what's blocking it}

## Uncommitted Changes
- **This session**: {files changed and why}
- **Pre-existing**: {files that were already dirty — note them so next agent doesn't wonder}

## Key Decisions Made (omit if none)
- {decision}: {why} (reference PR/issue if applicable)

## Next Steps
- {concrete next actions, ordered by priority}

## Relevant Context (omit if straightforward)
- {file paths, config values, error messages a new agent would need}
- {any gotchas or traps discovered}
```

> Omit any section that would be empty. A clean session with no blockers doesn't need "In Progress" padding.

### 3. Clean Up Session Memory

Delete any `/memories/session/` files that are no longer useful. Promote anything durable or repo-relevant to `/memories/repo/`.

### 4. Confirm

Report to the user:
- What was captured
- Where it was saved
- Whether there are uncommitted changes or failing tests
- **"Safe to archive."** or **"Warning: uncommitted changes — commit or stash first."**

## ANTI-PATTERNS

- ❌ Writing vague notes like "was working on the checkout module" — include specifics
- ❌ Skipping the git status check — uncommitted work is the #1 source of lost context
- ❌ Creating a new memory file per session — update the existing md memory file
- ❌ Dumping the entire conversation — extract only what a new agent needs
