---
name: db-schema
description: >
  Design, review, and evolve database schemas. Use this skill whenever the user wants
  to model data, design tables, write migrations, think through relationships, or
  discuss database structure. Covers PostgreSQL as the primary target with goose
  migrations (Go projects) and Drizzle ORM (TypeScript/SvelteKit projects), and SQLite
  for embedded and test use cases. Trigger on mentions of schema, tables, migrations,
  relations, indexes, foreign keys, normalization, Drizzle, goose, or any request
  to store or model data — even if phrased as "how should I structure this?" or
  "what's the best way to store X?"
---

# DB Schema Skill

Your job is to help the user think through their data model clearly, then translate
that into correct, production-ready SQL and/or ORM schema code.

Start by understanding the domain, not jumping to tables. Ask: what are the core
entities? What are the relationships? What queries does the application need to run?
The schema should serve the queries — not the other way around.

## Detect the Context

Look at the project files to understand the setup before writing anything:

- `go.mod` present → Go project, use goose migrations → read `references/goose.md`
- `drizzle.config.ts` or `drizzle` in `package.json` → TypeScript project → read `references/drizzle.md`
- Both present → monorepo, read both
- SQLite context (Tauri, Electron, test files) → read `references/sqlite.md`

## Schema Design Principles

**Start simple, evolve deliberately.** Don't try to model every future requirement
upfront. Get the core entities right, and add columns/tables when you actually need
them. Migrations are cheap.

**Name things clearly and consistently.** Pick a convention and stick to it:
- Tables: plural snake_case (`users`, `blog_posts`, `order_items`)
- Primary keys: `id` (not `user_id` on the `users` table)
- Foreign keys: `{singular_table}_id` (`user_id`, `post_id`)
- Timestamps: `created_at`, `updated_at` — always include them
- Booleans: `is_active`, `has_verified_email` — prefix with `is_` or `has_`

**Use UUIDs or ULIDs for IDs exposed externally.** Sequential integer IDs leak
information (record count, creation order). Use `gen_random_uuid()` in Postgres or
`uuid_generate_v4()`. ULIDs are sortable and a good choice if order matters.

**Prefer nullable columns only when null is meaningful.** If a column is always
required, add `NOT NULL`. Don't default everything to nullable "just in case."

**Soft deletes vs. hard deletes.** Soft deletes (`deleted_at TIMESTAMPTZ`) add
complexity to every query. Only use them if you genuinely need audit history or
recovery. Otherwise, hard delete and archive if needed.

## Indexing Strategy

Write the queries first, then add indexes to support them. Don't index speculatively.

- Always index foreign keys — Postgres doesn't do this automatically
- Index columns used in `WHERE`, `ORDER BY`, and `JOIN` conditions
- Consider partial indexes for common filtered queries: `WHERE deleted_at IS NULL`
- Composite indexes: column order matters — most selective column first
- `UNIQUE` constraints create an index automatically

```sql
-- Foreign key index
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Composite for a common query pattern
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- Partial index
CREATE INDEX idx_users_active ON users(email) WHERE deleted_at IS NULL;
```

## Common Patterns

**Timestamps on every table:**
```sql
created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
```
Add a trigger or handle `updated_at` in the application layer.

**Many-to-many junction table:**
```sql
CREATE TABLE post_tags (
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  tag_id  UUID NOT NULL REFERENCES tags(id)  ON DELETE CASCADE,
  PRIMARY KEY (post_id, tag_id)
);
```

**Enum-like columns:** Use a `CHECK` constraint for small, stable sets. Use a
reference table for sets that might grow.

```sql
-- Small, stable: use CHECK
status TEXT NOT NULL CHECK (status IN ('draft', 'published', 'archived'))

-- Growing set: use a reference table
CREATE TABLE statuses (id TEXT PRIMARY KEY);
INSERT INTO statuses VALUES ('draft'), ('published'), ('archived');
-- ...
status TEXT NOT NULL REFERENCES statuses(id)
```

## PostgreSQL vs SQLite Differences

When writing for both, note the key differences — read `references/sqlite.md` for
SQLite-specific guidance.

| Feature | PostgreSQL | SQLite |
|---------|-----------|--------|
| UUID type | `UUID` native | `TEXT` with `lower(hex(randomblob(16)))` |
| Timestamps | `TIMESTAMPTZ` | `TEXT` (ISO 8601) or `INTEGER` (Unix) |
| JSON | `JSONB` (indexable) | `TEXT` (no indexing) |
| Enums | Native `ENUM` type or `CHECK` | `CHECK` only |
| Foreign keys | Enforced by default | Must `PRAGMA foreign_keys = ON` |
| Auto-increment | `SERIAL` or `GENERATED ALWAYS AS IDENTITY` | `INTEGER PRIMARY KEY` |
