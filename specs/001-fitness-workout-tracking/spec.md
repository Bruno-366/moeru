# Feature Specification: Fitness Workout Tracking

**Feature Branch**: `001-fitness-workout-tracking`  
**Created**: 2026-02-06  
**Status**: Draft  
**Input**: User description: "Build a fitness web app to track strength and cardio workouts with specific strength notation (3x5, 4x8-12, 8x3 @ 75%, 4x8-12 @ 2 RIR) and cardio formats (LSS and HIIT intervals), with no training plans or routines."

## Clarifications

### Session 2026-02-06

- Q: What authentication model should the app use? -> A: Allow anonymous usage with optional sign-up later.
- Q: How should percent-based prescriptions work when no 1RM is available? -> A: Allow saving with explicit working weight (no 1RM needed).
- Q: Where is anonymous data stored? -> A: Local-only (cleared on device/browser reset).
- Q: Should derived values (e.g., inferred LSS time/distance) be stored? -> A: Store all three values in the input fields after deriving the missing one, for both LSS and HIIT.
- Q: Will workouts be logged via both web UI and API? -> A: Yes, web UI is primary and a public API can support CLI usage.
- Q: How should exercises be selected? -> A: Hybrid: catalog with option to add custom entries.
- Q: How should LSS be modeled and what inputs are allowed? -> A: Model LSS as an interval with 1 round; allow time + distance input and derive speed when provided.
- Q: Should interval sessions capture per-round actuals? -> A: Yes, users should be able to log actuals per round.

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Log Strength Workout (Priority: P1)

As a user, I can record a strength workout using common prescription notation and log what I actually performed.

**Why this priority**: Strength tracking is the core use case and delivers immediate value even without other features.

**Independent Test**: Create a strength session with multiple exercises and confirm the system stores the intended prescription and the actual performance.

**Acceptance Scenarios**:

1. **Given** I am starting a strength session, **When** I add an exercise with a prescription like "3x5", **Then** the system saves the target as 3 sets of 5 reps.
2. **Given** a prescription with a rep range like "4x8-12", **When** I log completion with at least 8 reps for each set, **Then** the system marks the target as met but does not require progression until 12 reps are achieved.
3. **Given** a prescription with a percent like "8x3 @ 75%", **When** I select a 1RM value for the exercise, **Then** the system records the target load as 75% of that 1RM.
4. **Given** a prescription with RIR like "4x8-12 @ 2 RIR", **When** I save the session, **Then** the system stores the intended RIR and applies it to the target interpretation for that exercise.

---

### User Story 2 - Log Cardio Workout (Priority: P2)

As a user, I can record cardio workouts in either steady pace (LSS) or interval (HIIT) formats.

**Why this priority**: Cardio tracking is the second core activity and must be supported independently of strength.

**Independent Test**: Log one LSS session and one interval session and verify the system stores the correct fields for each.

**Acceptance Scenarios**:

1. **Given** I am logging an LSS workout, **When** I enter time and distance, **Then** the system stores the inputs and derives speed.
2. **Given** I am logging an LSS workout, **When** I enter time and speed, **Then** the system stores the inputs and derives distance.
3. **Given** I am logging an LSS workout, **When** I enter distance and speed, **Then** the system stores the inputs and derives time.
4. **Given** I am logging intervals with "Work : Rest x Rounds", **When** I enter work duration or distance, rest time, and number of rounds, **Then** the system stores those values as a structured interval plan.

---

### User Story 3 - Review Workout History (Priority: P3)

As a user, I can review past workouts to see what I intended to do and what I completed.

**Why this priority**: History makes tracking meaningful and ensures users can verify progress over time.

**Independent Test**: After logging at least one strength and one cardio session, confirm they appear in a history list with key details.

**Acceptance Scenarios**:

1. **Given** I have logged previous workouts, **When** I open the history view, **Then** I see a list of sessions with date, type, and summary metrics.
2. **Given** I select a past session, **When** I view its details, **Then** I can see the target prescription and the actual performance for each entry.

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

- Strength entry includes a rep range and RIR; the system preserves both and does not drop either value.
- Percent-based prescriptions when no 1RM is available for the exercise; allow explicit working weight entry.
- LSS entry provides only time or distance without a second value; the system does not infer the missing value.
- Interval entry has zero rounds or rest time; the system blocks invalid values and explains the issue.
- Mixed units in a session (e.g., distance in miles, speed in km/h); the system prevents inconsistent units or prompts correction.
- Anonymous data loss after browser reset or data clearing; the system warns users when they are not signed in.

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: System MUST allow users to create and save strength workout sessions with multiple exercises.
- **FR-002**: System MUST support strength prescriptions for fixed reps (e.g., 3x5) and rep ranges (e.g., 4x8-12).
- **FR-003**: System MUST support percent-based prescriptions (e.g., 8x3 @ 75%) by associating the target with a user-provided 1RM for that exercise.
- **FR-003a**: When a 1RM is not available, system MUST allow users to enter an explicit working weight for percent-based prescriptions.
- **FR-004**: System MUST support RIR notation (e.g., 4x8-12 @ 2 RIR) and store the intended RIR as part of the prescription.
- **FR-005**: System MUST allow users to record actual performance (sets, reps, load, and notes) for each strength exercise entry.
- **FR-006**: System MUST determine and display whether a strength target is met based on the prescription rules (e.g., rep range floor met, percent-based load recorded).
- **FR-007**: System MUST allow users to create and save cardio workout sessions in LSS and interval formats.
- **FR-008**: System MUST model LSS workouts as intervals with 1 round and a rest value of 0.
- **FR-009**: For cardio interval entries (LSS and HIIT), system MUST accept any two of time, distance, and speed, derive the third, and store all three.
- **FR-010**: When one cardio field is derived (speed, time, or distance), system MUST store all three values together in the input fields.
- **FR-011**: For interval workouts, system MUST capture work duration or distance, rest time, and number of rounds, with a uniform value per round.
- **FR-011a**: System MUST allow users to log actual work and rest values per round for interval workouts.
- **FR-012**: System MUST prevent creation of training plans or routines; only individual sessions are supported.
- **FR-013**: System MUST allow users to view, edit, and delete previously logged sessions.
- **FR-014**: System MUST store units of measure (weight, distance, time, speed) alongside the values entered by the user.
- **FR-015**: System MUST allow anonymous usage without account creation.
- **FR-016**: System MUST allow users to create an account later and associate existing anonymous data with that account.
- **FR-017**: System MUST store anonymous data locally and warn users that data can be lost if browser storage is cleared.
- **FR-018**: System MUST provide a predefined exercise catalog and allow users to add custom exercise names.

### Key Entities *(include if feature involves data)*

- **User**: Represents an individual account with unit preferences and personal bests (e.g., 1RM values).
- **Exercise Catalog Entry**: A predefined exercise name available for selection.
- **Custom Exercise Entry**: A user-defined exercise name associated with that user.
- **Workout Session**: A dated log of a single workout, tagged as strength or cardio, with summary fields.
- **Strength Exercise Entry**: A single exercise within a strength session, including prescription, RIR, and percent targets.
- **Strength Set Performance**: The actual sets performed for a strength entry (reps, load, completion notes).
- **Cardio Interval Round Performance**: The actual work and rest values logged for each interval round.
- **Cardio Interval Entry**: A cardio session entry with work duration or distance, rest time, rounds, and unit metadata. LSS is represented as an interval entry with 1 round and rest 0.

## Assumptions

- The app supports anonymous users with local-only storage and optional account creation; shared or coach-managed accounts are out of scope.
- Users supply or update their own 1RM values; the system does not estimate 1RM automatically.
- No automatic training plans, routines, or scheduling are included.
- Unit preferences are stored per user, but entries preserve the unit used at the time of logging.
- Derived values are stored alongside user-entered values in the input fields for both LSS and HIIT.
- The API supports first-party clients (web UI and CLI); third-party integrations are out of scope.

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: 90% of users can log a strength workout with at least 3 exercises in under 3 minutes on first attempt.
- **SC-002**: 90% of users can log an LSS or interval cardio workout in under 2 minutes on first attempt.
- **SC-003**: 95% of saved workouts display a correct target-met status based on the recorded prescription rules.
- **SC-004**: Users can access their workout history list in under 2 seconds for up to 200 sessions.
