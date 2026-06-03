# Ops Log

Purpose: track repository and session mechanics that are useful for continuity
but should not pollute long-term research memory.

Use this file for:

- commit and push state
- file migrations and refactors
- schema changes
- validator changes
- tooling or script fixes
- local/remote sync notes
- one-off operational incidents

Do not use this file for:

- source trust decisions
- listing findings
- ranking conclusions
- housing-market knowledge
- user preference changes

Entry template:

```md
### YYYY-MM-DD - Agent / Ops Task
- Scope:
- Actions completed:
- Files updated:
- Operational impact:
- Blockers:
- Next recommended step:
```

### 2026-06-03 - Codex / Memory Logging Architecture Split
- Scope: separate durable housing memory from repo/session mechanics and make logging mandatory in the workflow
- Actions completed: created `docs/ops-log.md`; updated prompts, workflow docs, and audit rules so missions must log to either research memory or ops log at completion; linked the split into the improvement backlog
- Files updated: `docs/ops-log.md`, `docs/project-guide.md`, `docs/agent-guide.md`, `docs/audit-guide.md`, `docs/improvement-backlog.md`, `docs/agent-context-log.md`
- Operational impact: future agents no longer need a user reminder to log context; repo/session mechanics now have a dedicated surface
- Blockers: none
- Next recommended step: keep older mixed historical entries as-is, but from now on write research intelligence to `docs/agent-context-log.md` and tooling/session mechanics here

### 2026-06-03 - Codex / Human Output And Validation Tooling
- Scope: add the final human-facing CSV generator and extend validation to cover the deliverable layer
- Actions completed: created `scripts/generate-human-output.ps1`; generated `data/listing_output_human.csv`; extended `scripts/validate-project.ps1` to check that human-output rows map back to canonical listing records; documented the deliverable and generator in repo docs
- Files updated: `scripts/generate-human-output.ps1`, `data/listing_output_human.csv`, `scripts/validate-project.ps1`, `README.md`, `docs/scoring-system.md`, `docs/improvement-backlog.md`
- Operational impact: the repo now has a stable machine-to-human export path and a validator that covers both machine files and the human deliverable
- Blockers: none
- Next recommended step: regenerate the human output after any meaningful score or decision changes before sharing results
