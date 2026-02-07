# Implementation Plan: Fitness Workout Tracking

**Branch**: `001-fitness-workout-tracking` | **Date**: 2026-02-06 | **Spec**: [specs/001-fitness-workout-tracking/spec.md](specs/001-fitness-workout-tracking/spec.md)
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Deliver a Phoenix LiveView web app with a companion first-party API that lets users log strength and cardio workouts, including detailed prescriptions and actuals. Strength entries capture set/rep schemes, percent or working weight, RIR, and per-set actuals; cardio logs support LSS (modeled as a single-round interval) and HIIT intervals with per-round actuals. Anonymous usage is supported with local-only browser storage, explicit data-loss warnings, and an association flow when a user creates an account. The design uses normalized Ecto schemas (including unit fields and per-user 1RM values), LiveView changeset-driven forms, and streams for history lists with edit/delete support.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Elixir 1.19.5  
**Primary Dependencies**: Phoenix 1.8.3, Phoenix LiveView 1.1.0, Ecto 3.13, Postgrex, Tailwind 4.1.12  
**Storage**: PostgreSQL for authenticated users; browser local storage for anonymous sessions (with import/association on sign-up)  
**Testing**: ExUnit, Phoenix LiveView Test, Ecto SQL Sandbox  
**Scaffolding**: `mix phx.gen.auth`, `mix phx.gen.live` for baseline scaffolds (customized afterward)  
**Target Platform**: Web (Phoenix LiveView)
**Project Type**: Web application  
**Performance Goals**: History list renders in <2 seconds for up to 200 sessions  
**Constraints**: No training plans/routines; anonymous data is local-only; LSS modeled as interval with 1 round; store all three cardio metrics per round after deriving the missing one; mixed-unit entries are blocked or reconciled during entry  
**Scale/Scope**: MVP for individual users; primary flows are logging strength/cardio, viewing/editing/deleting history, and optional account creation for data association

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Quality & Testing: Tests planned for P1-P3 flows plus validation/derivation edge cases (units, RIR + rep ranges, cardio metric derivation).
- User Experience: UX/accessibility reviewed for anonymous warnings, unit validation feedback, and history edit/delete.
- Security & Privacy: Risk considerations documented for local storage data loss, anonymous-to-account association, and API access control.
- Maintainability: Complexity justified for prescription parsing and derivation logic with clear module boundaries.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
lib/
├── moeru/
│   ├── workouts/              # contexts, schemas, domain logic
│   ├── exercises/             # exercise catalog and custom exercises
│   └── accounts/              # user preferences and maxes
├── moeru_web/
│   ├── live/                  # LiveViews for logging and history
│   ├── components/            # UI components
│   └── controllers/           # auth and ancillary controllers
priv/
├── repo/
│   └── migrations/
assets/
│   └── accounts/              # auth, user preferences, and 1RM values
└── js/
test/
├── moeru/
└── moeru_web/
│   └── controllers/           # auth + workout API controllers
```

**Structure Decision**: Single Phoenix web application using standard `lib/moeru` contexts and `lib/moeru_web` LiveViews, with migrations in `priv/repo/migrations` and assets in `assets/`.

## Complexity Tracking

No constitution violations identified.
