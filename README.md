# Singapore Housing Search

This repo is the operating system for finding, verifying, scoring, and
shortlisting Singapore housing for the SMU study period from August 9, 2026 to
December 6-10, 2026.

## Minimal Structure

### Core Docs

- `docs/project-guide.md`: end-to-end workflow and project logic
- `docs/scoring-system.md`: how the scoring files work
- `docs/agent-guide.md`: how agents should execute bounded missions
- `docs/audit-guide.md`: quality gate for every completed phase
- `docs/agent-context-log.md`: append-only cross-session execution memory
- `docs/data-dictionary.md`: controlled vocabularies and field meanings
- `docs/smu-guidance.md`: distilled SMU housing rules and cautions

### Validation

- `scripts/validate-project.ps1`: repeatable structural validation for metadata,
  lifecycle consistency, and ranking safety
- `scripts/generate-human-output.ps1`: generates the final human-facing
  deliverable CSV

### Working Data

- `data/user-profile.md`: user requirements
- `data/source_registry.csv`: source-level trust decisions
- `data/criteria_weights.csv`: canonical criteria registry
- `data/listing_facts.csv`: one row per listing with factual intake only
- `data/listing_scores_long.csv`: one row per listing criterion with detailed scoring evidence
- `data/listing_decisions.csv`: one row per listing with lifecycle state, hard-filter result, and score rollups
- `data/listing_output_human.csv`: final plain CSV for human review

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

Active scope includes the 15 sources listed in `references/smu_housing_list.pdf`
plus any additional sources explicitly added by the user to
`data/source_registry.csv`.

## Operating Rule

The machine-readable files are phase-specific and agent-facing.

Do not force them to double as a human dashboard during the research workflow.
The human-facing deliverable should be generated only after the machine files
and audits are complete. The current human-facing deliverable is
`data/listing_output_human.csv`.
