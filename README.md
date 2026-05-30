# Singapore Housing Search

This repo is the operating system for finding, verifying, scoring, and
shortlisting Singapore housing for the SMU study period from August 9, 2026 to
December 6-10, 2026.

## Minimal Structure

### Core Docs

- `docs/project-guide.md`: end-to-end workflow and project logic
- `docs/scoring-system.md`: how the scoring files work
- `docs/agent-guide.md`: how agents should execute bounded missions
- `docs/smu-guidance.md`: distilled SMU housing rules and cautions

### Working Data

- `data/user-profile.template.md`: user requirements
- `data/source-registry.csv`: source-level trust decisions
- `data/criteria_weights.csv`: canonical criteria registry
- `data/listings_scores.csv`: detailed scoring audit trail
- `data/listings_score_summary.csv`: one-row-per-listing intake, dashboard, and shortlist surface

### References

- `references/smu_housing_list.pdf`
- `references/smu_housing_list.txt`
- `references/smu_accommodation_tips.pdf`
- `references/smu_accommodation_tips.txt`

### Templates

- `templates/source-audit-template.md`
- `templates/listing-evaluation-template.md`
- `templates/outreach-template.md`

## Current Research Boundary

Only the 15 sources listed in `references/smu_housing_list.pdf` are in active
scope until they are fully exhausted. Shortlist decisions should now be tracked
directly in `data/listings_score_summary.csv`.
