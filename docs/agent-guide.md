# Agent Guide

## Purpose

This is the compact mission manual for running the full housing workflow from
source audit to final ranking.

Use one phase at a time. Do not ask an agent to do the whole project in one
run.

## Default Mission Skeleton

```md
Mission:
[exact task]

Scope:
[what is in scope]
[what is out of scope]

Method:
Follow `docs/project-guide.md`, `docs/scoring-system.md`, and
`docs/smu-guidance.md`.
Use canonical project files only.

Deliverables:
[files to update]
[summary to return]

Stop rule:
[when to stop]
```

## Phase Map

### Phase 1: Source Audit

Goal:

- decide whether each source is approved, conditional, or rejected

Primary file:

- `data/source-registry.csv`

Parallelization:

- yes, by splitting named sources across agents
- safe because this phase is source-level only

Copy-paste prompt:

```md
Mission:
Audit the following sources for source-level trust and semester suitability:
[SOURCE NAMES].

Scope:
Only use these named sources from `references/smu_housing_list.pdf`.
Do not expand beyond the 15 SMU PDF-listed sources.
Do not extract listings yet.

Method:
Follow `docs/project-guide.md` and `docs/smu-guidance.md`.
Do source-level trust review only.
Check operator identity, current activity, business model, complaint surface,
semester-stay plausibility, and student-pass plausibility.

Deliverables:
Update `data/source-registry.csv`.
Return a concise source-by-source summary with: approved / conditional /
rejected, plus unresolved concerns.

Stop rule:
Stop after all listed sources are audited.
```

### Phase 2: Listing Extraction

Goal:

- enumerate all plausible room or unit options from approved sources

Primary file:

- `data/listings_score_summary.csv`

Parallelization:

- yes, by source
- each agent should own one or a few approved sources

Copy-paste prompt:

```md
Mission:
Extract all plausible room or listing options from the following approved
sources: [SOURCE NAMES].

Scope:
Only use these sources.
Do not score yet.
Do not search outside the approved sources named here.

Method:
Follow `docs/project-guide.md`.
Capture only options plausibly relevant to the semester stay and user profile.
Leave unknowns explicit.

Deliverables:
Update `data/listings_score_summary.csv` with one row per plausible listing.
Return how many plausible options were found per source and what the main
missing facts are.

Stop rule:
Stop after all plausible options from the named sources are logged.
```

### Phase 3: Hard-Filter Verification

Goal:

- determine which listings pass, fail, or remain TBD on hard filters

Primary files:

- `data/listings_scores.csv`
- `data/listings_score_summary.csv`

Parallelization:

- yes, by listing ID batches
- use only after Phase 2 intake exists

Copy-paste prompt:

```md
Mission:
Verify hard filters for the following listings: [LISTING IDS].

Scope:
Only work on these listing IDs.
Do not search for new sources or new listings.
Do not score non-hard-filter criteria yet.

Method:
Follow `docs/project-guide.md`, `docs/scoring-system.md`, and
`docs/smu-guidance.md`.
Check hard filters only: dates, price cap, commute cap, student-pass
compatibility, semester-stay acceptance, private room, bed size, desk, natural
light, apartment-level AC, laundry, and trust-critical items.

Deliverables:
Update `data/listings_scores.csv`.
Update top-level hard-filter status notes in `data/listings_score_summary.csv`
if needed.
Return which listings passed, failed, or remain TBD.

Stop rule:
Stop after all listed IDs have hard-filter outcomes recorded.
```

### Phase 4: Full Listing Verification

Goal:

- gather the deeper factual and trust evidence needed for scoring

Primary files:

- `data/listings_scores.csv`
- `data/listings_score_summary.csv`

Parallelization:

- yes, by listing ID batches
- best used only on listings that survived hard-filter review

Copy-paste prompt:

```md
Mission:
Perform full listing verification for the following listings: [LISTING IDS].

Scope:
Only work on these listing IDs.
Do not add new listings.
Do not rank yet.

Method:
Follow `docs/project-guide.md`, `docs/scoring-system.md`, and
`docs/smu-guidance.md`.
Verify exact price structure, deposits, utilities, bed, desk, AC, laundry,
natural light, guest-policy evidence, lease clarity, operator identity, and
property-control evidence.

Deliverables:
Update `data/listings_scores.csv` with evidence-backed notes where possible.
Update `data/listings_score_summary.csv` with key strengths, concerns, and next
action if useful.
Return a concise strengths / weaknesses / unknowns summary for each listing.

Stop rule:
Stop after all listed IDs have a full verification pass.
```

### Phase 5: Visual Review

Goal:

- review images for space, light, condition, and actual livability

Primary files:

- `data/listings_scores.csv`
- `data/listings_score_summary.csv`

Parallelization:

- yes, by listing ID batches
- high-value mostly for finalists or visually ambiguous options

Copy-paste prompt:

```md
Mission:
Perform a visual review of the following listings: [LISTING IDS].

Scope:
Only review these listing IDs.
Do not search new listings or sources.

Method:
Follow `docs/project-guide.md`.
Focus on usable floor space, desk presence, bed plausibility, windows, daylight,
room feel, bathroom/kitchen condition, visible maintenance issues, and photo
consistency.

Deliverables:
Update supporting evidence notes in `data/listings_scores.csv` where relevant.
Update `data/listings_score_summary.csv` with concise visual strengths and
concerns if useful.
Return a visual assessment for each listing.

Stop rule:
Stop after all listed IDs have visual evidence notes.
```

### Phase 6: Scoring

Goal:

- assign criterion-level scores and update the listing dashboard

Primary files:

- `data/listings_scores.csv`
- `data/listings_score_summary.csv`

Parallelization:

- yes, by listing ID batches
- only after enough evidence exists

Copy-paste prompt:

```md
Mission:
Score the following listings using the canonical scoring model: [LISTING IDS].

Scope:
Only work on these listing IDs.
Do not search for new sources or new listings.

Method:
Follow `docs/scoring-system.md`.
Use `data/criteria_weights.csv` as the source of truth.
Do not invent facts.
Apply penalties only when supported by evidence.

Deliverables:
Update `data/listings_scores.csv`.
Update `data/listings_score_summary.csv`.
Return a concise explanation of the major score drivers for each listing.

Stop rule:
Stop after all listed IDs are scored and summarized.
```

### Phase 7: Ranking

Goal:

- compare current survivors and produce the best shortlist candidates

Primary file:

- `data/listings_score_summary.csv`

Parallelization:

- usually no
- this is a synthesis phase and is better handled by one agent

Copy-paste prompt:

```md
Mission:
Rank all currently scored and non-eliminated listings and identify the
strongest candidates.

Scope:
Use only the listings already present in `data/listings_score_summary.csv`.
Do not search new sources or new listings.

Method:
Follow `docs/project-guide.md` and `docs/scoring-system.md`.
Prioritize fit, evidence quality, and low unresolved risk.
Do not let a high raw score override weak trust.

Deliverables:
Update `data/listings_score_summary.csv` with final status notes if needed.
Return a ranked summary with key tradeoffs, top candidates, and backup options.

Stop rule:
Stop once the current ranking summary is complete.
```

### Phase 8: Exhaustion Check

Goal:

- determine whether the 15-source SMU pack is fully worked

Primary files:

- `data/source-registry.csv`
- `data/listings_score_summary.csv`

Parallelization:

- no
- one synthesis pass is enough

Copy-paste prompt:

```md
Mission:
Check whether the 15-source SMU PDF source pack has been fully exhausted.

Scope:
Only assess the current source pack and current project files.
Do not search new sources.

Method:
Follow `docs/project-guide.md`.
Check whether every source was audited, every approved source was searched, and
every plausible listing was logged and processed.

Deliverables:
Return a direct yes/no answer and list exactly what remains unfinished, if
anything.

Stop rule:
Stop once exhaustion status is clear.
```

## Parallel Orchestration Rules

### Good Parallelization

- Phase 1 by source groups
- Phase 2 by approved source
- Phase 3 by listing ID batch
- Phase 4 by listing ID batch
- Phase 5 by listing ID batch
- Phase 6 by listing ID batch

### Bad Parallelization

- Phase 7 ranking split across many agents
- changing the scoring schema mid-run
- having multiple agents edit the same listing IDs at once

## Compute Strategy

- use low compute for obvious rejects and duplicates
- use medium compute for source audits and factual extraction
- use high compute only for ambiguous trust cases and top-candidate visual
  review

## Hard Rules

- do not expand beyond the 15 SMU PDF-listed sources until explicitly allowed
- do not invent missing facts
- do not treat polished marketing as proof
- do not let source trust substitute for listing trust
