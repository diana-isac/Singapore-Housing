# Scoring System

## Canonical Files

- `data/criteria_weights.csv`
- `data/listing_facts.csv`
- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`
- `data/listing_output_human.csv`

## Model

### Criteria Registry

`data/criteria_weights.csv` is the source of truth for:

- criterion IDs
- category membership
- hard-filter status
- point caps
- category totals

### Listing Scores

`data/listing_scores_long.csv` is the detailed audit sheet.

- one row per listing criterion
- hard filters use `hard_filter_pass`
- scored criteria use `points_awarded`
- penalty rows use negative or zero scores where applicable
- non-hard criteria on `hard_filter_tbd` listings may use
  `provisional_scored` status for comparison-only scoring

### Listing Facts

`data/listing_facts.csv` is the factual listing surface.

- one row per listing
- factual intake only
- normalized rent fields
- source URL quality
- session and batch metadata
- no ranking prose required for basic extraction

### Listing Decisions

`data/listing_decisions.csv` is the decision and status surface.

- one row per listing
- lifecycle state
- hard-filter status
- ranking readiness
- category subtotals
- total positive score
- penalty totals
- final score after penalties
- strengths, concerns, next action

### Human Output

`data/listing_output_human.csv` is the final reading surface for the user.

Current column order:

- `source_name`
- `apartment_or_room_style`
- `cost_sgd`
- `cost_usd`
- `minutes_from_smu`
- `total_score`
- `exact_listing_url`
- `lease_fit_score`
- `cost_score`
- `location_score`
- `living_arrangement_score`
- `unit_quality_score`
- `trust_score`

Score formatting rule:

- show score columns as `x/y`

## Execution Rules

1. Hard filters are checked before scoring.
2. Unknown facts remain unknown.
3. High score does not override trust problems.
4. Listing-level trust can still fail on a trusted source.
5. Decision-level ranking must be traceable back to detailed rows.
6. Budget comparisons must use normalized SGD values, not raw displayed values
   in mixed currencies.
7. `hard_filter_tbd` listings may carry provisional comparison scores if:
   - the top-level hard-filter status remains `hard_filter_tbd`
   - the score rows are clearly marked provisional
   - ranking notes do not present them as fully cleared options
   - unresolved hard filters remain explicit in `data/listing_decisions.csv`

## Currency Rule

Before any budget check, scoring pass, or ranking comparison:

- identify the displayed currency on the source page
- do not assume a bare number is SGD unless the listing clearly indicates SGD
- if the listing uses USD or another currency, convert it to SGD before storing
  comparison values
- store normalized comparison values in `data/listing_facts.csv`
- if currency is ambiguous, treat the amount as unresolved and do not mark the
  listing as within budget yet

## Session Metadata Rule

All canonical listing files should carry:

- `session_id`
- `batch_id`
- `created_at`
- `updated_at`

This is the project-safe way to delimit old and new data without creating
separate CSVs per session or inserting fake header rows into a dataset.
