CREATE TABLE profile_complaint_report (
  profile_id uuid PRIMARY KEY REFERENCES profile(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),

  is_expired boolean DEFAULT false,

  type text,
  content jsonb
);

-- Enables fast index only scans.
CREATE INDEX profile_complaint_report__not_expired__idx (profile_id, created_at)
 WHERE is_expred IS false;

ALTER TABLE profile_complaint_report
  ALTER COLUMN type SET STORAGE external,
  ALTER COLUMN content SET STORAGE external;

ALTER TABLE profile
  ADD COLUMN is_mutted boolean DEFAULT false,
  ADD COLUMN auth_backend text NULL;

ALTER TABLE profile
  ALTER COLUMN auth_backend SET STORAGE external;

UPDATE profile
   SET auth_backend = 'google'
 WHERE password = '!';

UPDATE profile
   SET auth_backend = 'penpot'
 WHERE password != '!';

-- Table storing a permanent complaint table for register all
-- permanent bounces and spam reports (complaints) and avoid sending
-- more emails there.
CREATE TABLE global_complaint_report (
  email text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),

  content jsonb,

  PRIMARY KEY (email, created_at)
);
