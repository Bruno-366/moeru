<!--
Sync Impact Report
- Version change: 1.1.0 -> 1.1.1
- Modified principles: Maintainability & Simplicity
- Added sections: None
- Removed sections: None
- Templates requiring updates: ✅ .specify/templates/plan-template.md
- Follow-up TODOs: None
-->

# Moeru Constitution

## Core Principles

### Quality & Testing Discipline
- Changes MUST include appropriate tests or a documented rationale for why tests are not applicable.
- TDD is the default: tests are written first, must fail before implementation, then implementation proceeds.
- Quality checks MUST pass before merge (tests, lint/format, and required CI checks).
- Test coverage MUST focus on user journeys and critical behaviors, not just implementation details.

### User Experience & Accessibility
- User-facing changes MUST preserve or improve usability and accessibility.
- UI work MUST include responsive layouts and clearly communicated states (loading, empty, error).
- Design decisions SHOULD be intentional and consistent with the product's visual language.

### Security & Privacy First
- Data handling MUST follow least-privilege and minimize exposure of sensitive data.
- Security-impacting changes MUST include threat and risk considerations in the PR.
- Secrets and credentials MUST never be committed to the repository.

### Maintainability & Simplicity
- Prefer simple, explicit solutions over clever or complex designs.
- Prefer data-first modeling: clarify data structures and relationships before behavior.
- Changes MUST be understandable by the team without deep context.
- When complexity is unavoidable, rationale MUST be documented in the plan or PR.

Rationale: 
> "Show me your flowcharts, and conceal your tables, and I shall continue to be mystified; show me your tables and I won't usually need your flowcharts."
~ Fred Brooks

## Quality Gates
- All required checks MUST pass before merge.
- User-facing changes MUST be reviewed for UX/accessibility impact.
- Security-sensitive changes MUST include a risk assessment.
- Performance-sensitive changes MUST include a validation plan or benchmark.

## Development Workflow
- Work is tracked in branches and reviewed via pull requests.
- Reviews MUST verify compliance with this constitution and project guidelines.
- Deviations from team conventions MUST be documented and approved.

## Governance
- This constitution is the source of truth for engineering decisions and supersedes local conventions.
- Amendments require a documented proposal, review by maintainers, and a version bump.
- Versioning follows semantic versioning: MAJOR for breaking governance changes, MINOR for new principles, PATCH for clarifications.
- Compliance is reviewed in every PR; exceptions must be explicit and justified.
- Detailed implementation guidance lives in [AGENTS.md](AGENTS.md) and may evolve without changing this constitution.

**Version**: 1.1.1 | **Ratified**: 2026-02-06 | **Last Amended**: 2026-02-06
