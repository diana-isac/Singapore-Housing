# Scoring System

## Canonical Files

- `data/criteria_weights.csv`
- `data/listings_scores.csv`
- `data/listings_score_summary.csv`

## Model

### Criteria Registry

`data/criteria_weights.csv` is the source of truth for:

- criterion IDs
- category membership
- hard-filter status
- point caps
- category totals

### Listing Scores

`data/listings_scores.csv` is the detailed audit sheet.

- one row per listing criterion
- hard filters use `hard_filter_pass`
- scored criteria use `points_awarded`
- penalty rows use negative or zero scores where applicable

### Summary Dashboard

`data/listings_score_summary.csv` is the dashboard.

- one row per listing
- also serves as the row-per-listing intake surface
- holds the core raw facts needed for extraction and comparison
- category subtotals
- total positive score
- penalty totals
- final score after penalties
- strengths, concerns, next action

## Execution Rules

1. Hard filters are checked before scoring.
2. Unknown facts remain unknown.
3. High score does not override trust problems.
4. Listing-level trust can still fail on a trusted source.
5. Summary ranking must be traceable back to detailed rows.
6. Budget comparisons must use normalized SGD values, not raw displayed values
   in mixed currencies.

## Currency Rule

Before any budget check, scoring pass, or ranking comparison:

- identify the displayed currency on the source page
- do not assume a bare number is SGD unless the listing clearly indicates SGD
- if the listing uses USD or another currency, convert it to SGD before storing
  comparison values
- store the normalized all-in amount in SGD in
  `data/listings_score_summary.csv`
- if currency is ambiguous, treat the amount as unresolved and do not mark the
  listing as within budget yet
