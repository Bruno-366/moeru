# Data Model: Fitness Workout Tracking

## Entity: User

**Purpose**: Represents an account with unit preferences and personal maxes.

**Fields**:
- id
- email (nullable when anonymous)
- weight_unit (kg, lb)
- distance_unit (km, mi, m)
- speed_unit (km/h, mi/h, m/s)
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

**Purpose**: Stores user maxes per exercise (1RM or other max types).

**Fields**:
- id
- user_id
- exercise_catalog_entry_id (nullable)
- custom_exercise_entry_id (nullable)
- max_type (one_rm, five_rm, etc)
- value
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
- rest_time_unit
- input_time_seconds (nullable)
- input_distance (nullable)
- input_speed (nullable)
- derived_time_seconds (nullable)
- derived_distance (nullable)
- derived_speed (nullable)

**Relationships**:
- belongs to WorkoutSession
- has many CardioIntervalRoundPerformance

**Validations**:
- rounds >= 1
- work_value > 0
- rest_value >= 0
- interval_type = lss implies rounds = 1 and rest_value = 0
- for LSS inputs, require any two of time, distance, speed and store the derived third

## Entity: CardioIntervalRoundPerformance

**Purpose**: Actual values logged per interval round.

**Fields**:
- id
- cardio_interval_entry_id
- round_index
- actual_work_value
- actual_rest_value
- time_unit (nullable)
- distance_unit (nullable)
- notes (nullable)

**Relationships**:
- belongs to CardioIntervalEntry

**Validations**:
- round_index > 0
- actual_work_value > 0
- actual_rest_value >= 0

## State Transitions

- WorkoutSession is created as a single log and can be edited or deleted; no additional states.
