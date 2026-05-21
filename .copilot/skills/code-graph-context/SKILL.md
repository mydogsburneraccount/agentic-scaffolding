---
name: code-graph-context
description: "Use when you need structural codebase analysis via a Neo4j-backed code graph: callers and callees, dependency tracing, dead code, complexity hotspots, or architecture mapping."
argument-hint: "Describe the codebase area or relationship to map"
user-invocable: true
disable-model-invocation: true
---

# Code Graph Context

Use this skill when ordinary text search is not enough and the question is fundamentally structural.

## Use This Skill For

- finding direct or transitive callers and callees
- tracing router → service → adapter → client paths
- mapping module dependencies and importers
- identifying dead code or complexity hotspots
- onboarding to an unfamiliar codebase architecture

## Do Not Use This Skill For

- simple keyword or comment searches
- config-value lookups
- runtime-only behavior, feature flags, or dynamic dispatch questions
- data-contract or payload-shape questions that are better answered from source models

## Workflow

1. Confirm that the workspace has a reachable graph setup or available graph tooling. Use the bundled [Neo4j context graph reference](./references/neo4j-context-graph.reference.md) for setup expectations.
2. Start with the narrowest structural question possible and identify the exact symbol or module names when you can.
3. If the exact names are unclear, use ordinary code search first to discover them before reaching for graph queries.
4. Prefer structured relationship queries over raw graph queries when both can answer the question.
5. Use recursive callers, recursive callees, dead-code checks, or complexity ranking only when the direct graph is not enough.
6. When the active workspace provides repo-local graph instructions, follow those for tool-specific details and exact query shapes.
7. Summarize both the answer and the graph's blind spots so the user knows what static analysis can and cannot prove.

## Output

- question being answered
- graph strategy used
- exact symbols or modules queried
- answer with evidence
- limits, blind spots, or follow-up reads still needed

## Anti-Patterns

- treating the static graph as runtime truth
- starting with broad graph queries when the target can be narrowed first
- using raw graph queries before simpler structured graph tools or ordinary code search
- claiming graph coverage or correctness without checking whether the graph is actually available
