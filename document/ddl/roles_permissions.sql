-- DDL for Roles & Permission model (Postgres)

-- 1. Role table (singular)
CREATE TABLE role (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- 2. Permission table (singular)
CREATE TABLE permission (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- 3. Role-Permission join table (singular)
CREATE TABLE role_permission (
    role_id INT NOT NULL REFERENCES role(id) ON DELETE CASCADE,
    permission_id BIGINT NOT NULL REFERENCES permission(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- 4. Optional: allow multiple roles per user
CREATE TABLE user_role (
    id BIGSERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    role_id INT NOT NULL REFERENCES role(id) ON DELETE CASCADE,
    CONSTRAINT user_role_unique UNIQUE (user_id, role_id)
);

-- 5. Keep single-role FK on user (optional): user.role_id if you prefer single role model.
-- You can either keep 'user.role_id' (for single role) or rely on the user_role join table for multi-role.

-- 6. Minimal permissions seed (least privilege): create base permission records
INSERT INTO permission (name, description) VALUES
('system.manage_system','Full system control; use sparingly.'),
('system.manage_roles','Create/update/delete roles'),
('event.create','Create a new quiz event'),
('event.view','View event details, only active event view by default'),
('event.edit','Edit event configuration'),
('event.activate','Activate an event (open session)'),
('event.close','Close/Deactivate an event'),
('question.create','Create questions for event'),
('question.edit','Edit question content and metadata'),
('question.publish','Publish question to an event'),
('question.reveal_answer','Reveal correct answer after submission window'),
('question.preview_answer','Preview correct answer (admin only)'),
('submission.submit_answer','Submit answer to a question'),
('submission.view_all','View all submissions (scorekeeper/admin)'),
('team.create','Create and register teams'),
('team.view','View team details'),
('scoreboard.view','View live scoreboard'),
('scoreboard.pause','Pause scoreboard updates'),
('scoreboard.manual_update','Manual score corrections'),
('winners.assign','Assign winners and ranks'),
('data.import_questions','Bulk import questions'),
('data.export_results','Export final results'),
('user.manage_accounts','Create, disable, edit users'),
('user.assign_roles','Assign roles to users');

-- 7. Seed roles
INSERT INTO role (name, description) VALUES
('admin', 'System administrator with full permission'),
('quizmaster', 'Proctor / Quiz Master with limited controls'),
('participant', 'Player / Team member');

-- 8. Map permissions to roles (least privilege mapping)
-- Admin gets everything
INSERT INTO role_permission (role_id, permission_id)
SELECT r.id, p.id
FROM role r, permission p
WHERE r.name = 'admin';

INSERT INTO role_permission (role_id, permission_id)
SELECT r.id, p.id
FROM role r, permission p
WHERE r.name = 'quizmaster' AND p.name IN (
  'event.view','question.publish','question.reveal_answer','scoreboard.view','scoreboard.pause','event.activate','event.close'
);

-- Participant minimal permissions
INSERT INTO role_permission (role_id, permission_id)
SELECT r.id, p.id
FROM role r, permission p
WHERE r.name = 'participant' AND p.name IN (
  'event.view','question.view','submission.submit_answer','team.view'
);

-- Audience minimal permissions
-- Scorekeeper permissions
-- Scorekeeper role removed: only Admin, QuizMaster, Participant exist.

-- Notes:
--  - ADMIN has everything via the earlier insert. If you want to restrict admin to a curated list instead of all, replace the admin insert with a list.
--  - Consider seeding a default 'system.manage_roles' entry for admin only.
--  - For multi-role scenarios, prefer using the user_role mapping.

-- 9. Recommended indexes (for performance)
CREATE INDEX idx_permission_name ON permission (name);
CREATE INDEX idx_role_name ON role (name);
CREATE INDEX idx_user_role_user_id ON user_role (user_id);

-- End of DDL
