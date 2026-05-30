# Agent Guide

## Purpose

This is the compact operating guide for agent runs on this project.

## Default Mission Structure

```md
Mission:
[exact task]

Scope:
[what is in scope]
[what is out of scope]

Method:
Follow `docs/project-guide.md`, `docs/scoring-system.md`, and
`docs/smu-guidance.md`.
Use canonical project files only.

Deliverables:
[files to update]
[summary to return]

Stop rule:
[when to stop]
```

## Best Mission Types

### Source Audit

- audit named sources
- update `data/source-registry.csv`
- stop after source-level trust decisions

### Listing Extraction

- work from one approved source at a time
- update `data/listings_score_summary.csv`
- stop after all plausible options are logged

### Listing Verification

- verify hard filters and factual evidence
- update `data/listings_scores.csv`
- stop after the named listing IDs are processed

### Scoring

- score verified listings only
- update `data/listings_scores.csv`
- update `data/listings_score_summary.csv`

### Ranking

- compare scored listings only
- update `data/shortlist.csv` if appropriate

## Compute Strategy

- use low compute for obvious rejects and duplicates
- use medium compute for source audits and factual extraction
- use high compute only for ambiguous trust cases and top-candidate visual
  review

## Context Strategy

- load only global governance docs for policy decisions
- load one source at a time for source audits
- load one listing at a time for deep verification
- load only summary sheets for ranking

## Hard Rules

- do not expand beyond the 15 SMU PDF-listed sources until explicitly allowed
- do not invent missing facts
- do not treat polished marketing as proof
- do not let source trust substitute for listing trust
