---
description: "Use when evaluating outside guidance, external documentation, or third-party recommendations for implementation strategy, architecture, or security decisions."
---

# Source Quality

Use these rules when evaluating outside guidance for implementation strategy, architecture, testing approach, performance claims, or security-sensitive decisions. Treat this file as the default evidence policy for source quality judgments.

## Source Tiers

### Primary

Use as the default highest-confidence evidence:
- official docs
- standards and RFCs
- maintainer statements
- maintainer-reviewed GitHub issues and discussions
- release notes and migration guides
- security advisories
- repo code and tests when the question is repo-local

### Strong Secondary

Useful when corroborated with primary sources or multiple independent sources:
- respected expert books or conference talks
- established engineering blogs by known contributors
- recent benchmarks with clear methodology
- well-maintained vendor docs
- high-signal Stack Overflow answers with strong community review

### Weak or Context-Only

Use only for context, disagreement discovery, or edge cases -- never as primary justification:
- random blog posts
- forum threads
- Reddit or Hacker News discussions
- low-credential tutorials
- LLM output or AI-generated summaries
- vendor marketing without evidence
- search engine snippets (these are extracted fragments, not verified claims)

## Domain Overrides

### Security

Bias hard toward:
- official advisories
- OWASP / CWE / CVE
- maintainer security guidance
- corporate policy and internal constraints

Reject blog-only solutions for auth, crypto, secret handling, or other sensitive patterns.

### Python / FastAPI / Pydantic

Prefer:
- official docs
- maintainer migration notes
- maintainer issues/discussions
- recent examples that match the major version in use

Downweight older Pydantic v1 or pre-3.10 Python guidance when it conflicts with current code or docs.

### Infrastructure / Kafka / Postgres

Prefer:
- official vendor docs
- maintainer or standards guidance
- recent benchmarks with explicit methodology
- issue threads tied to real operational behavior

Reject generic "best practices" posts that do not cite failure modes, throughput data, or current-version behavior.

### Architecture / Testing

Prefer:
- official testing docs
- repo conventions
- maintainer guidance
- recognized expert material with concrete tradeoffs

If external advice conflicts with repo conventions, call out the conflict explicitly instead of pretending both are equally good.

## Staleness Rules

Treat sources as suspicious when:
- framework guidance is more than 2 years old
- async/concurrency advice is more than 18 months old in a fast-moving area
- security advice is older than 90 days and there are newer advisories
- version-sensitive examples target older major versions than the repo uses

If a stale source conflicts with a fresher primary source, weight the fresher source higher and note the conflict.

## Cross-Confirmation Rules

Require multiple sources when:
- deciding among strategies or architecture patterns
- evaluating performance claims
- making security-sensitive decisions
- proposing a break from repo precedent

Single-source answers are acceptable only for:
- factual lookups
- language or API signatures from official docs
- explicit security advisories
- repo-internal facts already verified from code

## Evidence Weighting Heuristics

Prefer source A over source B when:
- A is closer to maintainers or standards
- A is more recent for the relevant version
- A includes methodology or reproducible detail
- A matches repo constraints and B ignores them
- A acknowledges tradeoffs and B oversimplifies the decision

## Red Flags

Downweight immediately when a source:
- has no author credibility or citations
- claims there is only one correct answer with no caveats
- contradicts current docs without evidence
- gives benchmark numbers without methodology
- is clearly written for a different stack or older major version
- is an AI-generated summary or LLM-synthesized answer rather than original human-authored content
- was cited from a search snippet or summary without the actual page content being read

## How to Use This Reference

1. Gather multiple candidate sources.
2. Classify each source by tier.
3. Apply domain overrides.
4. Check staleness.
5. For each source you intend to cite, read the actual page content using raw reading tools (trafilatura, Playwright, or equivalent). Do not cite based on search snippets alone.
6. Cross-confirm where needed.
7. Rank the strategies by evidence quality and repo fit.
8. Call out disagreement honestly instead of smoothing it away.
