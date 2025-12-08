---
title: Intelliquiz Backend - ER Diagram
---

# Intelliquiz Backend - ER Diagram

Below is the mermaid ER diagram representation of the database schema for the Intelliquiz backend.

```mermaid
erDiagram
    %% 1. USERS
    USER {
        int id PK
        string username
        string password_hash
    }

    %% 1b. ROLES (New Table)
    ROLES {
        int id PK
        string role_name
        string permissions "json|csv|text"
    }

    %% 2. QUIZ_EVENT
    QUIZ_EVENT {
        int id PK
        string title
        string status
        string proctor_code
        int pts_easy
        int pts_medium
        int pts_hard
        timestamp created_at
    }

    %% 3. TEAM
    TEAM {
        int id PK
        int quiz_event_id FK
        string name
        string access_code
    }

    %% 4. QUESTION
    QUESTION {
        int id PK
        int quiz_event_id FK
        string text
        string type
        string difficulty
        string correct_answer_text
        int timer_seconds
        int sequence_order
        boolean is_revealed
    }

    %% 5. QUESTION_CHOICE (New for 1NF)
    QUESTION_CHOICE {
        int id PK
        int question_id FK
        string label "A, B, C, D"
        string text
    }

    %% 6. SUBMISSION (Transactional)
    SUBMISSION {
        int id PK
        int team_id FK
        int question_id FK
        string submitted_text
        timestamp submitted_at
    }

    %% 7. EVENT_WINNER (Historical Snapshot - Optional but recommended)
    EVENT_WINNER {
        int id PK
        int quiz_event_id FK
        int team_id FK
        int rank_position
        int final_score
    }

    %% Relationships
    ROLE ||--|{ USER : "defines"
    USER ||--|{ QUIZ_EVENT : "manages"
    ROLE ||--|{ ROLE_PERMISSION : "grants"
    PERMISSION ||--|{ ROLE_PERMISSION : "defines"
    USER ||--|{ USER_ROLE : "belongs_to"
    ROLE ||--|{ USER_ROLE : "grants_role"
    QUIZ_EVENT ||--|{ TEAM : "hosts"
    QUIZ_EVENT ||--|{ QUESTION : "contains"
    TEAM ||--|{ SUBMISSION : "submits"
    QUESTION ||--|{ SUBMISSION : "receives"
    QUESTION ||--|{ QUESTION_CHOICE : "has_options"
    QUIZ_EVENT ||--|{ EVENT_WINNER : "records"
    TEAM ||--|{ EVENT_WINNER : "achieves"
```

> ⚠️ Note: Mermaid ER syntax can differ slightly between versions; the code above uses mermaid's `erDiagram` notation and relationship symbols (e.g., `||--|{`). If your target renderer differs, small symbol changes may be needed.

---

If you'd like this saved as a different filename or in a different folder, tell me the desired path and I'll update it.
