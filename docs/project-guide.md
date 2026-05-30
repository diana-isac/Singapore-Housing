# Project Guide

## Goal

Find the best short-term housing options in Singapore for the SMU study period
from August 9, 2026 to December 6-10, 2026.

The end result is:

- a curated shortlist of legitimate options
- clearly scored against the user's priorities
- ready for manual landlord or operator review

## Working Scope

Current live research scope is restricted to the 15 sources listed in:

- `references/smu_housing_list.pdf`

Do not expand beyond those 15 sources until they are fully exhausted and the
user is explicitly informed.

## Core Workflow

1. Normalize and audit each source.
2. Search only approved or conditionally approved sources.
3. Capture plausible listings in `data/listings_score_summary.csv`.
4. Verify each listing independently.
5. Apply hard filters before scoring.
6. Score surviving listings in `data/listings_scores.csv`.
7. Keep ranking and shortlist decisions directly in
   `data/listings_score_summary.csv`.

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

- `data/source-registry.csv`

### Listing-Level Trust

Question:

- Is this exact listing or room option real, legal, and suitable?

Checks include:

- semester-date compatibility
- student-pass compatibility
- exact pricing for the actual stay length
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
- prefer live or virtual tours over photos alone
- document inventory, defects, and payment proof
- review early termination, deposit return, and maintenance terms carefully

Detailed notes:

- `docs/smu-guidance.md`

## What Actually Drives The Project

### Active Data Files

- `data/user-profile.md`
- `data/criteria_weights.csv`
- `data/source-registry.csv`
- `data/listings_scores.csv`
- `data/listings_score_summary.csv`

### Core Docs

- `docs/project-guide.md`
- `docs/scoring-system.md`
- `docs/agent-guide.md`
- `docs/smu-guidance.md`

### Raw Reference Files

- `references/smu_housing_list.pdf`
- `references/smu_housing_list.txt`
- `references/smu_accommodation_tips.pdf`
- `references/smu_accommodation_tips.txt`

## Open Research Boundary

Once all 15 PDF-listed sources are:

- audited
- searched
- and their plausible listings processed

the agent must explicitly report that the source pack is exhausted before
broader market expansion begins.
