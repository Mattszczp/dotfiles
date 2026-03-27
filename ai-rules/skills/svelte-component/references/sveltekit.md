# SvelteKit — Routing, Load Functions, Form Actions

## File Structure

```
src/
  routes/
    +layout.svelte          # shared layout (wraps all child routes)
    +layout.ts              # layout load function
    +page.svelte            # page component
    +page.ts                # page load function (client + server)
    +page.server.ts         # server-only load + form actions
    +error.svelte           # error boundary
    api/
      users/
        +server.ts          # API route (GET, POST, etc.)
  lib/
    index.ts                # re-exported as $lib
```

## Load Functions

**+page.ts** — runs on server (SSR) and client (navigation). Use for data that's safe
to expose and doesn't need secrets.

```ts
// src/routes/posts/[id]/+page.ts
import type { PageLoad } from './$types'
import { error } from '@sveltejs/kit'

export const load: PageLoad = async ({ params, fetch }) => {
  const res = await fetch(`/api/posts/${params.id}`)
  if (!res.ok) error(404, 'Post not found')

  const post = await res.json()
  return { post }
}
```

**+page.server.ts** — runs only on the server. Use when you need DB access, secrets,
or auth checks.

```ts
// src/routes/dashboard/+page.server.ts
import type { PageServerLoad } from './$types'
import { redirect } from '@sveltejs/kit'
import { db } from '$lib/server/db'

export const load: PageServerLoad = async ({ locals }) => {
  if (!locals.user) redirect(302, '/login')

  const data = await db.query.metrics.findMany({
    where: eq(metrics.userId, locals.user.id)
  })

  return { metrics: data }
}
```

**Accessing load data in the page:**

```svelte
<script lang="ts">
  import type { PageData } from './$types'

  let { data }: { data: PageData } = $props()
</script>

<h1>{data.post.title}</h1>
```

## Form Actions

Prefer form actions over fetch-based mutations for anything that changes server state.
They work without JS, degrade gracefully, and integrate with SvelteKit's loading states.

```ts
// src/routes/posts/new/+page.server.ts
import type { Actions } from './$types'
import { fail, redirect } from '@sveltejs/kit'
import { db } from '$lib/server/db'

export const actions: Actions = {
  create: async ({ request, locals }) => {
    if (!locals.user) redirect(302, '/login')

    const form = await request.formData()
    const title = form.get('title')?.toString().trim()
    const body = form.get('body')?.toString().trim()

    if (!title) return fail(422, { error: 'Title is required', title, body })
    if (!body)  return fail(422, { error: 'Body is required', title, body })

    const post = await db.insert(posts).values({
      title,
      body,
      authorId: locals.user.id,
    }).returning()

    redirect(303, `/posts/${post[0].id}`)
  }
}
```

```svelte
<!-- +page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms'
  import type { ActionData } from './$types'

  let { form }: { form: ActionData } = $props()
</script>

<form method="POST" action="?/create" use:enhance>
  {#if form?.error}
    <p class="error">{form.error}</p>
  {/if}

  <input name="title" value={form?.title ?? ''} required />
  <textarea name="body">{form?.body ?? ''}</textarea>
  <button type="submit">Publish</button>
</form>
```

`use:enhance` progressively enhances the form — it still works without JS.

## API Routes

For endpoints consumed by external clients or when a REST API makes more sense than
form actions:

```ts
// src/routes/api/posts/+server.ts
import type { RequestHandler } from './$types'
import { json, error } from '@sveltejs/kit'
import { db } from '$lib/server/db'

export const GET: RequestHandler = async ({ url, locals }) => {
  const limit = Number(url.searchParams.get('limit') ?? 20)

  const items = await db.query.posts.findMany({ limit })
  return json(items)
}

export const POST: RequestHandler = async ({ request, locals }) => {
  if (!locals.user) error(401, 'Unauthorized')

  const body = await request.json()
  // validate body...

  const post = await db.insert(posts).values({ ...body, authorId: locals.user.id })
    .returning()

  return json(post[0], { status: 201 })
}
```

## locals and hooks

Set `locals` in `src/hooks.server.ts` — this is where auth sessions are resolved:

```ts
// src/hooks.server.ts
import type { Handle } from '@sveltejs/kit'
import { validateSession } from '$lib/server/auth'

export const handle: Handle = async ({ event, resolve }) => {
  const sessionToken = event.cookies.get('session')

  if (sessionToken) {
    event.locals.user = await validateSession(sessionToken)
  }

  return resolve(event)
}
```

## Path Aliases

Always use `$lib` for internal imports — never use relative paths across route
boundaries:

```ts
// ✓
import { db } from '$lib/server/db'
import { Button } from '$lib/components/Button.svelte'

// ✗
import { db } from '../../../lib/server/db'
```
