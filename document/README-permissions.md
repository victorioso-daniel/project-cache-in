# Permissions & Roles — IntelliQuiz (IQ)

This document describes the Role-Based Access Control (RBAC) model for IntelliQuiz.

Principles:
- Least privilege: give the minimum permissions needed to each role.
- Role-based mapping: users are assigned roles and roles have multiple permissions.
- Singular table naming conventions (e.g., `user`, `role`, `permission`).

Default roles (least privilege model):
- admin (full privileges) — Admins control the application and system.
- quizmaster — Proctors; can publish and reveal questions but cannot preview answers. The quizmaster's screen is the one shown to the live audience (blind proctoring: no preview before reveal).
- participant — Team members; can view questions and submit answers. They have zero administrative capabilities.

See `documents/ddl/roles_permissions.sql` for the DDL and seed data.

Notes:
- There are only 3 roles: `admin`, `quizmaster`, `participant`.
- Use `user_role` join table for user-role assignments (supports multi-role in future if needed).
- Admin accounts are special and should be provisioned carefully; only Admins can assign roles and grant permissions.

If you would like a JSON-based access control configuration exported, or want a versioned migration file, I can create that as well.
