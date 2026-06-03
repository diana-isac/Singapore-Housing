# Research Memory

Purpose: durable cross-session memory for housing research and workflow-relevant
knowledge that future agents should inherit.

Usage rules:
- Append, do not rewrite history unless correcting a factual error.
- Add the newest update at the top of the relevant phase section.
- Keep entries concise and operational.
- Reference exact files changed.
- Reference exact sources or listing IDs when relevant.
- If a phase is blocked, state the blocker and the next required action.
- Legacy file names appearing in older entries refer to the pre-2026-06-03
  architecture and are historical only.
- Keep this file focused on durable research memory, not repo mechanics.
- Put git, sync, validator, and migration notes in `docs/ops-log.md`.

Entry template:

```md
### YYYY-MM-DD - Agent / Mission Name
- Scope:
- Actions completed:
- Files updated:
- Sources or listings covered:
- Key findings:
- Blockers:
- Next recommended step:
```

## Phase 0 - Project Setup And Rules

Use for:
- criteria changes
- budget changes
- profile changes
- workflow or scoring logic changes
- schema changes in canonical CSVs

### 2026-05-31 - Codex / Final Audit Remediation For Human Review
- Scope: resolve the whole-project audit findings so the canonical CSVs are safe to hand to a human reviewer without unresolved scoring or ranking contradictions
- Actions completed: downgraded unsupported `LA03` hard-filter passes for `dunlop-79a-lite`, `lyf-funan-one-of-a-kind`, `somerset-bencoolen-one-bedroom-deluxe`, and `somerset-bencoolen-one-bedroom-premier`; recomputed hard-filter rollups in the summary sheet; removed all soft scoring from listings still marked `hard_filter_tbd`; stripped ranking language from unresolved rows and replaced it with human-review gating language; normalized numeric-like unknown placeholders in the summary sheet to blanks; lowered evidence quality to `unknown` for the unresolved room-page cases that still rely on property-level `lyf` URLs
- Files updated: `data/listings_score_summary.csv`, `data/listings_scores.csv`, `docs/agent-context-log.md`
- Sources or listings covered: all current listing IDs in the canonical sheets, with targeted hard-filter fixes on `dunlop-79a-lite`, `lyf-funan-one-of-a-kind`, `somerset-bencoolen-one-bedroom-deluxe`, and `somerset-bencoolen-one-bedroom-premier`
- Key findings: the prior audit defects were workflow-level, not source-boundary issues; after remediation, no `hard_filter_tbd` listing retains a live summary score or soft-scored detail rows, and unsupported bed-size passes no longer survive as eliminator passes
- Blockers: many listings still require human follow-up for exact August 2026 availability, written semester pricing, utilities, fee stack, guest policy, and other public-page gaps; no listing can be treated as fully cleared without that manual confirmation
- Next recommended step: use `data/listings_score_summary.csv` as the human review queue, prioritizing the central `hard_filter_tbd` rows with the fewest remaining unresolved hard filters

### 2026-06-03 - Codex / Canonical Data Refactor For Multi-Agent Stability
- Scope: replace the overloaded listing summary architecture with phase-specific machine files and session-aware metadata, while stopping before any final human-deliverable redesign
- Actions completed: created `data/source_registry.csv`, `data/listing_facts.csv`, `data/listing_scores_long.csv`, and `data/listing_decisions.csv`; migrated current source, listing, and scoring data into the new files; added `session_id`, `batch_id`, `created_at`, `updated_at`, lifecycle state, rankability state, and SGD/USD companion-value fields; updated `README.md`, `docs/project-guide.md`, `docs/scoring-system.md`, `docs/agent-guide.md`, and `docs/audit-guide.md` to use the new architecture; added `docs/improvement-backlog.md` to track remaining post-refactor work
- Files updated: `README.md`, `docs/project-guide.md`, `docs/scoring-system.md`, `docs/agent-guide.md`, `docs/audit-guide.md`, `docs/improvement-backlog.md`, `data/user-profile.md`, `data/source_registry.csv`, `data/listing_facts.csv`, `data/listing_scores_long.csv`, `data/listing_decisions.csv`
- Sources or listings covered: all currently tracked sources and listing IDs were migrated into the new canonical machine files
- Key findings: stable machine files should be organized by data role, not by human readability or by session; session separation is now handled through metadata instead of separate CSVs or fake in-file headers
- Blockers: the final human-facing deliverable CSV is intentionally not implemented yet because the user wants to revise that structure separately
- Next recommended step: remove or archive the legacy files only after the repo confirms the new canonical files are the sole active architecture, then continue with lifecycle-aware audit and validation improvements

### 2026-06-03 - Codex / Post-Refactor Workflow Hardening
- Scope: finish the remaining non-deliverable architecture improvements after the canonical file split
- Actions completed: made audit a required gate between phases in `docs/project-guide.md` and `docs/agent-guide.md`; added explicit session and batch placeholders to the mission skeleton; added explicit `read current phase state before editing` rules throughout the phase prompts; cleaned `data/listing_facts.csv` so judgment-heavy fields moved into `data/listing_decisions.csv`; added `docs/data-dictionary.md`; added repeatable validation via `scripts/validate-project.ps1`; expanded `docs/audit-guide.md` with lifecycle transition checks and validator references; updated `docs/improvement-backlog.md` to mark the remaining non-deliverable fixes as resolved
- Files updated: `docs/project-guide.md`, `docs/agent-guide.md`, `docs/audit-guide.md`, `docs/data-dictionary.md`, `docs/improvement-backlog.md`, `README.md`, `data/listing_facts.csv`, `data/listing_decisions.csv`, `scripts/validate-project.ps1`
- Sources or listings covered: full canonical dataset through validation, including all current listing IDs
- Key findings: the project now has a real state model plus a repeatable structural validator, which removes the biggest remaining source of agent drift from the first session
- Blockers: the human-facing final deliverable is still intentionally deferred pending the user's chosen output format
- Next recommended step: move to the human deliverable design when ready, using the now-stable machine files as the source of truth

### 2026-06-03 - Codex / Memory Architecture Separation
- Scope: separate durable research memory from repo/session mechanics and make logging mandatory for all future missions
- Actions completed: converted this file into explicit research memory; added `docs/ops-log.md` for architecture, validation, and sync mechanics; updated workflow docs, prompts, and audit rules so agents must always append to the correct log at mission end
- Files updated: `docs/agent-context-log.md`, `docs/ops-log.md`, `docs/project-guide.md`, `docs/agent-guide.md`, `docs/audit-guide.md`, `docs/improvement-backlog.md`
- Sources or listings covered: system-wide workflow memory only
- Key findings: one durable research-memory file is enough as long as it stays focused on housing knowledge and workflow state, while repo/session mechanics live separately
- Blockers: older entries above this point still include some historical legacy-file and session notes from before the split
- Next recommended step: use `docs/agent-context-log.md` for source, listing, scoring, and ranking memory; use `docs/ops-log.md` for repo, script, and sync notes

### 2026-06-03 - Codex / Human Deliverable Finalization
- Scope: implement the finalized user-facing CSV output shape from the new machine architecture
- Actions completed: added `scripts/generate-human-output.ps1`; generated `data/listing_output_human.csv` from canonical facts and decisions; used the finalized column order of source name, apartment/room style, SGD cost, USD cost, minutes from SMU, total score, exact listing URL, and category score breakdowns; formatted score columns as `x/y`; extended structural validation so human-output rows must map back to canonical listing records
- Files updated: `scripts/generate-human-output.ps1`, `data/listing_output_human.csv`, `scripts/validate-project.ps1`, `README.md`, `docs/scoring-system.md`, `docs/improvement-backlog.md`
- Sources or listings covered: all current canonical listing IDs
- Key findings: the final human-facing output can now be regenerated from machine files without forcing the machine surfaces to become human-oriented during active research
- Blockers: none
- Next recommended step: keep using machine files for agent work and regenerate `data/listing_output_human.csv` after meaningful updates to facts, decisions, or scores

### 2026-06-01 - Codex / Provisional Scoring Protocol For TBD Review Rows
- Scope: restore comparison scoring for all non-failed listings and update project rules so `hard_filter_tbd` rows may carry provisional scores for human review without being mistaken for fully cleared candidates
- Actions completed: updated `docs/project-guide.md`, `docs/scoring-system.md`, `docs/agent-guide.md`, and `docs/audit-guide.md` to allow provisional scoring on unresolved but review-worthy listings; re-scored all non-failed listings in `data/listings_scores.csv` with `provisional_scored` status on non-hard criteria; recomputed summary totals in `data/listings_score_summary.csv`; preserved `hard_filter_tbd` as the listing status; prefixed review-row `next_action` notes with provisional-score language; kept all `hard_filter_failed` rows at the bottom of the summary CSV
- Files updated: `docs/project-guide.md`, `docs/scoring-system.md`, `docs/agent-guide.md`, `docs/audit-guide.md`, `data/listings_scores.csv`, `data/listings_score_summary.csv`, `docs/agent-context-log.md`
- Sources or listings covered: all current non-failed listing IDs in the summary sheet
- Key findings: all 50 non-failed rows now have comparison-ready provisional scores again; unsupported `LA03` hard-filter passes remain downgraded to `tbd`; reviewability and unresolved-risk signaling now coexist in the canonical files instead of forcing a choice between them
- Blockers: provisional scores are comparison tools only; the same public-page gaps still block any claim that these rows are fully cleared shortlist options
- Next recommended step: send `data/listings_score_summary.csv` for human review and use `data/listings_scores.csv` as the trace sheet when a reviewer wants criterion-level rationale

### 2026-05-31 - Session Handoff / Repo Sync
- Scope: record the repository state reached at the end of the current session after Phase 4 work and preserve the exact push state for the next agent
- Actions completed: committed the current tracked repo changes as `398513d` with message `Update housing verification data and project docs`; pushed `main` to `origin/main`; confirmed local `main` and `origin/main` were aligned after push
- Files updated: no canonical project data changed at this step beyond the commit/push action; pushed tracked changes included `README.md`, `data/listings_score_summary.csv`, `data/listings_scores.csv`, `data/source-registry.csv`, `data/user-profile.md`, `docs/agent-guide.md`, `docs/project-guide.md`, `docs/scoring-system.md`
- Sources or listings covered: entire repo state produced before the push, including the Phase 4 listing batch described below
- Key findings: the repo is not left with an unpushed local-only state from this session; remote branch already contains the work through commit `398513d`
- Blockers: none
- Next recommended step: continue from the pushed `main` branch and read the Phase 3 and Phase 4 entries below before doing any more verification, visual review, scoring, or ranking

### 2026-05-31 - Initialization
- Scope: create a canonical running context file for cross-agent continuity
- Actions completed: added this phase-based log structure
- Files updated: `docs/agent-context-log.md`
- Sources or listings covered: none
- Key findings: project needed a single append-only context surface
- Blockers: none
- Next recommended step: start logging all future missions here

## Phase 1 - Source Audit

Use for:
- source-level trust review
- source approval / conditional / rejection decisions
- notes on source business model
- evidence about semester stay fit

### 2026-05-31 - Codex / User-Added Source Intake
- Scope: incorporate the newly added `Cove` source into the working source set and note its status relative to the original SMU pack
- Actions completed: verified that `Cove` was appended to `data/source-registry.csv` in this session as a user-added post-SMU-pack source; treated it as in-scope because the registry now marks it `approved`
- Files updated: none directly by this agent in this step; `data/source-registry.csv` already contained the new row when reviewed
- Sources or listings covered: `Cove`
- Key findings: `Cove` is now the newest approved source in the registry; its notes indicate 3-month student-stay fit, student-pass refund messaging, furnished rooms, and sufficient operator identity to proceed with listing extraction
- Blockers: none
- Next recommended step: use exact `cove.sg/listings/...` room pages for all further Cove verification work, not the generic `cove.sg/students` page

## Phase 2 - Listing Extraction

Use for:
- exact listing URLs found
- top-level listing intake
- raw listing facts added to `data/listings_score_summary.csv`
- notes on missing data from a listing page

### 2026-05-31 - Codex / Phase 2 Extraction Through Approved Sources + Cove
- Scope: complete Phase 2 listing extraction across the approved-source queue in `data/source-registry.csv`, then exhaust the newly added high-priority `Cove` source
- Actions completed:
- extracted and logged private-room or otherwise semester-plausible options for `Balestier Students' Hostel`, `A Co-Living Hotel @ Veerasamy by The Assembly Place`, `Sophia View by The Assembly Place`, `60 Wilkie`, `Keystone Farrer Park by Homestead`, `The Assembly Place`, `lyf`, `Somerset-Bencoolen (Ascotts)`, `Citadines Singapore`, and `Cove`
- left `CAMPUS by The Assembly Place`, `Heritage Apartments`, and `YMCA@One Orchard` with zero added rows because the verified inventory failed the private-room or budget plausibility screen
- explicitly skipped `Figment` and `Novena Hall` during the approved-source pass because they were `conditional`, not `approved`
- enforced the later prompt rule that `listing_url_or_note` must contain the deepest exact listing URL available from the approved source; replaced bad `contact-us` links for Veerasamy with the exact property listing page because separate room pages were not exposed
- corrected earlier BSH rows so each row had a populated source link; `bsh-single-room` now carries source URLs instead of a plain note
- exhausted `Cove` in three passes and logged only exact `cove.sg/listings/...` pages for central / SMU-plausible private rooms and studios
- Files updated: `data/listings_score_summary.csv`
- Sources or listings covered:
- `Balestier Students' Hostel`: 3 rows
- `A Co-Living Hotel @ Veerasamy by The Assembly Place`: 3 rows
- `Sophia View by The Assembly Place`: 2 rows
- `60 Wilkie`: 1 row
- `Keystone Farrer Park by Homestead`: 3 rows
- `CAMPUS by The Assembly Place`: 0 rows
- `The Assembly Place`: 11 rows
- `Heritage Apartments`: 0 rows
- `lyf`: 10 rows
- `Somerset-Bencoolen (Ascotts)`: 2 rows
- `Citadines Singapore`: 3 rows
- `YMCA@One Orchard`: 0 rows
- `Cove`: 28 rows
- Key findings:
- current row counts in `data/listings_score_summary.csv` by source are: `60 Wilkie` 1, `A Co-Living Hotel @ Veerasamy by The Assembly Place` 3, `Balestier Students' Hostel` 3, `Citadines Singapore` 3, `Cove` 28, `Keystone Farrer Park by Homestead` 3, `lyf` 10, `Somerset-Bencoolen (Ascotts)` 2, `Sophia View by The Assembly Place` 2, `The Assembly Place` 11
- many TAP properties expose room types only inside an exact property page, not room-detail pages; for those sources the correct link is the exact property listing page, not a generic operator page
- `lyf Chinatown` and some `lyf Funan` rows only exposed the exact property page, not separate room pages, in retrieved results; those rows were still logged because the room types themselves were explicit on the exact property page
- `Cove` produced the richest operator-level exact-room inventory in this session; all logged Cove rows point to exact `cove.sg/listings/...` pages, not the `students` landing page
- `Cove` listing IDs currently logged:
- `cove-niven-915`
- `cove-ritzfarrer-671`
- `cove-plaza-665`
- `cove-foch-1056`
- `cove-foch-1049`
- `cove-foch-1038`
- `cove-foch-1057`
- `cove-bayron-2268`
- `cove-bayron-2466`
- `cove-bayron-2719`
- `cove-bayron-2649`
- `cove-kinta-1170`
- `cove-uesquare-3114`
- `cove-uesquare-3118`
- `cove-samkiang-3155`
- `cove-samkiang-3157`
- `cove-hootkiam-476`
- `cove-hootkiam-907`
- `cove-regency-3106`
- `cove-regency-3108`
- `cove-gambier-3161`
- `cove-regalia-3127`
- `cove-niven-910`
- `cove-hootkiam-3146`
- `cove-hootkiam-3147`
- `cove-regalia-3126`
- `cove-regalia-3130`
- `cove-regalia-3133`
- repeated missing facts across Phase 2 rows are: exact August 2026 availability, final semester-specific monthly rent, utilities inclusion, deposit / admin / stamp-duty / move-out fee stack, guest policy, and listing-level daylight/window confirmation where the listing page did not expose it
- several rows in `data/listings_score_summary.csv` are no longer `extracted`; other work in the repo has already advanced many rows into statuses such as `hard_filter_tbd` or `hard_filter_failed`. Do not assume the CSV is Phase-2-only anymore. Read row status before editing.
- Blockers:
- search retrieval for some sites, especially Ascott / lyf / Citadines and selected Cove pages, did not always expose price or live availability cleanly even when the exact room page existed
- `data/listings_score_summary.csv` contains some rows with later-phase status updates already applied, so a future agent must avoid overwriting those fields blindly during additional extraction or verification
- Next recommended step:
- if continuing with verification, start Phase 3 on the `Cove` rows first because they have the highest density of exact room URLs and likely the best current fit
- if continuing extraction instead, only revisit sources where property pages may have changed or where a specific missing deep room URL can now be surfaced
- if editing `lyf` rows, prioritize replacing property-page URLs with room-page URLs where a true room deep link can be confirmed for currently property-level-only entries

## Phase 3 - Hard-Filter Verification

Use for:
- pass / fail / TBD decisions on hard filters
- budget cap checks
- commute cap checks
- student pass, semester stay, private room, bed size, desk, window, AC, laundry checks

### 2026-05-31 - Phase 4 Prep / Ready-Set Interpretation
- Scope: determine which already-extracted listings were actually ready to move into the Phase 4 full-verification pass requested in this session
- Actions completed: read `docs/project-guide.md`, `docs/scoring-system.md`, `docs/smu-guidance.md`, and the relevant Phase 3 / Phase 4 instructions in `docs/agent-guide.md`; inspected `data/listings_score_summary.csv` and `data/listings_scores.csv`; identified that the project did not use a dedicated `phase4_ready` marker and interpreted "ready to move on to phase 4" as the existing listing cohort with `hard_filter_fail_count = 0`; confirmed there were 50 such listings at the time of the pass
- Files updated: `data/listings_score_summary.csv`, `data/listings_scores.csv`
- Sources or listings covered: `bsh-vip-room`, `bsh-mini-single-room`, `sophia-view-tap-lite`, `keystone-farrer-compact`, `bencoolen-house-tap-lite`, `jalan-besar-138-lite`, `jalan-besar-138-luxe`, `jalan-besar-140-lite`, `horne-road-64-lite`, `dunlop-79a-lite`, `the-centren-lite-queen`, `lyf-bugis-nano-queen`, `lyf-bugis-one-of-a-kind`, `lyf-bugis-one-of-a-kind-plus`, `lyf-farrer-one-of-a-kind`, `lyf-funan-one-of-a-kind`, `lyf-funan-one-of-a-kind-plus`, `lyf-chinatown-nano-queen`, `lyf-chinatown-nano-queen-plus`, `lyf-chinatown-one-of-a-kind`, `lyf-chinatown-one-of-a-kind-plus`, `somerset-bencoolen-one-bedroom-deluxe`, `somerset-bencoolen-one-bedroom-premier`, `citadines-rochor-studio-premier`, `citadines-rochor-studio-executive`, `citadines-rochor-one-bedroom-premier`, `cove-ritzfarrer-671`, `cove-plaza-665`, `cove-foch-1056`, `cove-foch-1049`, `cove-foch-1038`, `cove-foch-1057`, `cove-bayron-2268`, `cove-bayron-2466`, `cove-bayron-2719`, `cove-bayron-2649`, `cove-kinta-1170`, `cove-samkiang-3155`, `cove-samkiang-3157`, `cove-hootkiam-476`, `cove-hootkiam-907`, `cove-regency-3108`, `cove-gambier-3161`, `cove-regalia-3127`, `cove-niven-910`, `cove-hootkiam-3146`, `cove-hootkiam-3147`, `cove-regalia-3126`, `cove-regalia-3130`, `cove-regalia-3133`
- Key findings: no separate workflow field existed to say "ready for phase 4"; readiness had to be inferred from the hard-filter result surface already present in the canonical files
- Blockers: some of the 50 "ready" listings were still `hard_filter_tbd`, not fully passed; the session nonetheless followed the user instruction literally and performed a Phase 4-style factual verification pass on all `hard_filter_fail_count = 0` rows without adding or ranking listings
- Next recommended step: if a future agent wants a stricter gate for later phases, define an explicit transition marker rather than re-inferring readiness from `hard_filter_fail_count`

## Phase 4 - Full Listing Verification

Use for:
- deeper policy and lease review
- deposit, utilities, hidden fees, guest policy, landlord setup, kitchen, bathroom checks
- trust concerns tied to a specific listing

### 2026-05-31 - Full Verification Pass For All Current Ready Listings
- Scope: perform the requested Phase 4 pass for every listing already in canonical files that had `hard_filter_fail_count = 0`, without adding new listings and without ranking
- Actions completed: worked from the exact listing URL already stored where available; checked official listing pages and exact room/property pages across Balestier Students' Hostel, The Assembly Place, Keystone, Discover ASR properties (`lyf`, `Somerset`, `Citadines`), and Cove; updated summary-level evidence on exact price structure where publicly shown, deposit burden where publicly shown, utilities inclusion, bed, desk, AC, laundry, kitchen access, natural-light notes, guest-policy disclosure state, and operator / property-control evidence; filled previously blank `key_strengths`, `key_concerns`, and `next_action` fields across the ready cohort; normalized many ambiguous guest-policy cells to `not disclosed publicly on listing page`; preserved unknowns as unknown where the public page did not support a stronger claim; did not add new listings and did not rank
- Files updated: `data/listings_score_summary.csv`, `data/listings_scores.csv`
- Sources or listings covered: exact public pages validated in-session included `https://www.theassemblyplace.com/properties/sophia-view/`, `https://www.thekeystone.sg/farrerpark`, `https://www.discoverasr.com/en/lyf/singapore/lyf-bugis-singapore/nano-queen`, and `https://cove.sg/listings/671-cove-103-master-ensuite-room-ritzfarrer`; the full ready-listing batch covered was `bsh-vip-room`, `bsh-mini-single-room`, `sophia-view-tap-lite`, `keystone-farrer-compact`, `bencoolen-house-tap-lite`, `jalan-besar-138-lite`, `jalan-besar-138-luxe`, `jalan-besar-140-lite`, `horne-road-64-lite`, `dunlop-79a-lite`, `the-centren-lite-queen`, `lyf-bugis-nano-queen`, `lyf-bugis-one-of-a-kind`, `lyf-bugis-one-of-a-kind-plus`, `lyf-farrer-one-of-a-kind`, `lyf-funan-one-of-a-kind`, `lyf-funan-one-of-a-kind-plus`, `lyf-chinatown-nano-queen`, `lyf-chinatown-nano-queen-plus`, `lyf-chinatown-one-of-a-kind`, `lyf-chinatown-one-of-a-kind-plus`, `somerset-bencoolen-one-bedroom-deluxe`, `somerset-bencoolen-one-bedroom-premier`, `citadines-rochor-studio-premier`, `citadines-rochor-studio-executive`, `citadines-rochor-one-bedroom-premier`, `cove-ritzfarrer-671`, `cove-plaza-665`, `cove-foch-1056`, `cove-foch-1049`, `cove-foch-1038`, `cove-foch-1057`, `cove-bayron-2268`, `cove-bayron-2466`, `cove-bayron-2719`, `cove-bayron-2649`, `cove-kinta-1170`, `cove-samkiang-3155`, `cove-samkiang-3157`, `cove-hootkiam-476`, `cove-hootkiam-907`, `cove-regency-3108`, `cove-gambier-3161`, `cove-regalia-3127`, `cove-niven-910`, `cove-hootkiam-3146`, `cove-hootkiam-3147`, `cove-regalia-3126`, `cove-regalia-3130`, `cove-regalia-3133`
- Key findings: The Assembly Place and Keystone pages exposed enough public detail to keep many basics explicit, including SGD pricing on several room cards, furnished status, AC, desk, laundry, and flexible lease signals; `sophia-view-tap-lite` remained one of the clearest central options with `From $1,950 / Month`, `AVAILABLE FROM 07 JUN`, queen bed, desk, AC, equipped kitchen, fibre broadband, washer/dryer, and weekly housekeeping on the public page; `keystone-farrer-compact` publicly showed pricing in SGD (`$1,705`) and a terms-level `S$2,000` security deposit plus `S$200` admin fee already reflected in notes; many Discover ASR room pages remained thin on long-stay pricing, so lyf / Somerset / Citadines rows often still lack a verified listing-level monthly SGD rate and continue to require written quote confirmation; Cove exact listing pages were useful for room basics, operator identity, bed size, desk, bathroom setup, and general commute fit, but several exact room pages still did not expose a clean live monthly price or August-specific move-in date in retrievable content, so those rows still carry unresolved price / availability items; guest policy remained broadly undisclosed on public pages across most sources and was explicitly recorded that way rather than left vague
- Blockers: many public pages do not expose a semester-ready written fee stack; key recurring gaps after this pass are exact August 2026 move-in hold, full deposit/admin/tax treatment, utilities inclusion granularity, and guest policy; Discover ASR pages in particular often require a quote flow rather than a transparent listing-level monthly long-stay SGD rate
- Next recommended step: do not rank yet; move either to a targeted outreach / manual follow-up pass for written quotes and policies, or to Phase 5 visual review for the most promising survivors before scoring

### 2026-05-31 - Detailed Sheet Normalization During Phase 4 Pass
- Scope: keep `data/listings_scores.csv` aligned with the summary-level facts after the Phase 4 verification work, so another agent can trace why each ready listing is still pass / fail / TBD on hard filters
- Actions completed: refreshed `evidence_url_or_note` for the ready cohort to match the stored listing URL; recalculated and rewrote several hard-filter evidence rows where stored facts already supported stronger wording, especially `CO01`, `LF01`, `LC01`, `LA03`, `UQ01`, `UQ02`, `UQ03`, `UQ04`, `TR01`, `TR02`, `TR03`, and `TR04`; recomputed `hard_filter_fail_count` and `hard_filter_tbd_count` in `data/listings_score_summary.csv` from the detailed rows after the updates; note that this was not a Phase 6 scoring pass and `points_awarded` remained blank
- Files updated: `data/listings_scores.csv`, `data/listings_score_summary.csv`
- Sources or listings covered: same 50-listing ready cohort as the full-verification pass above
- Key findings: some rows remained `tbd` because the public source still lacked one or more of price, exact availability, utilities detail, or daylight evidence; some rows improved from looser wording to explicit evidence-backed statements like `displayed monthly price is S$1950` or `availability_start is 2026-06-07`; `UQ03` stayed mixed because some listings already had summary-level `natural_light_quality` evidence while others still did not
- Blockers: the session did not separately run a full visual-review phase, so daylight and window confirmation was limited to what was already explicit on the listing page text or already stored in canonical fields
- Next recommended step: if a future agent relies on `hard_filter_tbd_count` as a gate, read the underlying detailed evidence rows first because some TBDs are minor documentation gaps rather than strong negative signals

## Phase 5 - Visual Review

Use for:
- room quality observations from photos
- daylight and window notes
- maintenance concerns
- furniture and usable-space observations
- mismatches between photos and text

### 2026-05-31 - Codex / Phase 5 Visual Review
- Scope: perform a visual-review pass across all currently logged listings and capture image-based room-quality observations without adding new listings
- Actions completed: updated visual condition notes in the summary sheet; added concise strengths and concerns tied to usable floor space, daylight, room feel, and visible maintenance; refreshed desk and daylight evidence language in the detailed sheet where visuals materially changed confidence
- Files updated: data/listings_score_summary.csv, data/listings_scores.csv
- Sources or listings covered: all listing IDs currently present in data/listings_score_summary.csv
- Key findings: exact-room photo quality is strongest on many Cove rows; TAP and serviced-apartment sources often rely on polished marketing imagery; some smaller hostel and compact co-living options remain visually weak on desk or daylight confidence
- Blockers: visual review did not resolve the recurring public-page gaps around exact August availability, full fee stack, and guest policy
- Next recommended step: repair any downstream hard-filter decisions that overstate visual confidence, then proceed to scoring only after the summary and detail sheets are structurally aligned
## Phase 6 - Scoring

Use for:
- point assignment completion
- penalty application
- evidence-quality notes affecting score confidence
- listing-by-listing scoring completion status

### 2026-05-31 - Codex / Phase 6 Scoring For All Existing Listings
- Scope: score every listing already present in `data/listings_score_summary.csv` using the canonical scoring model, without adding listings or searching for new sources
- Actions completed: first checked the Phase 6 prompt template and confirmed the initial request still contained the placeholder `[LISTING IDS]`, so no implicit batch was assumed; after the user clarified that all existing listings were in scope, read `docs/scoring-system.md`, `data/criteria_weights.csv`, and the current summary/detail sheets; expanded `data/listings_scores.csv` from hard-filter-only coverage to full criterion coverage for all current listings; preserved existing hard-filter decisions and rewrote only the Phase 6 scoring surface; added non-hard-filter rows for `LF02`, `CO02`-`CO05`, `LC02`-`LC04`, `LA01`-`LA02`, `LA04`-`LA09`, `UQ05`-`UQ09`, and `TR05`-`TR07`; left unresolved criteria blank instead of forcing zeroes; applied no scam-risk penalties because stored evidence did not support them; recomputed summary-level category subtotals, positive points, scored-points denominator, score percentage, and total-after-penalties from the detailed rows; added an exact-URL evidence-confidence concern in summary rows that still lacked a single exact listing URL
- Files updated: `data/listings_scores.csv`, `data/listings_score_summary.csv`
- Sources or listings covered: all 66 listing IDs currently present in `data/listings_score_summary.csv` at the time of scoring, including Balestier Students' Hostel, The Assembly Place, Keystone, Discover ASR (`lyf`, `Somerset`, `Citadines`), and Cove rows
- Key findings: the detailed sheet now contains all 36 criteria for all 66 listings (`2376` rows total); the project docs define the criteria registry and guardrails but do not define granular point-band formulas for every soft criterion, so this pass used a conservative evidence-backed scoring method tied strictly to stored facts already in the canonical files; unresolved cost and availability evidence remained the dominant limiter on many `lyf`, `Somerset`, `Citadines`, and several `Cove` rows; strong exact-room evidence and self-contained layouts lifted some serviced-apartment and `Cove` studio / ensuite rows; several visually strong TAP, Keystone, and Cove rows still remain `hard_filter_failed` or `hard_filter_tbd` because Phase 3 / 4 hard-filter uncertainty was preserved rather than overridden by Phase 6 scores
- Blockers: Phase 6 was completed, but many listings still carry unresolved public-page gaps around exact August 2026 availability, live monthly SGD totals, utilities granularity, and full fee stacks; because the scoring pass intentionally avoided inventing band logic beyond stored facts, some category totals remain conservative rather than exhaustive
- Next recommended step: if the user wants a shortlist, move to Phase 7 ranking using the updated score fields while keeping unresolved-risk and hard-filter status in view; if the user wants stronger score confidence first, do a targeted outreach / manual follow-up pass for written pricing, fee, and availability confirmation on the top surviving rows

## Phase 7 - Ranking And Shortlist

Use for:
- ranking updates
- strongest candidates
- rejected options worth keeping as references
- tradeoff notes across the shortlist

### 2026-05-31 - Codex / Phase 7 Ranking For Current Survivors
- Scope: rank all currently scored, non-eliminated listings already present in `data/listings_score_summary.csv`, without adding listings or searching new sources
- Actions completed: reviewed `docs/project-guide.md`, `docs/scoring-system.md`, the Phase 7 prompt in `docs/agent-guide.md`, and the current summary sheet; isolated all rows not marked `hard_filter_failed`; compared score, commute, evidence quality, hard-filter TBD burden, and pricing clarity while enforcing the rule that unclear or missing normalized SGD cost should not outrank clearly priced options on cost; treated the existing `status` field as hard-filter state and avoided inventing new schema; wrote shortlist / backup ranking notes into the `next_action` field for the main contenders and for high-upside but price-blocked rows
- Files updated: `data/listings_score_summary.csv`
- Sources or listings covered: all non-eliminated rows in `data/listings_score_summary.csv` at the time of ranking, including surviving TAP, Keystone, Balestier Students' Hostel, Discover ASR, and Cove rows
- Key findings:
- the cleanest shortlist came from TAP rows with both short SMU walks and explicit all-in SGD pricing
- `bencoolen-house-tap-lite` was ranked first on balance because it paired a 1-minute SMU walk profile with clear S$1700 all-in pricing and only moderate unresolved risk
- `jalan-besar-138-lite` was ranked second as the strongest value candidate at S$1500 all-in with a 5-minute walk, but it stayed behind Bencoolen House because more core facts remained unresolved
- `jalan-besar-138-luxe` and `jalan-besar-140-lite` formed the next priced shortlist tier for users willing to pay around S$1950 all-in for stronger bathroom / room packages
- `cove-hootkiam-476` was the strongest Cove row because it had exact-room evidence, a visible S$2000 rent signal, low unresolved-risk count, and an 11-minute walk, but it stayed below the top TAP options because utilities and all-in cost were less clear
- `sophia-view-tap-lite` was kept as the cleanest next TAP backup if the shorter-walk Bencoolen / Jalan Besar options fail to convert
- `somerset-bencoolen-one-bedroom-deluxe`, `somerset-bencoolen-one-bedroom-premier`, `cove-foch-1038`, `cove-foch-1049`, `cove-foch-1057`, and `cove-niven-910` were explicitly held below clearly priced shortlist options because current monthly SGD pricing was still not exposed cleanly in stored evidence
- Blockers: many high-upside rows still lack current normalized SGD monthly totals, utilities confirmation, and August 2026 availability confirmation, which limits how far ranking can rely on raw score alone
- Next recommended step: if the user wants a decision-ready shortlist, move to Phase 9 outreach on the top priced survivors first, especially `bencoolen-house-tap-lite`, `jalan-besar-138-lite`, `jalan-besar-138-luxe`, `jalan-besar-140-lite`, and `cove-hootkiam-476`

## Phase 8 - Exhaustion And Expansion Control

Use for:
- confirmation that a source pack has been exhausted
- statement that all approved sources in scope were checked
- recommendation to expand scope only after explicit approval

### 2026-05-31 - Codex / Approved Queue Exhaustion + Expansion Beyond SMU Pack
- Scope: determine whether the original approved queue had been exhausted and record the transition to the newly added source
- Actions completed:
- confirmed that after `YMCA@One Orchard`, no further `approved` sources remained in the original queue; remaining original unresolved entries were `Figment` and `Novena Hall` as `conditional`, plus `St Thomas Lodge` as `rejected`
- after that exhaustion point, proceeded into the new approved `Cove` source because it had been appended to `data/source-registry.csv` during this session
- Files updated: none directly by this step; operational effect was to continue extraction into `Cove`
- Sources or listings covered: original approved queue plus `Cove`
- Key findings:
- the original approved-source queue from the registry was effectively exhausted before `Cove`
- `Cove` is the first clear expansion source handled after that point and is now itself close to exhausted for central / SMU-plausible private-room inventory
- Blockers: none
- Next recommended step: explicitly decide whether `Figment` / `Novena Hall` should now be processed despite their `conditional` status, or move to Phase 3 hard-filter verification on the strongest `Cove`, TAP, and central serviced-apartment rows

### 2026-05-31 - Codex / Git And Session State
- Scope: record the commit / push state from this session so another agent knows what is and is not on `origin/main`
- Actions completed:
- committed and pushed an earlier extraction checkpoint containing pre-Cove listing intake updates
- push details: commit `aaf7066` with message `Add extracted housing listing intake rows`
- did not include unrelated working-tree changes in `data/source-registry.csv` or `docs/agent-guide.md` in that push
- Files updated: git history on `origin/main`; local repo also has this context log file created but not yet committed at the time of this entry
- Sources or listings covered: all pre-Cove listing intake rows included in the pushed commit; Cove additions happened after that push and should be treated as later local progress unless separately committed
- Key findings:
- another agent should not assume `origin/main` contains the `Cove` rows or this context log unless a later commit has been made after `aaf7066`
- current local `git status` showed `docs/agent-context-log.md` as untracked when this log entry was prepared
- Blockers: none
- Next recommended step: if the user wants the latest `Cove` work preserved remotely, commit and push `data/listings_score_summary.csv` and `docs/agent-context-log.md` together or in separate clean commits

## Phase 9 - Outreach And Manual Follow-Up

Use for:
- landlord or operator questions to send
- booking friction notes
- missing confirmations needed before final approval
- negotiation or follow-up strategy

