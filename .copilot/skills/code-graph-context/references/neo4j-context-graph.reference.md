# Neo4j Context Graph Reference

Use this reference when setting up a local Neo4j-backed context-graph workflow for repo analysis.

## What it is for

A context graph is useful for questions like:
- what calls this symbol,
- what does this component depend on,
- what paths connect these modules,
- where would a change ripple through the codebase.

## Portable pattern

The reusable pattern has three parts:
1. a local Neo4j service,
2. a context-graph MCP server or CLI configured to talk to Neo4j,
3. a small validation flow to confirm the graph is reachable and queryable.

## Required environment variables

- `NEO4J_URI`
- `NEO4J_USERNAME`
- `NEO4J_PASSWORD`

## What to keep out of version control

Do not commit:
- live Neo4j `data/` or `logs/` folders,
- real passwords or tokens,
- user-specific absolute paths,
- corp proxy or internal CA settings unless they are truly required for the target environment.

## Suggested doc structure for a target repo

1. Overview
2. Prerequisites
3. Run Neo4j locally
4. Configure the MCP server
5. Verify it works
6. Troubleshooting
7. Optional proxy or custom-CA notes
8. What not to commit
