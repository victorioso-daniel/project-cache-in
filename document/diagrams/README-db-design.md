# IntelliQuiz Database Design Overview

This directory contains the three design levels of the IntelliQuiz database model:

- `conceptual-db.mmd` - High-level conceptual model describing the major entities and relationships at a business level. Ideal for stakeholders to understand the main entities (User, Role, QuizEvent, Team, Question).

- `logical-db.mmd` - Normalized logical model describing tables and attributes, primary/foreign keys, and many-to-many junctions (like `role_permission` and `user_role`). This model abstracts away physical types.

- `physical-db.mmd` - Physical model that maps tables to real database column types, includes index & constraint suggestions, and notes for performance.

Guidelines:
- All table names use singular naming conventions per the project's design.
- Users are assigned roles through `user_role` (not a `user.role_id` column), enabling least-privilege, multi-role support.
- `role_permission` supports fine-grained permissions for roles; seed entries are included in the project's migrations.

Where to use:
- Conceptual model: Stakeholder reviews
- Logical model: Schema design & application modeling
- Physical model: DBA, migrations, and optimization guidance

If you'd like, I can:
1. Convert the Mermaid `.mmd` files into `SVG/PDF` exports for documentation.
2. Automatically add the `V3__add_idempotent_permissions_migration.sql` file to the migration folder to make permission seeding safe and idempotent.
3. Create the baseline Flyway `V0__baseline.sql` if you want to mark an existing DB as baseline.

Which would you like me to do next?
