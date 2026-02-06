# Research: Fitness Workout Tracking

**Date**: 2026-02-06

## Decision 1: Use Phoenix LiveView forms with changesets and streams

**Decision**: Build workout logging and history views with LiveView forms (`to_form/2` + changesets) and render session lists via LiveView streams.

**Rationale**: This matches Phoenix LiveView best practices for validation, optimistic updates, and memory-safe lists, while keeping the UI reactive and data-first.

**Alternatives considered**:
- Controller + templates with full page reloads (simpler but loses LiveView UX).
- Client-only UI with a separate API (adds complexity without user benefit).

## Decision 2: Normalize workout data into relational tables

**Decision**: Model sessions, strength entries, strength sets, interval entries, interval rounds, and exercise data as separate tables with strong constraints.

**Rationale**: A normalized schema supports data-first design, preserves historical accuracy, and enables validation and analytics. It also avoids ambiguity when prescriptions and actuals evolve.

**Alternatives considered**:
- Store entries as JSON blobs in a single table (fewer tables, but hard to validate and query).
- Polymorphic single-table entries for all types (simpler schema, but weaker constraints).

## Decision 3: Anonymous data stored locally with optional import on signup

**Decision**: Store anonymous data in browser storage (IndexedDB) with a device identifier and import it into server-side storage when a user creates an account.

**Rationale**: This preserves privacy, works offline, and aligns with the requirement for local-only anonymous data while still allowing account association later.

**Alternatives considered**:
- Store anonymous data server-side under a temporary ID (simpler import, weaker privacy).
- Require authentication before usage (conflicts with anonymous usage requirement).

## Decision 4: Model LSS as a single-round interval

**Decision**: Represent LSS sessions as interval entries with `rounds = 1` and `rest = 0`, while allowing time+distance input with derived speed.

**Rationale**: This simplifies the data model and keeps LSS and interval logic unified without losing expressiveness.

**Alternatives considered**:
- Separate LSS table (clearer intent, but duplicates logic).
- Store only derived values (loses user input fidelity).
