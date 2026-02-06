# Data Model: Fitness Workout Tracking

## Entity: User

**Purpose**: Represents an account with preferred display units and personal maxes.

**Fields**:
- id
- email (nullable when anonymous)
- weight_unit (kg, lb) - preferred display unit
- distance_unit (km, mi, m) - preferred display unit
- speed_unit (km/h, mi/h, m/s) - preferred display unit
- timezone
- inserted_at, updated_at

**Relationships**:
- has many WorkoutSession
- has many CustomExerciseEntry
- has many ExerciseMax

**Validations**:
- unit values must be from supported enums

## Entity: ExerciseCatalogEntry

**Purpose**: Predefined exercise list for selection.

**Fields**:
- id
- name (unique)
- inserted_at, updated_at

**Relationships**:
- referenced by StrengthExerciseEntry
- referenced by ExerciseMax

**Validations**:
- name required, unique

## Entity: CustomExerciseEntry

**Purpose**: User-defined exercise name.

**Fields**:
- id
- user_id
- name
- inserted_at, updated_at

**Relationships**:
- belongs to User
- referenced by StrengthExerciseEntry
- referenced by ExerciseMax

**Validations**:
- name required, unique per user

## Entity: ExerciseMax

**Purpose**: Stores user 1RM values per exercise (other maxes are converted before storage).

**Fields**:
- id
- user_id
- exercise_catalog_entry_id (nullable)
- custom_exercise_entry_id (nullable)
- value (1RM)
- unit
- measured_at

**Relationships**:
- belongs to User
- belongs to ExerciseCatalogEntry or CustomExerciseEntry

**Validations**:
- value > 0
- unit required
- only one of exercise_catalog_entry_id or custom_exercise_entry_id

## Entity: WorkoutSession

**Purpose**: A single logged workout session.

**Fields**:
- id
- user_id (nullable for anonymous local-only sessions)
- session_type (strength, cardio)
- performed_at
- duration_seconds (nullable)
- notes (nullable)
- inserted_at, updated_at

**Relationships**:
- belongs to User (nullable for local-only)
- has many StrengthExerciseEntry
- has many CardioIntervalEntry

**Validations**:
- session_type required
- performed_at required

## Entity: StrengthExerciseEntry

**Purpose**: Planned prescription and metadata for a strength exercise.

**Fields**:
- id
- workout_session_id
- exercise_catalog_entry_id (nullable)
- custom_exercise_entry_id (nullable)
- position
- target_sets
- target_reps_min
- target_reps_max (nullable)
- target_percent (nullable)
- target_rir (nullable)
- target_load (nullable, working weight)
- target_load_unit (nullable)
- prescription_raw (string)

**Relationships**:
- belongs to WorkoutSession
- belongs to ExerciseCatalogEntry or CustomExerciseEntry
- has many StrengthSetPerformance

**Validations**:
- target_sets > 0
- target_reps_min > 0
- if target_reps_max present, target_reps_max >= target_reps_min
- if target_percent present, 0 < target_percent <= 100
- target_rir >= 0 when present
- only one of exercise_catalog_entry_id or custom_exercise_entry_id
- planned prescription applies uniformly across all sets; actual set performance can vary

## Entity: StrengthSetPerformance

**Purpose**: Actual performed sets for a strength exercise.

**Fields**:
- id
- strength_exercise_entry_id
- position
- reps
- load (nullable)
- load_unit (nullable)
- rir (nullable)
- notes (nullable)

**Relationships**:
- belongs to StrengthExerciseEntry

**Validations**:
- reps > 0
- load >= 0 when present
- rir >= 0 when present

## Entity: CardioIntervalEntry

**Purpose**: A cardio interval definition (HIIT or LSS).

**Fields**:
- id
- workout_session_id
- interval_type (lss, hiit)
- position
- rounds
- work_type (time, distance)
- work_value
- work_time_unit (nullable)
- work_distance_unit (nullable)
- rest_value
- rest_type (time, distance)
- rest_time_unit (nullable)
- rest_distance_unit (nullable)

**Relationships**:
- belongs to WorkoutSession
- has many CardioIntervalRoundPerformance

**Validations**:
- rounds >= 1
- work_value > 0
- rest_value >= 0
- interval_type = lss implies rounds = 1 and rest_value = 0
- round metrics are stored in CardioIntervalRoundPerformance and derived per round
- work_type and rest_type may differ (e.g., distance work, time rest)
- planned interval values apply uniformly across all rounds; actual round performance can vary

## Entity: CardioIntervalRoundPerformance

**Purpose**: Actual values logged per interval round.

**Fields**:
- id
- cardio_interval_entry_id
- round_index
- round_time_seconds
- round_distance
- round_speed
- rest_value
- rest_type (time, distance)
- rest_time_unit (nullable)
- rest_distance_unit (nullable)
- notes (nullable)

**Relationships**:
- belongs to CardioIntervalEntry

**Validations**:
- round_index > 0
- round_time_seconds > 0
- round_distance > 0
- round_speed > 0
- rest_value >= 0
- require any two of time, distance, speed, derive the third in the UI/API, and store all three values for each round
- rest_type determines whether rest_time_unit or rest_distance_unit is required

## State Transitions

- WorkoutSession is created as a single log and can be edited or deleted; no additional states.
