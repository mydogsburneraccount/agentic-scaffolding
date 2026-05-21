---
description: "Use when orchestrating multi-lane subagent work and you need the tactical playbook for lane design, context packaging, convergence standards, and execution-brief synthesis. The always-on working-style instruction establishes the default orientation; this file is the detailed how-to."
---

# Quorum Pattern — Lane Design Playbook

The always-on `working-style.instructions.md` establishes the default: leverage expert subagents for non-trivial work and run review rounds on deliverables. This file is the tactical playbook for **how** to design lanes, package context, converge outputs, and synthesize execution briefs when orchestrating multi-lane work.

This file complements workspace instructions, agent rosters, and agent-governance rules. It does **not** replace the global behavior defaults, the runtime agent index, or the specialist-agent governance rules.

## What the Pattern Means

The main agent remains the lead orchestrator and final owner of the work.

The quorum pattern means:
- bring in the right expert lenses when they materially improve the outcome,
- give each lane the right tools and context,
- seek enough review signal to move with confidence,
- synthesize the result into one coherent plan,
- keep ownership of decisions, tradeoffs, implementation, and delivery.

It does **not** mean voting, mandatory unanimity, or spawning extra agents for theater.

## When to Use It

Reach for a quorum-style pass when:
- the task spans multiple areas or ownership is ambiguous,
- there are multiple unresolved questions that deserve different specialist lenses,
- the plan needs hardening before implementation,
- the user would benefit from seeing the review lanes and synthesis explicitly,
- tool and context packaging across the user, main agent, and delegates materially affects success.

Keep the work local when:
- the task is a direct answer or code sample,
- the change is tiny and obvious,
- one bounded local read is faster than orchestration,
- extra delegation would add more ceremony than signal.

## Orchestrator Responsibilities

Before delegating, the main agent should:
- identify the primary unresolved question,
- decide whether there are additional distinct unresolved questions,
- choose the smallest useful primitive for each part of the job,
- decide what the user needs to answer versus what the team can infer safely,
- keep the mental model coherent enough to judge delegate output.

After delegating, the main agent should:
- compare the outputs rather than transcript-dumping them,
- call out agreement, disagreement, and weak evidence honestly,
- choose the path forward and explain why it is trusted enough,
- own the final implementation or recommendation.

## Lane Design Checklist

For each lane, define:
- the exact question the lane owns,
- why that question needs a distinct lane,
- which files, symbols, or artifacts matter,
- which tools the lane should use,
- whether the lane is read-only research or expected to edit,
- what output or recommendation is needed back.

Good lane shapes:
- call-path discovery
- existing test and mock pattern scouting
- customization drift review
- proposal hardening
- code-quality review for a supplied artifact

Bad lane shapes:
- two lanes reading the same files with slightly different wording,
- one lane that tries to answer every question,
- vague requests like "look around" when `Explore` would be better,
- assigning tools that the lane does not need.

## Context Packaging

Package each lane with only what it needs:
- the question,
- the relevant files or paths,
- constraints or exclusions,
- the expected deliverable,
- whether outside research is allowed,
- any user preference or tradeoff that should shape the answer.

Do not dump the whole repo or conversation into every lane by default.

## Convergence Standard

The goal is not unanimity. The goal is a well-supported decision.

Before acting, the orchestrator should be able to say:
- what the task actually is,
- which lanes were used and why,
- where the evidence agrees,
- where it conflicts or is weak,
- what path is being chosen,
- why that path is trusted enough to move forward.

If confidence is still low after one pass, either:
- ask the user one tight clarifying question,
- spin a narrowly targeted follow-up lane,
- or keep the next iteration local if more delegation will not help.

## Execution Brief

When the work merits a visible synthesis, the execution brief should cover:
- task framing,
- relevant files,
- selected lanes and why,
- tool/workflow choices,
- main risks or disagreements,
- the minimum edit set or next action,
- how the result will be verified.

The execution brief is for synthesis, not ceremony. Keep it as small as the task allows.

## Specialist Output Alignment

Subagent return schemas and detailed reviewer-precedence rules are governed by the user-level `agent-governance.instructions.md`.

Use that instruction to standardize:
- what questions you send to each lane,
- what context and tools you package with them,
- how you compare and synthesize what comes back.

Do **not** create ad-hoc reply formats per lane when the agent standard already defines the headings.

## Anti-Patterns

- Treating quorum as a synonym for mandatory multi-agent fan-out.
- Delegating before the main agent understands the problem well enough to judge the answers.
- Sending overlapping or mushy lanes.
- Over-tooling a lane just because the tools are available.
- Confusing consensus with unanimity.
- Using quorum as an excuse to avoid making a call.
- Jumping from raw delegate output straight into edits without synthesis.