# Drizzle ORM (TypeScript + PostgreSQL)

## Setup

```ts
// drizzle.config.ts
import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  schema: './src/lib/server/db/schema.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
})
```

```ts
// src/lib/server/db/index.ts
import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'
import * as schema from './schema'

const client = postgres(process.env.DATABASE_URL!)
export const db = drizzle(client, { schema })
```

## Schema Definition

```ts
// src/lib/server/db/schema.ts
import {
  pgTable, uuid, text, boolean, timestamp, index, uniqueIndex
} from 'drizzle-orm/pg-core'
import { relations } from 'drizzle-orm'

export const users = pgTable('users', {
  id:        uuid('id').primaryKey().defaultRandom(),
  email:     text('email').notNull().unique(),
  name:      text('name').notNull(),
  isActive:  boolean('is_active').notNull().default(true),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => ({
  emailIdx: uniqueIndex('idx_users_email').on(table.email),
}))

export const posts = pgTable('posts', {
  id:        uuid('id').primaryKey().defaultRandom(),
  userId:    uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  title:     text('title').notNull(),
  body:      text('body').notNull(),
  status:    text('status', { enum: ['draft', 'published', 'archived'] }).notNull().default('draft'),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
}, (table) => ({
  userIdIdx: index('idx_posts_user_id').on(table.userId),
}))
```

## Relations

Define relations separately from the table schema — they're used by Drizzle's
relational query API, not reflected in the DB:

```ts
export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}))

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, {
    fields: [posts.userId],
    references: [users.id],
  }),
}))
```

## Querying

**Relational queries** (preferred for joins — reads cleaner):

```ts
// Fetch user with their posts
const user = await db.query.users.findFirst({
  where: eq(users.id, userId),
  with: {
    posts: {
      where: eq(posts.status, 'published'),
      orderBy: [desc(posts.createdAt)],
      limit: 10,
    },
  },
})
```

**Core queries** (more explicit, better for complex conditions):

```ts
import { eq, and, desc, count } from 'drizzle-orm'

// Insert
const [created] = await db
  .insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .returning()

// Select with condition
const activeUsers = await db
  .select()
  .from(users)
  .where(and(eq(users.isActive, true), isNull(users.deletedAt)))
  .orderBy(desc(users.createdAt))
  .limit(20)

// Update
await db
  .update(posts)
  .set({ status: 'published', updatedAt: new Date() })
  .where(eq(posts.id, postId))

// Delete
await db.delete(posts).where(eq(posts.id, postId))

// Aggregate
const [{ total }] = await db
  .select({ total: count() })
  .from(posts)
  .where(eq(posts.userId, userId))
```

## Migrations

Drizzle generates SQL migration files from schema changes:

```bash
# Generate migration from schema diff
npx drizzle-kit generate

# Apply migrations
npx drizzle-kit migrate

# Push schema directly (dev only — no migration file)
npx drizzle-kit push
```

Migration files land in `./drizzle/` — commit them to version control.

**Workflow:** edit schema → `generate` → review the SQL → `migrate`.
Don't use `push` in production — always use the generated migration files.

## Type Inference

Drizzle infers types from the schema. Use them in your app:

```ts
import type { InferSelectModel, InferInsertModel } from 'drizzle-orm'
import type { users, posts } from './schema'

export type User = InferSelectModel<typeof users>
export type NewUser = InferInsertModel<typeof users>
export type Post = InferSelectModel<typeof posts>
export type NewPost = InferInsertModel<typeof posts>
```

These types are the source of truth — don't duplicate them as manual interfaces.

## Transactions

```ts
const result = await db.transaction(async (tx) => {
  const [order] = await tx.insert(orders).values(orderData).returning()
  await tx.insert(orderItems).values(items.map(i => ({ ...i, orderId: order.id })))
  await tx.update(inventory).set({ stock: sql`stock - 1` }).where(eq(inventory.id, itemId))
  return order
})
```

If any query throws, the transaction rolls back automatically.
