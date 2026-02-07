---

description: "Task list for fitness workout tracking implementation"
---

# Tasks: Fitness Workout Tracking

**Input**: Design documents from `/specs/001-fitness-workout-tracking/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/openapi.yaml, quickstart.md

**Tests**: Included explicitly per user story to satisfy TDD requirements.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create base context stubs in lib/moeru/workouts.ex and lib/moeru/exercises.ex
- [ ] T002 Create workouts LiveView folder structure with placeholder module in lib/moeru_web/live/workouts/

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

- [ ] T003 Run `mix phx.gen.auth` and wire routes in lib/moeru_web/router.ex (auth modules in lib/moeru/accounts/ and controllers in lib/moeru_web/controllers/)
- [ ] T004 [P] Use `mix phx.gen.live` for baseline LiveView/context scaffolds (workouts and exercises), then adapt generated code to the spec in lib/moeru/workouts/ and lib/moeru_web/live/
- [ ] T005 [P] Add anonymous storage hook in assets/js/hooks/anonymous_storage.js and wire it in assets/js/app.js
- [ ] T006 Implement local import endpoint in lib/moeru_web/controllers/local_import_controller.ex and route it in lib/moeru_web/router.ex
- [ ] T007 [P] Add exercise catalog/custom schemas in lib/moeru/exercises/exercise_catalog_entry.ex and lib/moeru/exercises/custom_exercise_entry.ex with migrations in priv/repo/migrations/*_create_exercise_catalog_entries.exs and priv/repo/migrations/*_create_custom_exercise_entries.exs
- [ ] T008 Seed exercise catalog entries in priv/repo/seeds.exs
- [ ] T033 [P] Add user preferences and 1RM schemas in lib/moeru/accounts/user_preference.ex and lib/moeru/accounts/exercise_max.ex with migrations in priv/repo/migrations/*_create_user_preferences.exs and *_create_exercise_maxes.exs
- [ ] T034 [P] Add shared measurement/unit validation helpers in lib/moeru/workouts/measurement.ex (unit enums, mixed-unit checks, and normalization rules)
- [ ] T035 [P] Add anonymous-to-account association flow in lib/moeru_web/controllers/local_import_controller.ex and lib/moeru_web/router.ex (import local data after sign-up)

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Log Strength Workout (Priority: P1) 

**Goal**: Users can log strength sessions with prescriptions and actuals.

**Independent Test**: Create a strength session with multiple exercises and confirm prescriptions and actuals are persisted and rendered.

### Tests

> TDD note: Use spec.md acceptance scenarios and functional requirements as the source of truth for these tests.

- [ ] T009 [P] [US1] Add LiveView tests for strength logging in test/moeru_web/live/workouts/strength_live_test.exs
- [ ] T010 [P] [US1] Add context tests for strength prescriptions and target evaluation in test/moeru/workouts/strength_prescription_test.exs
- [ ] T036 [P] [US1] Add tests for unit validation and mixed-unit blocking in test/moeru/workouts/strength_units_test.exs
- [ ] T037 [P] [US1] Add tests for percent prescriptions using 1RM or explicit working weight in test/moeru/workouts/strength_percent_test.exs

### Implementation

- [ ] T011 [US1] Add workout session and strength schemas in lib/moeru/workouts/workout_session.ex, lib/moeru/workouts/strength_exercise_entry.ex, lib/moeru/workouts/strength_set_performance.ex with migrations in priv/repo/migrations/*_create_workout_sessions.exs, *_create_strength_exercise_entries.exs, *_create_strength_set_performances.exs
- [ ] T012 [US1] Implement strength context operations in lib/moeru/workouts.ex (create/update sessions, add entries, add sets, preload associations)
- [ ] T013 [P] [US1] Implement prescription parsing and target evaluation in lib/moeru/workouts/strength_prescription.ex
- [ ] T014 [US1] Build strength logging LiveView in lib/moeru_web/live/workouts/strength_live.ex (forms using `<.input>`, stream entries)
- [ ] T015 [P] [US1] Add API endpoints for sessions and strength entries/sets in lib/moeru_web/controllers/workout_controller.ex, lib/moeru_web/controllers/strength_entry_controller.ex, lib/moeru_web/controllers/strength_set_controller.ex and routes in lib/moeru_web/router.ex
- [ ] T038 [US1] Add unit fields and mixed-unit guards to strength changesets and LiveView validation in lib/moeru/workouts/strength_exercise_entry.ex and lib/moeru_web/live/workouts/strength_live.ex
- [ ] T039 [US1] Build exercise catalog + custom selector UI in lib/moeru_web/live/workouts/strength_live.ex (catalog search, custom add)

**Checkpoint**: Strength logging is functional and independently testable

---

## Phase 4: User Story 2 - Log Cardio Workout (Priority: P2)

**Goal**: Users can log LSS and HIIT cardio sessions with per-round actuals.

**Independent Test**: Log one LSS session (derive missing value) and one HIIT interval session with per-round actuals.

### Tests

> TDD note: Use spec.md acceptance scenarios and functional requirements as the source of truth for these tests.

- [ ] T016 [P] [US2] Add LiveView tests for cardio logging in test/moeru_web/live/workouts/cardio_live_test.exs
- [ ] T017 [P] [US2] Add context tests for cardio derivation in test/moeru/workouts/cardio_interval_test.exs
- [ ] T040 [P] [US2] Add tests for cardio totals derivation and single-metric validation in test/moeru/workouts/cardio_totals_test.exs

### Implementation

- [ ] T018 [US2] Add cardio interval schemas in lib/moeru/workouts/cardio_interval_entry.ex and lib/moeru/workouts/cardio_interval_round_performance.ex with migrations in priv/repo/migrations/*_create_cardio_interval_entries.exs and *_create_cardio_interval_round_performances.exs
- [ ] T019 [US2] Implement per-round cardio derivation and validation in lib/moeru/workouts/cardio_interval.ex (accept any two round metrics, derive third, store all three)
- [ ] T020 [US2] Implement cardio prescription parsing and target evaluation in lib/moeru/workouts/cardio_prescription.ex
- [ ] T021 [US2] Build cardio logging LiveView in lib/moeru_web/live/workouts/cardio_live.ex (interval form + per-round actuals)
- [ ] T022 [P] [US2] Add API endpoints for cardio intervals and rounds in lib/moeru_web/controllers/cardio_interval_controller.ex, lib/moeru_web/controllers/cardio_round_controller.ex and routes in lib/moeru_web/router.ex
- [ ] T041 [US2] Implement cardio totals derivation and mixed-unit guards in lib/moeru/workouts/cardio_interval.ex and lib/moeru_web/live/workouts/cardio_live.ex

**Checkpoint**: Cardio logging is functional and independently testable

---

## Phase 5: User Story 3 - Review Workout History (Priority: P3)

**Goal**: Users can browse session history and see details for each workout.

**Independent Test**: After logging strength and cardio sessions, verify list and detail views show correct summaries.

### Tests

> TDD note: Use spec.md acceptance scenarios and functional requirements as the source of truth for these tests.

- [ ] T023 [P] [US3] Add LiveView tests for history list/detail in test/moeru_web/live/workouts/history_live_test.exs
- [ ] T024 [P] [US3] Add context tests for history queries in test/moeru/workouts/history_test.exs

### Implementation

- [ ] T025 [US3] Implement history queries with preloads in lib/moeru/workouts.ex (list sessions, get session with entries)
- [ ] T026 [US3] Build history LiveView list/detail with edit/delete actions in lib/moeru_web/live/workouts/history_live.ex using streams
- [ ] T027 [US3] Add history routes in lib/moeru_web/router.ex
- [ ] T028 [US3] Add edit/delete API endpoints for sessions in lib/moeru_web/controllers/workout_controller.ex and routes in lib/moeru_web/router.ex

**Checkpoint**: History view is functional and independently testable

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T029 [P] Add anonymous-mode warning UI in lib/moeru_web/live/workouts/strength_live.ex, lib/moeru_web/live/workouts/cardio_live.ex, lib/moeru_web/live/workouts/history_live.ex
- [ ] T030 [P] Add empty states and loading feedback in lib/moeru_web/live/workouts/strength_live.ex, lib/moeru_web/live/workouts/cardio_live.ex, lib/moeru_web/live/workouts/history_live.ex
- [ ] T031 [P] Update CLI/API usage notes in specs/001-fitness-workout-tracking/quickstart.md
- [ ] T032 Run quickstart smoke test steps and record any gaps in specs/001-fitness-workout-tracking/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational
- **User Story 2 (P2)**: Can start after Foundational
- **User Story 3 (P3)**: Can start after User Stories 1 and 2 to ensure data is available for history

### Parallel Opportunities

- Foundational: T004, T005, and T007 can be done in parallel
- User Story 1: T009 and T013 can run in parallel with schema work after T011 starts
- User Story 2: T016 and T022 can run in parallel with schema work after T018 starts
- User Story 3: T023 and T028 can run in parallel with T025 and T026
- Polish: T029 and T031 can run in parallel

---

## Parallel Example: User Story 1

```bash
# Parallel work for strength logging
Task: "Implement prescription parsing and target evaluation in lib/moeru/workouts/strength_prescription.ex"
Task: "Add API endpoints for sessions and strength entries/sets in lib/moeru_web/controllers/workout_controller.ex"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Validate strength logging flow independently

### Incremental Delivery

1. Add User Story 2 and validate cardio logging independently
2. Add User Story 3 and validate history views
3. Finish Polish tasks
