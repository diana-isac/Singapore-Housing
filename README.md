# Singapore Housing Search

This workspace is for finding short-term student housing in Singapore for the
SMU study period from August 9, 2026 to December 6-10, 2026.

The goal is to produce a curated shortlist of safe, legitimate, affordable
housing options that can be manually reviewed and then pursued with landlords
or property managers.

## Structure

- `docs/`: project architecture, workflow, grading rules, scam prevention
- `data/`: user requirements, source registry, listings database, shortlist
- `templates/`: reusable review templates for listings and channels
- `prompts/`: prompt scaffolds for future AI-assisted sourcing and evaluation

## Workflow

1. Define user constraints and weighted criteria.
2. Approve trustworthy sourcing channels.
3. Search listings from approved channels only.
4. Verify each listing for legitimacy and fit.
5. Score listings using the shared rubric.
6. Produce a shortlist above the agreed threshold.
7. Manually review and contact landlords/agents.

## Current Status

The architecture and templates are scaffolded. The next step is to fill in the
user profile and finalize the scoring weights before sourcing live listings.
