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

Session:
session_id = [SESSION ID]
batch_id = [BATCH ID]

Scope:
[what is in scope]
[what is out of scope]

Method:
Follow `docs/project-guide.md`, `docs/scoring-system.md`, and
`docs/smu-guidance.md`.
Use `docs/data-dictionary.md` for allowed field values.
Use canonical project files only.
Before editing any row, read its current lifecycle state and avoid writing
backward over later-phase work.
Every mission must preserve `session_id`, `batch_id`, `created_at`, and
`updated_at` discipline in any file it edits.
At the end of every mission, append a memory entry to the correct log:
- `docs/agent-context-log.md` for durable research memory
- `docs/ops-log.md` for repo/session mechanics

Deliverables:
[files to update]
[summary to return]
[memory log entry to append]

Stop rule:
[when to stop]
```

## Phase Map

### Phase 1: Source Audit

Goal:

- decide whether each source is approved, conditional, or rejected

Primary file:

- `data/source_registry.csv`

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
Do not expand beyond the current in-scope source set already approved by the
user or listed in `data/source_registry.csv`.
Do not extract listings yet.

Method:
Follow `docs/project-guide.md` and `docs/smu-guidance.md`.
Do source-level trust review only.
Check operator identity, current activity, business model, complaint surface,
semester-stay plausibility, and student-pass plausibility.

Deliverables:
Update `data/source_registry.csv`.
Return a concise source-by-source summary with: approved / conditional /
rejected, plus unresolved concerns.
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop after all listed sources are audited.
```

Audit gate:

- Run a Phase 1 audit using `docs/audit-guide.md` before any listed sources move
  into Phase 2 extraction.

### Phase 2: Listing Extraction

Goal:

- enumerate all plausible room or unit options from approved sources

Primary file:

- `data/listing_facts.csv`

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
Before editing, read the current `phase_state` for any existing listing rows and
do not overwrite later-phase data with extraction-stage assumptions.
For every listing captured, store the exact deep link to that listing or room
page in `exact_listing_url`. Do not use a homepage, category page, or general
operator page when a listing-specific URL exists.
Identify the source currency shown for the listing and normalize all budget
comparisons to SGD. Do not assume raw prices are SGD if the source uses USD or
another currency.
Assign an explicit `session_id` and `batch_id` for every new row you add.
Do not edit `data/listing_decisions.csv` or `data/listing_scores_long.csv`
during extraction.
Do not touch rows that already belong to later phases except to strengthen an
exact listing URL or factual field without changing their decision state.

Deliverables:
Update `data/listing_facts.csv` with one row per plausible listing.
Ensure every captured listing row includes the exact listing URL whenever one
exists and a `listing_url_quality` value.
Return how many plausible options were found per source and what the main
missing facts are.
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop after all plausible options from the named sources are logged.
```

Audit gate:

- Run a Phase 2 audit using `docs/audit-guide.md` before any extracted listings
  move into hard-filter verification.

### Phase 3: Hard-Filter Verification

Goal:

- determine which listings pass, fail, or remain TBD on hard filters

Primary files:

- `data/listing_facts.csv`
- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`

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
Before editing, read the current `phase_state` and `hard_filter_status` for
each listing and do not loosen an existing failure without stronger evidence.
Check hard filters only: dates, price cap, commute cap, student-pass
compatibility, semester-stay acceptance, private room, bed size, desk, natural
light, apartment-level AC, laundry, and trust-critical items.
Use the exact listing URL already stored in `data/listing_facts.csv`.
If the row only has a homepage or generic URL, replace it with the exact
listing-level URL before continuing when possible.
Before evaluating the budget cap, verify the listing currency and convert the
price to SGD. If currency is ambiguous, leave budget status unresolved rather
than assuming SGD.

Deliverables:
Update `data/listing_scores_long.csv`.
Update hard-filter state in `data/listing_decisions.csv`.
Update `data/listing_facts.csv` only when factual fields become stronger.
Return which listings passed, failed, or remain TBD.
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop after all listed IDs have hard-filter outcomes recorded.
```

Audit gate:

- Run a Phase 3 audit using `docs/audit-guide.md` before any listing moves into
  full verification or scoring.

### Phase 4: Full Listing Verification

Goal:

- gather the deeper factual and trust evidence needed for scoring

Primary files:

- `data/listing_facts.csv`
- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`

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
Before editing, read the current `phase_state` and preserve any existing
hard-filter result unless stronger evidence supports a change.
Verify exact price structure, deposits, utilities, bed, desk, AC, laundry,
natural light, guest-policy evidence, lease clarity, operator identity, and
property-control evidence.
Work from the exact listing URL, not a homepage, whenever available.
Verify the displayed currency and record comparison-ready amounts in SGD. Do
not treat USD or other currencies as SGD.

Deliverables:
Update `data/listing_scores_long.csv` with evidence-backed notes where possible.
Update `data/listing_facts.csv` when factual fields become stronger.
Update `data/listing_decisions.csv` with key strengths, concerns, and next
action if useful.
Return a concise strengths / weaknesses / unknowns summary for each listing.
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop after all listed IDs have a full verification pass.
```

Audit gate:

- Run a Phase 4 audit using `docs/audit-guide.md` before any listing moves into
  visual review, scoring, or ranking.

### Phase 5: Visual Review

Goal:

- review images for space, light, condition, and actual livability

Primary files:

- `data/listing_facts.csv`
- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`

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
Before editing, read the current `phase_state` and keep visual notes additive.
Focus on usable floor space, desk presence, bed plausibility, windows, daylight,
room feel, bathroom/kitchen condition, visible maintenance issues, and photo
consistency.
Use the exact listing URL already stored for the listing whenever available.

Deliverables:
Update supporting evidence notes in `data/listing_scores_long.csv` where
relevant.
Update factual daylight / room-quality fields in `data/listing_facts.csv` when
the images support it.
Update `data/listing_decisions.csv` with concise visual strengths and concerns
if useful.
Return a visual assessment for each listing.
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop after all listed IDs have visual evidence notes.
```

Audit gate:

- Run a Phase 5 audit using `docs/audit-guide.md` before visual conclusions are
  treated as scoring evidence.

### Phase 6: Scoring

Goal:

- assign criterion-level scores and update the listing dashboard

Primary files:

- `data/listing_scores_long.csv`
- `data/listing_decisions.csv`

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
Before editing, read the current `current_phase_state`, `hard_filter_status`,
and `rankable_status` in `data/listing_decisions.csv`.
Do not invent facts.
Apply penalties only when supported by evidence.
If a listing lacks an exact listing URL in `data/listing_facts.csv`,
flag that as an evidence-quality concern.
Use only normalized SGD values for budget scoring and ideal-band scoring. If the
listing currency is ambiguous or unverified, treat the cost score as unresolved
instead of assuming SGD.
If a listing remains `hard_filter_tbd` but is still worth manual review, score
its non-hard-filter criteria provisionally for comparison and keep the listing
status unchanged in `data/listing_decisions.csv`.

Deliverables:
Update `data/listing_scores_long.csv`.
Update `data/listing_decisions.csv`.
Return a concise explanation of the major score drivers for each listing and
state when a score is provisional because hard filters remain unresolved.
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop after all listed IDs are scored and summarized.
```

Audit gate:

- Run a Phase 6 audit using `docs/audit-guide.md` before any scored listings
  are used for ranking.

### Phase 7: Ranking

Goal:

- compare current survivors and produce the best shortlist candidates

Primary file:

- `data/listing_decisions.csv`

Parallelization:

- usually no
- this is a synthesis phase and is better handled by one agent

Copy-paste prompt:

```md
Mission:
Rank all currently scored and non-eliminated listings and identify the
strongest candidates.

Scope:
Use only the listings already present in `data/listing_decisions.csv`.
Do not search new sources or new listings.

Method:
Follow `docs/project-guide.md` and `docs/scoring-system.md`.
Before editing, read the current `hard_filter_status` and `rankable_status` for
every listing in scope.
Prioritize fit, evidence quality, and low unresolved risk.
Do not let a high raw score override weak trust.
Use normalized SGD values for all price comparisons. If two listings are shown
in different currencies, compare only after conversion to SGD. If a listing's
currency remains ambiguous, flag it and prevent it from outranking clearly
priced listings on cost.

Deliverables:
Update `data/listing_decisions.csv` with ranking or shortlist notes if needed.
Return a ranked summary with key tradeoffs, top candidates, and backup options.
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop once the current ranking summary is complete.
```

Audit gate:

- Run a Phase 7 audit using `docs/audit-guide.md` before any ranked shortlist is
  treated as decision-ready.

### Phase 8: Exhaustion Check

Goal:

- determine whether the 15-source SMU pack is fully worked

Primary files:

- `data/source_registry.csv`
- `data/listing_facts.csv`
- `data/listing_decisions.csv`

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
Append a durable memory entry to `docs/agent-context-log.md`.

Stop rule:
Stop once exhaustion status is clear.
```

Audit gate:

- Run a Phase 8 audit using `docs/audit-guide.md` before declaring the current
  source pack exhausted.

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
- having one agent mutate `data/listing_facts.csv` for a batch while another
  agent scores or ranks the same batch

## Compute Strategy

- use low compute for obvious rejects and duplicates
- use medium compute for source audits and factual extraction
- use high compute only for ambiguous trust cases and top-candidate visual
  review

## Hard Rules

- do not expand beyond the current user-approved source set until explicitly
  allowed
- do not invent missing facts
- do not treat polished marketing as proof
- do not let source trust substitute for listing trust
- do not use session-separated CSVs or fake header rows inside a dataset;
  delimit sessions with metadata columns instead
- do not finish a mission without logging memory in the appropriate log file
