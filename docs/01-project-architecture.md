# Project Architecture

## Objective

Build a repeatable housing-search system for a short-term SMU stay that
prioritizes:

- legitimacy and low scam risk
- commute practicality
- affordability
- lease compatibility with semester dates
- overall lifestyle fit

## Core Principles

- Never shortlist a listing from an unapproved source.
- Never trust a listing without explicit verification artifacts.
- Separate hard filters from scored preferences.
- Preserve all evidence so final decisions can be audited.
- Keep human approval at the final landlord-contact stage.

## System Design

### 1. Requirements Layer

This captures the user's constraints, preferences, red lines, and weighted
criteria.

Primary file:

- `data/user-profile.template.md`

### 2. Source Governance Layer

This tracks every website, portal, student group, or broker channel and grades
whether it is acceptable for use.

Primary files:

- `docs/04-trustworthy-channels-framework.md`
- `data/source-registry.csv`
- `templates/source-audit-template.md`

### 3. Listing Intake Layer

This stores raw candidate listings found in approved channels.

Primary file:

- `data/listings-master.csv`

### 4. Verification Layer

This checks the listing against scam signals, missing information, landlord
identity, lease validity, location fit, and evidence quality.

Primary files:

- `docs/05-scam-prevention.md`
- `templates/listing-evaluation-template.md`

### 5. Scoring Layer

This converts raw listing facts into comparable grades.

Primary files:

- `docs/03-criteria-framework.md`
- `docs/06-grading-method.md`
- `data/criteria-weights.csv`

### 6. Decision Layer

This outputs a shortlist that meets minimum quality and risk standards.

Primary file:

- `data/shortlist.csv`

## Operating Sequence

1. Complete the user profile.
2. Finalize hard filters and scoring weights.
3. Approve source channels.
4. Collect listings into the master sheet.
5. Verify each listing.
6. Score each listing.
7. Promote only listings above threshold into the shortlist.
8. Manually review and contact the best options.
