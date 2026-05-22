# Listing Evaluator Prompt

Use this prompt when asking an AI system to grade a specific listing.

## Prompt

Evaluate this housing listing for a student attending Singapore Management
University from August 9, 2026 to December 6-10, 2026.

Follow this order:

1. Apply hard filters first.
2. If the listing passes, score it from 0-5 on each criterion.
3. Apply penalties for missing evidence and scam risk.
4. Produce a final percentage and recommendation.

Constraints:

- do not invent missing facts
- state unknowns explicitly
- downgrade listings with weak verification
- prioritize legitimacy over apparent cheapness

Output format:

- hard filter result
- criterion-by-criterion scores
- penalty rationale
- final score percentage
- risk level
- shortlist recommendation
