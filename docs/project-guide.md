# Project Guide

## Goal

Find the best short-term housing options in Singapore for the SMU study period
from August 9, 2026 to December 6-10, 2026.

The end result is:

- a curated shortlist of legitimate options
- clearly scored against the user's priorities
- ready for manual landlord or operator review

## Working Scope

Current live research scope is based on:

- `references/smu_housing_list.pdf`
- plus any additional sources explicitly approved by the user and entered into
  `data/source_registry.csv`

Do not expand beyond that set until it is fully exhausted and the user is
explicitly informed.

## Core Workflow

1. Normalize and audit each source.
2. Search only approved or conditionally approved sources.
3. Capture plausible listings in `data/listing_facts.csv`.
4. Audit the completed extraction phase before progressing.
5. Verify each listing independently.
6. Audit the completed verification phase before progressing.
7. Apply hard filters before scoring and store state in
   `data/listing_decisions.csv`.
8. Audit the hard-filter state before progressing.
9. Score surviving listings in `data/listing_scores_long.csv`.
10. Audit the scoring output before progressing.
11. For listings that remain `hard_filter_tbd` but are still worth manual review,
   keep provisional comparison scores clearly labeled as provisional rather than
   cleared.
12. Store decision rollups, confidence, and ranking readiness in
   `data/listing_decisions.csv`.
13. Generate a separate human-facing deliverable only after the machine files
   and audits are complete.

## Trust Model

Trust is checked at two levels:

### Source-Level Trust

Question:

- Is this channel or operator trustworthy enough to search?

Outputs:

- `approved`
- `conditional`
- `rejected`

Stored in:

- `data/source_registry.csv`

### Listing-Level Trust

Question:

- Is this exact listing or room option real, legal, and suitable?

Checks include:

- semester-date compatibility
- student-pass compatibility
- exact pricing for the actual stay length
- exact currency used and normalized SGD comparison value
- deposit and fee clarity
- room features
- visual quality
- identity and control of the property
- lease clarity

## User Priorities

Current ranking priorities are:

1. distance to SMU
2. AC in the room or at least strong AC in the apartment
3. low price at good quality
4. legitimacy, semester fit, and student-pass compatibility
5. core room basics
6. guest-policy concerns only when explicit restrictions exist

Detailed profile:

- `data/user-profile.md`

## Key Rules From SMU Guidance

Distilled from:

- `references/smu_accommodation_tips.pdf`

Operational rules:

- exclude Airbnb-style residential short stays
- do not pay before a signed agreement
- do not rely on verbal promises
- clarify utilities explicitly
- normalize non-SGD prices to SGD before any budget decision
- prefer live or virtual tours over photos alone
- document inventory, defects, and payment proof
- review early termination, deposit return, and maintenance terms carefully

Detailed notes:

- `docs/smu-guidance.md`

## What Actually Drives The Project

### Active Data Files

- `data/user-profile.md`
- `data/criteria_weights.csv`
- `data/source_registry.csv`
- `data/listing_facts.csv`
- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`
- `docs/agent-context-log.md`
- `docs/audit-guide.md`

### Core Docs

- `docs/project-guide.md`
- `docs/scoring-system.md`
- `docs/agent-guide.md`
- `docs/audit-guide.md`
- `docs/data-dictionary.md`
- `docs/agent-context-log.md`
- `docs/ops-log.md`
- `docs/smu-guidance.md`

### Raw Reference Files

- `references/smu_housing_list.pdf`
- `references/smu_housing_list.txt`
- `references/smu_accommodation_tips.pdf`
- `references/smu_accommodation_tips.txt`

## Open Research Boundary

Once all in-scope sources are:

- audited
- searched
- and their plausible listings processed

the agent must explicitly report that the current source pack is exhausted
before broader market expansion begins.

## Lifecycle Rule

Every listing should carry an explicit lifecycle state instead of having
readiness inferred indirectly from mixed fields.

Current operational states:

- `phase2_extracted`
- `phase3_hard_filter_reviewed`
- `phase6_scored_provisional`
- `phase6_scored_final`
- `phase6_scored_failed`

Before editing any listing row, the agent must read the current lifecycle state
and avoid overwriting later-phase work with earlier-phase assumptions.

## Audit Rule

Every phase output must be audited before the next phase begins.

Use:

- `docs/audit-guide.md`

This is a required gate, not an optional polish step.

## Memory Rule

Every mission must end with a log append.

Use:

- `docs/agent-context-log.md` for durable research memory
- `docs/ops-log.md` for repo/session mechanics

Logging is mandatory. Agents should not require a user reminder to record
context.

## Currency Rule

Scoring stays canonical in SGD.

Companion USD values should be stored where useful for human review, but they do
not replace SGD as the scoring currency.
