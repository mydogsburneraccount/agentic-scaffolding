---
description: "Use when reading from or writing to /memories/. Defines scope selection, content boundaries, and anti-patterns for the persistent memory system."
---

# Memory Usage

## Scope Selection

| Scope | Path | Persistence | Use for |
|---|---|---|---|
| **Repo** | `/memories/repo/` | Survives across all sessions in this workspace | Decision records, handoff context, verified findings, cross-session coordination |
| **User** | `/memories/` | Survives across all workspaces and sessions | Personal preferences, cross-repo patterns, tool/environment notes |
| **Session** | `/memories/session/` | Current conversation only | Scratch calculations, intermediate state that will be consumed before the session ends |

**Default to repo scope.** Session memory is not accessible to future agents or sessions — anything worth recording is worth persisting. Use session scope only for throwaway working state you will consume within the same conversation.

## What Memory Is For

Memory stores **decision records and factual findings**: what was decided, why, what was tried, what worked, what didn't, and what's unresolved. It provides continuity between sessions so the next agent doesn't repeat discovery or contradict prior decisions.

Good memory entries:
- "Chose X over Y because of Z" (with evidence)
- "Tried approach A — failed because B, pivoted to C"
- "Open question: whether D applies when E"
- "Handoff: completed steps 1-3, step 4 blocked on F"
- Verified technical findings (supply chain audits, API behavior, env quirks)

## What Memory Is Not For

Memory is not an instruction surface. Guidelines, rules, conventions, and behavioral directives belong in `.instructions.md`, `.agent.md`, `copilot-instructions.md`, references, or skills — not in memory files.

Bad memory entries:
- "Always use X pattern when writing tests" → belongs in a `.instructions.md`
- "The preferred naming convention is..." → belongs in `copilot-instructions.md` or a code-quality instruction
- "When reviewing PRs, follow these steps..." → belongs in an agent or prompt
- Duplicating or restating rules already in instruction files

## Hygiene

- Before creating a new memory file, check what already exists — avoid duplicates.
- Keep entries concise. Bullet points and short paragraphs, not essays.
- Name files descriptively: `feature-x-handoff-2026-04-22.md`, not `notes.md`.
- Clean up memory files that are fully consumed or superseded — they accumulate and cost context.
- Do not store secrets, credentials, or tokens in memory.
