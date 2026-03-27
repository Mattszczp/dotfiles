# Goose Migrations (Go + PostgreSQL)

## Setup

```go
// go.mod
require github.com/pressly/goose/v3 v3.x.x
```

Common pattern — embed migrations in the binary:

```go
// internal/db/migrations.go
package db

import "embed"

//go:embed migrations/*.sql
var Migrations embed.FS
```

```go
// Run at startup
import "github.com/pressly/goose/v3"

if err := goose.SetDialect("postgres"); err != nil {
    log.Fatal(err)
}
if err := goose.Up(db, "internal/db/migrations"); err != nil {
    log.Fatal(err)
}
```

## File Naming

```
internal/db/migrations/
  00001_create_users.sql
  00002_create_posts.sql
  00003_add_user_role.sql
```

Format: `{version}_{description}.sql` — version is a sequential number, padded.

## Migration File Structure

```sql
-- +goose Up
CREATE TABLE users (
    id          UUID        NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    email       TEXT        NOT NULL UNIQUE,
    name        TEXT        NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);

-- +goose Down
DROP TABLE users;
```

The `-- +goose Up` and `-- +goose Down` annotations are required. Always write the
`Down` migration — you'll thank yourself when you need to roll back in dev.

## Writing Good Migrations

**Each migration should be atomic.** One logical change per file. Don't combine
creating a table and adding a foreign key to another table in one migration if they
could reasonably be separate.

**Non-destructive changes are safe.** Adding a nullable column, adding an index,
adding a table — these can run without locking concerns on live data.

**Destructive changes need care.** Dropping a column, renaming a column, changing a
type — coordinate with the application code deploy. Consider a multi-step migration
(add new column → backfill → drop old column) for zero-downtime changes.

**Use transactions for DML in migrations:**

```sql
-- +goose Up
-- +goose StatementBegin
BEGIN;
UPDATE users SET role = 'member' WHERE role IS NULL;
COMMIT;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
BEGIN;
UPDATE users SET role = NULL WHERE role = 'member';
COMMIT;
-- +goose StatementEnd
```

Use `-- +goose StatementBegin` / `-- +goose StatementEnd` for multi-statement
migrations or when using PL/pgSQL.

## Common Migration Patterns

**Add a column with a default:**
```sql
-- +goose Up
ALTER TABLE users ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE;

-- +goose Down
ALTER TABLE users DROP COLUMN is_active;
```

**Add a foreign key:**
```sql
-- +goose Up
ALTER TABLE posts
    ADD COLUMN user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE;

CREATE INDEX idx_posts_user_id ON posts(user_id);

-- +goose Down
DROP INDEX idx_posts_user_id;
ALTER TABLE posts DROP COLUMN user_id;
```

**Rename a column (zero-downtime approach):**
```sql
-- Step 1: add new column
-- +goose Up
ALTER TABLE users ADD COLUMN display_name TEXT;
UPDATE users SET display_name = username;
ALTER TABLE users ALTER COLUMN display_name SET NOT NULL;

-- +goose Down
ALTER TABLE users DROP COLUMN display_name;
```
Then in a later migration, drop the old column after the app no longer uses it.

## CLI Commands

```bash
goose -dir internal/db/migrations postgres "$DATABASE_URL" up        # apply all pending
goose -dir internal/db/migrations postgres "$DATABASE_URL" up-by-one # apply one
goose -dir internal/db/migrations postgres "$DATABASE_URL" down       # roll back one
goose -dir internal/db/migrations postgres "$DATABASE_URL" status     # show state
goose -dir internal/db/migrations postgres "$DATABASE_URL" create add_user_role sql
```
