# Improvement Backlog

Purpose: track the project improvements needed to reach a more professional,
stable multi-agent workflow.

Status vocabulary:

- `resolved`
- `in_progress`
- `pending`
- `blocked`

## A. Architecture And State Management

### A01 - Split overloaded listing sheet into phase-specific machine files
- Status: `resolved`
- Why it mattered: one file was serving as intake, verification surface, scoring
  surface, dashboard, and shortlist surface at once
- Resolution: introduced `data/listing_facts.csv`,
  `data/listing_scores_long.csv`, and `data/listing_decisions.csv`

### A02 - Add explicit lifecycle state per listing
- Status: `resolved`
- Why it mattered: agents were inferring readiness indirectly from mixed fields
- Resolution: introduced `phase_state` in `data/listing_facts.csv` and
  `current_phase_state` in `data/listing_decisions.csv`

### A03 - Add session and batch metadata instead of separate CSVs per session
- Status: `resolved`
- Why it mattered: session-level mixing was becoming hard to trace
- Resolution: introduced `session_id`, `batch_id`, `created_at`, and
  `updated_at` in all canonical machine files

### A04 - Make ranking readiness explicit
- Status: `resolved`
- Why it mattered: unresolved listings could drift into ranking
- Resolution: introduced `rankable_status` and `needs_manual_followup` in
  `data/listing_decisions.csv`

### A05 - Create a separate human deliverable surface
- Status: `resolved`
- Why it matters: the current machine files are intentionally agent-first and
  not optimized for final human readability
- Resolution: added `data/listing_output_human.csv` and
  `scripts/generate-human-output.ps1`

## B. Prompting And Workflow Control

### B01 - Tighten phase prompts around file ownership
- Status: `resolved`
- Why it mattered: agents were writing multiple workflow meanings into the same
  surface
- Resolution: phase prompts now point to the correct canonical files by role

### B02 - Require session-aware edits
- Status: `resolved`
- Why it mattered: future work needs stable traceability across runs
- Resolution: agent guide now requires metadata discipline for mission edits

### B03 - Prevent simultaneous edits on the same listing batch
- Status: `resolved`
- Why it mattered: later agents were colliding with newly added data
- Resolution: agent guide now treats same-batch concurrent editing as bad
  parallelization

### B04 - Add stricter transition gates between phases
- Status: `resolved`
- Why it matters: current lifecycle states exist, but phase-entry checks are
  still mostly prompt-driven rather than validator-driven
- Resolution: prompt docs and audit guide now define explicit transition
  expectations, lifecycle checks, and audit gates between phases

## C. Data Model And Currency Handling

### C01 - Normalize mixed score strings into numeric machine fields
- Status: `resolved`
- Why it mattered: values like `59/95` were hard to validate and automate
- Resolution: decisions file now stores numeric earned and possible values

### C02 - Store both SGD and USD where useful, while scoring only in SGD
- Status: `resolved`
- Why it mattered: the user wants human-readable dual-currency review, but the
  model needs one canonical scoring currency
- Resolution: listing facts now store normalized SGD and USD companion values;
  user profile now includes both bands and cap in both currencies

### C03 - Track FX reference metadata
- Status: `resolved`
- Why it mattered: converted USD values need a transparent basis
- Resolution: listing facts include `fx_rate_sgd_to_usd` and `fx_rate_date`

### C04 - Add stronger controlled vocabularies
- Status: `resolved`
- Why it matters: fields like `evidence_quality`, `guest_policy`, and
  `natural_light_quality` still rely on loose text values
- Resolution: added `docs/data-dictionary.md` with controlled vocabularies for
  lifecycle, rankability, quality, and metadata fields

## D. Audit And Quality Control

### D01 - Audit against new canonical architecture
- Status: `resolved`
- Why it mattered: audit rules were still tied to the legacy files
- Resolution: `docs/audit-guide.md` now references `source_registry`,
  `listing_facts`, `listing_scores_long`, and `listing_decisions`

### D02 - Add lifecycle-consistency audit checks
- Status: `resolved`
- Why it matters: the new state model should be machine-checked, not only
  assumed
- Resolution: expanded `docs/audit-guide.md` with explicit state-transition and
  lifecycle-consistency checks

### D03 - Add validation script or repeatable checks
- Status: `resolved`
- Why it matters: the project still relies heavily on manual inspection for
  structural correctness
- Resolution: added `scripts/validate-project.ps1` for row alignment, metadata,
  lifecycle, and ranking-safety validation

## E. Documentation And Operating Memory

### E01 - Keep architecture docs aligned with canonical files
- Status: `resolved`
- Why it mattered: old and new file names were drifting
- Resolution: updated README and core docs to the new machine-file model

### E02 - Separate durable research memory from transient git/session notes
- Status: `resolved`
- Why it matters: `docs/agent-context-log.md` currently mixes workflow memory
  with repo-sync notes
- Resolution: split durable memory into `docs/agent-context-log.md` and repo /
  session mechanics into `docs/ops-log.md`; made logging mandatory in prompts,
  workflow docs, and audit checks

## F. Next Recommended Order

No remaining non-deliverable backlog items are currently required before normal
research work resumes.
