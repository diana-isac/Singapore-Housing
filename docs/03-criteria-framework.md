# Criteria Framework

Use two layers: hard filters and weighted preferences.

## Hard Filters

If a listing fails any hard filter, it is rejected before scoring.

Recommended hard filters:

- available for the target date range or close enough to negotiate
- within the maximum total monthly budget
- legal and legitimate rental arrangement
- reasonable commute to SMU
- safe enough area by the user's standard
- acceptable housing type
- no payment-before-verification red flags

## Weighted Criteria

Each criterion gets:

- an importance weight from 1-5
- a listing score from 0-5
- a weighted result equal to `weight x score`

Recommended criteria categories:

### Cost

- monthly rent
- deposit amount
- included utilities
- hidden fees
- furnishing value for price

### Location

- commute time to SMU
- proximity to MRT
- walkability for daily needs
- neighborhood fit

### Lease Fit

- exact date compatibility
- flexibility on move-out
- minimum stay rules
- paperwork simplicity

### Unit Quality

- cleanliness and maintenance
- room size
- privacy
- air conditioning
- natural light
- kitchen access
- laundry access
- internet quality

### Living Arrangement

- private room vs shared room
- number of housemates
- landlord on-site vs off-site
- quiet/study suitability
- guest policy

### Legitimacy and Trust

- listing completeness
- verifiable identity of landlord/agent
- consistency across photos, address, and description
- willingness to provide lease terms
- willingness to provide viewing or proof of control

## Uncertainty Penalty

Add a penalty when major facts are missing. A cheap listing with unresolved
risk should not outrank a slightly more expensive but verified listing.

Recommended penalty scale:

- `0`: no important unknowns
- `-3`: one meaningful unknown
- `-7`: multiple important unknowns
- `-15`: serious verification gap
