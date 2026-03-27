# SQLite — Embedded & Test Databases

## When to Use SQLite

- **Testing in Go** — fast, zero-setup, in-memory database for integration tests
- **Desktop apps** — Tauri or Electron apps needing a local database
- **Prototyping** — when you haven't committed to PostgreSQL yet

Don't use SQLite in a web server context where multiple processes or high write
concurrency is expected — use PostgreSQL there.

## Go: SQLite for Tests

Use `modernc.org/sqlite` (pure Go, no CGo) or `mattn/go-sqlite3` (CGo, faster):

```go
// go.mod
require modernc.org/sqlite v1.x.x  // no CGo required
```

```go
// internal/testutil/db.go
package testutil

import (
    "database/sql"
    "testing"
    _ "modernc.org/sqlite"
)

// NewTestDB creates an in-memory SQLite DB, runs migrations, and returns it.
// The DB is closed automatically when the test ends.
func NewTestDB(t *testing.T) *sql.DB {
    t.Helper()

    db, err := sql.Open("sqlite", ":memory:?_foreign_keys=on")
    if err != nil {
        t.Fatalf("open sqlite: %v", err)
    }

    t.Cleanup(func() { db.Close() })

    if err := runMigrations(db); err != nil {
        t.Fatalf("run migrations: %v", err)
    }

    return db
}
```

Always enable foreign keys — SQLite has them off by default:
```
?_foreign_keys=on   // DSN parameter
// or
PRAGMA foreign_keys = ON;
```

## Go: Schema Compatibility Between PG and SQLite

Write migrations that work for both, or maintain separate migration sets. Key
differences to handle:

```sql
-- PostgreSQL
id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY

-- SQLite equivalent
id TEXT NOT NULL DEFAULT (lower(hex(randomblob(16)))) PRIMARY KEY
```

```sql
-- PostgreSQL
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

-- SQLite equivalent (ISO 8601 string)
created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
```

A common pattern is to use build tags to select the right migration set:

```go
//go:build !sqlite

// postgres migrations
```

```go
//go:build sqlite

// sqlite migrations
```

## Drizzle + SQLite (Tauri/Electron)

```ts
// drizzle.config.ts
import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  schema: './src/lib/db/schema.ts',
  out: './drizzle',
  dialect: 'sqlite',
  dbCredentials: {
    url: './app.db',
  },
})
```

```ts
// src/lib/db/index.ts
import { drizzle } from 'drizzle-orm/better-sqlite3'
import Database from 'better-sqlite3'
import * as schema from './schema'

const sqlite = new Database('./app.db')
sqlite.pragma('journal_mode = WAL')   // better concurrent read performance
sqlite.pragma('foreign_keys = ON')

export const db = drizzle(sqlite, { schema })
```

**Schema for SQLite with Drizzle:**

```ts
import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core'
import { sql } from 'drizzle-orm'

export const users = sqliteTable('users', {
  id:        text('id').primaryKey().$defaultFn(() => crypto.randomUUID()),
  email:     text('email').notNull().unique(),
  name:      text('name').notNull(),
  isActive:  integer('is_active', { mode: 'boolean' }).notNull().default(true),
  createdAt: text('created_at').notNull().default(sql`(strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))`),
  updatedAt: text('updated_at').notNull().default(sql`(strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))`),
})
```

Note: SQLite has no native boolean — Drizzle maps `{ mode: 'boolean' }` to `0`/`1`
integers. Timestamps are stored as ISO 8601 text strings.

## WAL Mode

Always enable WAL mode for SQLite in production (desktop apps). It allows concurrent
reads while a write is in progress:

```sql
PRAGMA journal_mode = WAL;
```

Or in Go: `file:app.db?_journal_mode=WAL&_foreign_keys=on`

## Sharing Goose Migrations with SQLite

If you want one migration set for both databases, use goose's dialect-aware patterns
carefully, or keep SQLite migrations as a stripped-down test fixture:

```go
// For tests, you can skip goose entirely and just exec raw SQL:
func runMigrations(db *sql.DB) error {
    _, err := db.Exec(`
        CREATE TABLE IF NOT EXISTS users (
            id         TEXT PRIMARY KEY,
            email      TEXT NOT NULL UNIQUE,
            name       TEXT NOT NULL,
            created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
        );
        CREATE TABLE IF NOT EXISTS posts (
            id      TEXT PRIMARY KEY,
            user_id TEXT NOT NULL REFERENCES users(id),
            title   TEXT NOT NULL,
            body    TEXT NOT NULL
        );
        PRAGMA foreign_keys = ON;
    `)
    return err
}
```

For test databases, simplicity beats parity — you're testing your app logic, not
migration tooling.
