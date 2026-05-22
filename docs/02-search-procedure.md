# Search Procedure

## Phase 1: User Definition

Define:

- exact move-in and move-out flexibility
- maximum monthly budget
- preferred housing type
- commute tolerance
- acceptable neighborhoods
- furnishing and utility requirements
- roommate tolerance
- lease and deposit tolerance
- non-negotiable red lines

Output:

- completed `data/user-profile.template.md`
- updated `data/criteria-weights.csv`

## Phase 2: Source Approval

For each channel:

1. Identify ownership and reputation.
2. Check whether listings are direct, brokered, or crowdsourced.
3. Review anti-scam controls.
4. Assess whether short-term student lets are common there.
5. Decide source status: `approved`, `conditional`, or `rejected`.

Output:

- updated `data/source-registry.csv`

## Phase 3: Listing Intake

For each approved source:

1. Search within commute range of SMU.
2. Capture every plausible listing in `data/listings-master.csv`.
3. Save the source URL and retrieval date.
4. Mark unknown fields explicitly as unknown.

## Phase 4: Verification

For each listing:

1. Apply hard filters first.
2. Check scam and legitimacy signals.
3. Confirm lease dates and total cost.
4. Assess commute and area fit.
5. Record evidence and unresolved questions.

Output:

- completed `templates/listing-evaluation-template.md` copies or structured
  notes per listing

## Phase 5: Scoring

1. Grade each criterion from 0-5.
2. Apply weight multipliers.
3. Deduct penalties for uncertainty and risk.
4. Reject listings below the minimum threshold.

## Phase 6: Shortlisting

Promote only listings that:

- pass all hard filters
- come from approved or conditionally approved sources with acceptable evidence
- exceed the score threshold
- have manageable unresolved risks

## Phase 7: Manual Final Review

Before contacting a landlord or sending money:

- verify identity
- verify address existence
- verify viewing process or tenancy evidence
- verify payment method
- verify lease document terms
