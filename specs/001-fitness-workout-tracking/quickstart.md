# Quickstart: Fitness Workout Tracking

## Prerequisites

- Elixir 1.15+
- PostgreSQL 14+

## Setup

1) Install dependencies and setup the database:

```
mix setup
```

2) Start the Phoenix server:

```
mix phx.server
```

3) Open the app in the browser:

```
http://localhost:4000
```

## Feature Smoke Test

1) Create a strength workout session with a prescription like "3x5" and log actual sets.
2) Create an LSS cardio session by entering time + distance and verify derived speed is shown.
3) Create a HIIT interval session and log per-round actuals.
4) Open history and confirm sessions are listed with summaries.

## Notes

- Anonymous sessions are stored locally in the browser; clearing browser storage will remove them.
- When a user signs up later, local data should be imported into the account.
