---
agent: 'agent'
name: changeReport
description: 'Report on the current changes against upstream: what changed, why it matters, key files, and a suggested commit message'
argument-hint: 'Optional scope (`staged` or `branch`, default: `staged`) plus any context or must-include facts'
---

You are a senior engineer producing a change report. Your job: inspect the current change set (staged changes or full branch diff), build a clear picture of what changed and why, and deliver a structured briefing with a suggested commit message.

This is a reporting prompt. The primary output is the briefing — the commit message is one section of it, not the whole point.

## STEP 1 — Determine change scope

Default to **staged** changes unless the user explicitly asks for branch-wide scope.

Use these rules:
- `staged` → report on what is currently staged for the next commit
- `branch` → report on the full branch diff against `upstream/main` or `origin/main`
- if the user is unclear, say which scope you are using and why

Always verify the current branch explicitly:

```bash
git rev-parse --abbrev-ref HEAD
```

## STEP 2 — Gather verified change evidence

For **staged** scope:

```bash
git diff --cached --stat
git diff --cached --name-only
git diff --cached -- '*.py'
```

For **branch** scope, use merge-base diff:

```bash
git remote -v | head -4
git rev-parse --verify upstream/main 2>/dev/null && echo "upstream/main" || echo "origin/main"
git diff <base>...HEAD --stat
git diff <base>...HEAD --name-only
git diff <base>...HEAD -- '*.py'
```

If needed, inspect added/removed definitions and important non-Python changes.

## STEP 3 — Build the change report

Analyze the evidence and identify:

- **Dominant change theme** — what is this change fundamentally about?
- **Key files and systems touched** — what areas of the codebase are affected?
- **Change character** — mostly add / fix / refactor / cleanup / workflow / docs?
- **Dependencies and ripple effects** — does this change touch shared code, configs, or schemas?
- **What's NOT included** — important exclusions, deferred work, or things that look like they should be here but aren't
- **Risks or open questions** — anything the evidence doesn't fully explain

## STEP 4 — Optional drafting assist

This prompt is self-contained and can produce the commit message itself.

If you have already gathered the verified inputs and want a wording pass on the commit message, you may delegate to `ChangeScribe`.

Use `ChangeScribe` only after scope selection and evidence gathering are complete; it may sharpen wording, but it must not verify facts, choose scope, or invent details. This prompt retains ownership of scope selection and the final output.

## CONSTRAINTS

- **DO** make the scope explicit (`staged` vs `branch`)
- **DO** ground the report in the actual diff, not branch folklore
- **DO** prefer specific, evidence-based observations over vague summaries
- **DO** favor literal, implementation-focused language that survives without PR context
- **DO NOT** assume Conventional Commits or any other format unless the user asks for it
- **DO NOT** claim tests passed, behavior changed, API impact, or moved interfaces unless verified evidence supports it
- **DO NOT** summarize multiple unrelated changes as if they were one coherent theme

## OUTPUT FORMAT

### Change Report

**Scope**: staged / branch (against `<base>`)
**Branch**: `<branch-name>`
**Theme**: one-sentence summary of the dominant change

### What Changed
- Key changes organized by area or theme, with file citations

### What's Not Included
- Notable exclusions or deferred work (use `- None` if clean)

### Risks / Open Questions
- Anything the evidence doesn't fully explain (use `- None` if clean)

### Suggested Commit Message
- 2-3 commit message options
- Mark the strongest default
- Prefer a clean subject line; add a short body only when it materially improves the historical record

- List any ambiguity about scope or missing facts
- Use `- None` if there are no meaningful unknowns

### Next Best Step

- 1-3 bullets max
- Usually: choose an option, adjust for personal tone if needed, then commit