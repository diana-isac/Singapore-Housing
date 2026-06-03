# Audit Guide

## Purpose

Use this document to run a strict quality audit after any mission phase.

The audit agent is not there to do new research unless needed to verify a
claim. Its job is to inspect the completed work, find gaps, and decide whether
the phase output is:

- `pass`
- `pass_with_minor_gaps`
- `fail_rework_required`

This guide is designed to keep quality high, keep standards consistent across
agents, and stop weak phase outputs from contaminating the later ranking.

## Audit Principles

- Audit against the actual project rules, not against guesswork.
- Prefer concrete evidence over narrative confidence.
- Treat missing facts as missing facts, not as assumed positives.
- Exact listing URLs matter.
- Currency must be identified before any budget judgment.
- A source being approved does not make a listing approved.
- A high score with weak evidence is not high-quality work.
- If you find a material contradiction, flag it explicitly.

## Canonical References

Always audit against:

- `docs/project-guide.md`
- `docs/scoring-system.md`
- `docs/smu-guidance.md`
- `docs/agent-guide.md`
- `docs/data-dictionary.md`
- `data/user-profile.md`
- `data/criteria_weights.csv`
- `data/source_registry.csv`
- `data/listing_facts.csv`
- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`
- `docs/agent-context-log.md`
- `docs/ops-log.md`

## Audit Output Standard

Every audit result must include:

- audited phase
- scope audited
- verdict: `pass`, `pass_with_minor_gaps`, or `fail_rework_required`
- exact issues found
- severity for each issue: `high`, `medium`, or `low`
- exact files and listing IDs or source names affected
- exact correction required
- whether the issue blocks the next phase
- whether required memory logging was completed correctly

## Severity Rules

### High

Use `high` when the issue can change elimination, scoring, ranking, trust
status, or shortlist quality.

Examples:

- wrong currency assumption
- missing exact listing URL
- listing marked under budget when it is over budget
- hard-filter pass with no evidence
- listing-specific claim supported only by source-level evidence
- listing scored as if cleared even though hard filters are unresolved

### Medium

Use `medium` when the issue weakens reliability but does not necessarily invert
the current decision.

Examples:

- incomplete evidence summary
- weak commute support
- incomplete fee notes
- summary row not aligned with detail row
- visual observations too vague to be useful

### Low

Use `low` for formatting, naming, or non-blocking hygiene issues.

Examples:

- wording inconsistency
- small note missing in context log
- minor schema-field cleanliness issue

## Universal Audit Checks

Run these checks for every audited phase.

### 1. Scope Check

- Was the agent within the requested scope?
- Did it stay within the approved source boundary?
- Did it avoid doing later-phase work without instruction?

### 2. File Discipline Check

- Were only the intended canonical files updated?
- Were updates written to the correct file for that phase?
- Did the work avoid creating side systems or shadow notes?

### 3. Evidence Check

- Does each material claim have evidence?
- Are listing claims tied to exact listing URLs when available?
- Are unknowns left explicit instead of being guessed?

### 4. Consistency Check

- Do summary and detailed files agree?
- Do notes match statuses?
- Do hard-filter results align with the user profile and criteria file?
- Do lifecycle states and rankability states agree with each other?

### 5. Progression Check

- Is the output strong enough for the next phase?
- If not, what exact rework is needed before progressing?

### 6. State-Transition Check

- Did the listing move only through allowed lifecycle transitions?
- Did any row skip required audit or verification gates?
- Did any earlier-phase mission overwrite a later-phase state?

Allowed transitions:

- `phase2_extracted -> phase3_hard_filter_reviewed`
- `phase3_hard_filter_reviewed -> phase6_scored_provisional`
- `phase3_hard_filter_reviewed -> phase6_scored_final`
- `phase3_hard_filter_reviewed -> phase6_scored_failed`
- `phase6_scored_provisional -> phase6_scored_final`
- `phase6_scored_provisional -> phase6_scored_failed`

### 7. Memory Logging Check

- Did the mission append durable research context to
  `docs/agent-context-log.md` when it changed research state?
- Did the mission append repo/session mechanics to `docs/ops-log.md` when it
  changed architecture, validation, tooling, or sync state?
- Are the log entries concise and useful for future agents?

## Phase-Specific Audit Checks

## Phase 1 Audit - Source Audit

Check:

- every source in scope was reviewed
- source status is one of `approved`, `conditional`, `rejected`
- source-level reasoning is clear
- source trust is not confused with listing trust
- source row notes mention operator identity and model
- source metadata such as `session_id`, `batch_id`, and `scope_origin` are
  preserved
- semester-stay plausibility is assessed
- student-pass plausibility is assessed
- scam or complaint surface is noted where relevant

Fail if:

- a source has a status with no reasoning
- a source is approved based only on brand familiarity
- listing-level claims are written as source-level facts

## Phase 2 Audit - Listing Extraction

Check:

- each extracted listing has one row in `data/listing_facts.csv`
- exact listing deep link is stored when available
- homepage or category page is only used when no listing page exists
- source currency is identified
- monthly rent is normalized into SGD
- session and batch metadata are present
- important raw fields are captured when visible
- extracted listings are plausible for the user profile and research scope

Fail if:

- listing URL is generic when a listing-specific URL exists
- currency is assumed rather than identified
- extracted rows omit obvious factual data from the listing page
- non-plausible listings are bulk-added without triage

## Phase 3 Audit - Hard-Filter Verification

Check:

- hard-filter decisions are evidence-backed
- budget cap uses the correct current threshold
- commute cap uses the correct current threshold
- semester stay acceptance is checked
- student pass acceptance is checked
- private room, bed size, desk, window, AC, and laundry are checked
- hard-filter fails are reflected in listing status
- `data/listing_scores_long.csv` and `data/listing_decisions.csv` agree
- `phase_state` or `current_phase_state` must be at least
  `phase3_hard_filter_reviewed`

Fail if:

- a listing above the hard budget cap is not failed or clearly marked unresolved
- a hard filter is marked pass based on inference alone
- summary status and score file disagree on pass/fail

## Phase 4 Audit - Full Listing Verification

Check:

- deposits are captured correctly
- hidden fees and unclear fee surfaces are noted
- utilities inclusion is explicit, not assumed
- kitchen and bathroom setup are accurately represented
- guest policy is only penalized when explicit evidence exists
- landlord-on-site / peer-living setup is recorded when known
- trust concerns are listing-specific

Fail if:

- fees are understated
- utilities are marked included without evidence
- guest restrictions are invented from silence

## Phase 5 Audit - Visual Review

Check:

- visual notes are tied to actual images
- usable-space observations are concrete
- daylight and window claims are visually justified
- maintenance risks are noted when visible
- photos are not over-trusted when they conflict with text
- missing photos are treated as evidence weakness

Fail if:

- visual claims are generic and unsupported
- room quality is scored from photos that were not actually inspected
- wide-angle distortion is ignored when it materially affects perception

## Phase 6 Audit - Scoring

Check:

- `data/criteria_weights.csv` is used correctly
- points do not exceed allowed maximums
- hard filters are not scored as positive points
- penalties are only applied with evidence
- score logic matches the user profile and current rules
- evidence quality is strong enough for each material score
- provisional scores on `hard_filter_tbd` listings stay clearly labeled and do
  not overwrite the unresolved hard-filter status
- score rollups in `data/listing_decisions.csv` match the underlying rows in
  `data/listing_scores_long.csv`
- `current_phase_state` must be `phase6_scored_provisional`,
  `phase6_scored_final`, or `phase6_scored_failed`

Fail if:

- scoring is done before hard-filter review is ready
- unresolved listings are presented as fully cleared because of provisional
  scores
- budget scoring uses the wrong currency or wrong cap
- score file and summary file disagree materially

## Phase 7 Audit - Ranking And Shortlist

Check:

- only non-eliminated or intentionally flagged reference listings are ranked as
  viable candidates
- only listings with an appropriate `rankable_status` are treated as viable
- ranking reflects user priorities
- over-budget listings are not presented as normal viable options
- ranking notes explain the main tradeoffs
- shortlist quality is not inflated by weakly verified listings

Fail if:

- ranking ignores hard-filter failure
- an over-budget or low-trust listing is surfaced as a top candidate without a
  clear warning
- ranking is detached from the scoring and evidence record

## Phase 8 Audit - Exhaustion And Expansion Control

Check:

- in-scope sources were actually exhausted
- the exhaustion claim is supported by the context log, source registry, and
  listing facts/decisions
- no out-of-scope expansion happened without explicit approval

Fail if:

- the agent claims exhaustion while sources remain unsearched
- new sources were added without approval

## Phase 9 Audit - Outreach And Manual Follow-Up

Check:

- unresolved questions are concrete and worth asking
- outreach asks for missing decision-critical information
- manual follow-up is prioritized by importance

Fail if:

- outreach is vague
- questions do not close actual blockers

## CSV Integrity Checks

When auditing data files, always verify:

- no duplicate listing IDs unless intentional and documented
- no duplicate source names unless intentional and documented
- exact listing URLs are preserved
- status fields use the expected vocabulary
- numeric budget fields are normalized to SGD
- session and batch metadata are present where required
- `phase_state` and `hard_filter_status` do not contradict each other
- `phase_state` and `current_phase_state` do not contradict each other
- no earlier-phase mission has overwritten a later-phase state
- detail and decision files do not contradict each other

## Repeatable Validation

Use:

- `scripts/validate-project.ps1`

This script checks:

- metadata presence
- lifecycle consistency
- rankability safety
- over-budget handling
- file-to-file listing ID alignment

## Rework Rules

If verdict is `fail_rework_required`, the auditor must specify:

- exact file to fix
- exact rows, listing IDs, or sources to fix
- exact issue
- exact expected correction
- whether re-audit is required before moving on

Do not just say `needs cleanup`.

## Copy-Paste Audit Prompt

```md
Mission:
Audit the completed work for [PHASE NAME].

Scope:
Audit only the following sources, listings, or files: [SCOPE].
Do not do new broad research. Only verify additional facts if required to test
whether an existing claim is valid.

Method:
Follow `docs/audit-guide.md`, `docs/project-guide.md`,
`docs/scoring-system.md`, `docs/smu-guidance.md`, and
`data/user-profile.md`.
Audit for structure, completeness, correctness, evidence quality, and
consistency.
Treat missing facts as unknown, not as pass conditions.

Deliverables:
Return:
- verdict: pass / pass_with_minor_gaps / fail_rework_required
- findings ordered by severity
- exact files and rows or listing IDs affected
- exact fixes required
- whether the work is ready for the next phase

If you make any factual correction during audit, update the relevant canonical
file and state exactly what changed.

Stop rule:
Stop after the audit is complete and the verdict is clear.
```

## Short Audit Prompt

Use this when you want a lighter audit pass:

```md
Audit [PHASE NAME] for correctness, completeness, evidence quality, and
consistency using `docs/audit-guide.md`. Return a verdict, findings by
severity, exact fixes required, and readiness for the next phase.
```
