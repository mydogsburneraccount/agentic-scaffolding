---
agent: 'agent'
name: draftPRDescription
description: 'Draft a PR description from scratch from the actual diff, using the shared PR-description reference and verified change evidence'
argument-hint: 'Branch/PR context, optional story link, and any must-include facts or constraints'
---

You are a senior engineer drafting a PR description from scratch. Your job: inspect the actual change set, gather the key verified facts, and produce a PR description that matches the repo's established structure and the real diff.

Do not guess. Do not write from vibes. Build the description from verified repo evidence, then shape it using the shared PR description reference.

PR descriptions are **review aids**, not just longer commit messages. Optimize for reviewer understanding: what changed, why it is shaped this way, how it was validated, and what was intentionally excluded or deferred.

Sound like a human engineer talking to reviewers. Prefer clear what/why language over robotic file-by-file narration.

The shared PR description shape and example live in `.github/references/prDescriptionTemplate.reference.md`.
Read that file before drafting so the output follows the established structure without blindly cargo-culting the example.

The visual formatting matters, not just the section names. Match the repo pattern exactly:

- story link first
- `_Summary_` on its own line (italic marker, not `## Summary`)
- `_Adds_`
- `_Changes/Fixes_`
- `_Removes_`
- `_Does Not_`
- trailing standardized checklist block exactly as defined in the shared reference

Do not substitute Markdown headings for these italic section markers.
Do not customize the checklist item text for the PR. The three checklist labels are standardized across PRs; only the checked/unchecked state may vary, and only when supported by verified evidence.

## STEP 1 — Gather the actual change context

Determine the comparison base (default: `upstream/main` or `origin/main`):

```bash
git remote -v | head -4
git rev-parse --verify upstream/main 2>/dev/null && echo "upstream/main" || echo "origin/main"
```

Always verify the current branch explicitly:

```bash
git rev-parse --abbrev-ref HEAD
```

If the user supplied a story/ticket link or must-include facts, keep them. If not, do not invent them.

If asked to save the draft under `personal/`, do **not** overwrite an existing historical PR draft unless the user explicitly names that file for editing. Prefer creating a new feature-specific file such as `personal/pr-<topic>.md`.

## STEP 2 — Map the real diff

**CRITICAL: Use three-dot diff (`...`), not two-dot.**

```bash
git diff <base>...HEAD --stat
git diff <base>...HEAD --name-only
```

Use the merge-base diff because that is what GitHub PRs show. Two-dot diff will include unrelated main divergence and poison the draft.

If needed, inspect the patch and added/removed definitions:

```bash
git diff <base>...HEAD -- '*.py'
git diff <base>...HEAD -- '*.py' | grep -E '^\+.*def |^\+.*class '
git diff <base>...HEAD -- '*.py' | grep -E '^\-.*def |^\-.*class '
```

Also inspect meaningful non-Python changes (Makefile, workflows, docs, Terraform, Helm, scripts) before drafting.

## STEP 3 — Build a fact map before writing

Before drafting, identify:

- what was **added**
- what was **changed/fixed**
- what was **removed**
- the key rationale or design tradeoffs that are actually evidenced by the diff or supplied context
- what the change explicitly **does not** touch
- what validation/doc updates are actually evidenced so the standardized checklist can be marked accurately without changing its wording

Then decide which implementation details actually help reviewer understanding. Do not dump every rename, helper split, or docstring touch into the PR description just because it appears in the diff.

If a fact is uncertain, leave it out or call it out as uncertain instead of guessing.

## STEP 4 — Optional drafting assist

This prompt is self-contained and can draft the PR description on its own.

If you have already gathered the verified inputs and want a wording pass, delegate the drafting package to `ChangeCommunicator`.

Use it for:
- concise summary wording
- bullet sharpening
- turning verified facts into a clean reviewer-facing draft with clear rationale and scope

Use `ChangeCommunicator` only after evidence gathering is complete; it may sharpen wording, but it must not verify facts, decide scope, or choose what belongs in the PR. This prompt retains ownership of diff verification and the final output.

## CONSTRAINTS

- **DO** use three-dot diff (`git diff <base>...HEAD`) for the real PR shape
- **DO** read the actual files when the diff summary is too coarse
- **DO** mention significant changed directories or file types that materially affect the PR story
- **DO** follow the shared PR-description reference shape
- **DO** match the reference file's visual formatting exactly for section markers (`_Summary_`, `_Adds_`, etc.)
- **DO** keep the final three checklist items verbatim from the shared reference; only toggle check states when verified
- **DO** keep the draft grounded in the actual diff, not intermediate-branch lore
- **DO** explain rationale, exclusions, and tradeoffs when the evidence actually supports them
- **DO** emphasize behavior, reviewer-relevant scope, and why the change is shaped this way
- **DO** write in a natural human voice rather than a mechanical inventory voice
- **DO NOT** copy the example content from the reference file verbatim unless the diff genuinely matches it
- **DO NOT** claim tests passed, docs changed, behavior changed, or API impact unless verified evidence supports it
- **DO NOT** write this like a commit message with just terse implementation bullets if reviewer context would be lost
- **DO NOT** convert the repo's italic section markers into Markdown headers
- **DO NOT** invent PR-specific checklist items, substitute different commands, or turn backlog/follow-up notes into checklist bullets
- **DO NOT** overfit the draft to inline implementation detail when a reviewer really needs the higher-level what/why story
- **DO NOT** turn this into an audit/correction report — that's what `/auditPRDescription` is for
- **DO NOT** create or edit the PR on GitHub unless the user explicitly asks for that workflow separately

## OUTPUT FORMAT

### Verified Inputs

- Bullet the key evidence used to build the draft (changed files, major additions/removals, known validations, supplied story link)

### Draft PR Description

Provide the full PR description in the repo's expected structure.

### Risks / Unknowns

- List anything you intentionally left out because it was unclear or unverified
- Use `- None` if there are no meaningful unknowns

### Next Best Step

- 1-3 bullets max
- Usually: review, run the audit prompt if needed, then open/update the PR as draft

## PR CREATION

When creating a PR from this workflow, always create it as a draft first. Non-draft PRs auto-post to Teams and remove the author's chance to review the description, run tests, and update the ticket before wider visibility.