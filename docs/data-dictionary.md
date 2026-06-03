# Data Dictionary

Purpose: define the canonical meaning and allowed values for the most important
machine fields.

## Core Files

- `data/source_registry.csv`
- `data/listing_facts.csv`
- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`

## Listing Lifecycle Fields

### `phase_state` in `data/listing_facts.csv`

Allowed values:

- `phase2_extracted`
- `phase3_hard_filter_reviewed`
- `phase6_scored_provisional`
- `phase6_scored_final`
- `phase6_scored_failed`

Meaning:

- `phase2_extracted`: listing has factual intake only
- `phase3_hard_filter_reviewed`: hard filters have been checked, but scoring is
  not yet complete
- `phase6_scored_provisional`: listing has comparison scoring, but unresolved
  hard filters still exist
- `phase6_scored_final`: listing has completed scoring and is fully rankable
- `phase6_scored_failed`: listing failed one or more hard filters and is
  reference-only unless explicitly kept in view

### `current_phase_state` in `data/listing_decisions.csv`

Must match the listing's current workflow state and should stay aligned with
`phase_state` in `data/listing_facts.csv`.

## Hard-Filter And Ranking Fields

### `hard_filter_status`

Allowed values:

- `extracted`
- `hard_filter_tbd`
- `hard_filter_failed`

Meaning:

- `extracted`: no hard-filter judgment yet
- `hard_filter_tbd`: one or more hard filters remain unresolved
- `hard_filter_failed`: at least one hard filter failed

### `rankable_status`

Allowed values:

- `rankable`
- `review_only_hard_filter_tbd`
- `not_rankable_extraction_only`
- `not_rankable_hard_filter_failed`

Meaning:

- `rankable`: eligible for ranking
- `review_only_hard_filter_tbd`: may be compared provisionally, but not treated
  as cleared
- `not_rankable_extraction_only`: not ready for scoring or ranking
- `not_rankable_hard_filter_failed`: excluded from normal ranking

### `needs_manual_followup`

Allowed values:

- `yes`
- `no`
- `unknown`

## Quality Fields

### `confidence_level`

Allowed values:

- `high`
- `medium`
- `low`
- `unknown`

This is the decision-level confidence in the current listing record, not the
same thing as source trust.

### `evidence_quality`

Allowed values:

- `high`
- `medium`
- `low`
- `unknown`

This reflects the quality of evidence currently supporting the listing record.

## URL Quality Field

### `listing_url_quality`

Allowed values:

- `exact_or_best_public_room_page`
- `best_public_non_exact`
- `mixed_or_non_exact`
- `missing`

Meaning:

- `exact_or_best_public_room_page`: exact listing or room page is stored, or the
  best available public listing page when no deeper room page exists
- `best_public_non_exact`: best public page exists, but exact room detail page
  is not exposed
- `mixed_or_non_exact`: multiple URLs or a mixed note are stored because no
  single exact page is available
- `missing`: no usable URL stored

## Currency Fields

### Canonical Rule

- scoring uses SGD
- USD values are companion values for human review
- all cross-currency interpretation must cite the project FX reference

### `displayed_currency`

Allowed values:

- `SGD`
- `USD`
- `unknown`

## Criterion-State Field

### `criterion_state` in `data/listing_scores_long.csv`

Allowed values:

- `hard_filter_reviewed`
- `provisional_scored`
- `scored`

Meaning:

- `hard_filter_reviewed`: pass/fail/TBD hard-filter row
- `provisional_scored`: non-hard-filter score on a listing with unresolved hard
  filters
- `scored`: non-hard-filter score on a listing whose score row is treated as a
  normal completed score

## Metadata Fields

### `session_id`

Required in all canonical machine files.

Purpose:

- identify the research session or major operating run that created or edited
  the row

### `batch_id`

Required in all canonical machine files.

Purpose:

- identify the specific source batch or listing batch worked in that mission

### `created_at`, `updated_at`

Required in all canonical machine files.

Purpose:

- preserve row-level timing for later audits and merges

## Judgment Placement Rule

Prefer this split:

- `data/listing_facts.csv`: raw listing facts and normalized values
- `data/listing_decisions.csv`: confidence, visual condition note, strengths,
  concerns, next action, and rankability
- `data/listing_scores_long.csv`: criterion-level scoring evidence
