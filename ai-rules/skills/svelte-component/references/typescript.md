# TypeScript in Svelte 5

## Component Types

SvelteKit generates types automatically in `./$types`. Always use them:

```ts
import type { PageData, PageServerLoad, Actions, ActionData } from './$types'
```

For reusable components, define prop interfaces explicitly:

```svelte
<script lang="ts">
  import type { Snippet } from 'svelte'
  import type { HTMLButtonAttributes } from 'svelte/elements'

  interface Props extends HTMLButtonAttributes {
    variant?: 'primary' | 'secondary' | 'ghost'
    loading?: boolean
    children: Snippet
  }

  let {
    variant = 'primary',
    loading = false,
    children,
    ...rest
  }: Props = $props()
</script>

<button class="btn btn-{variant}" disabled={loading} {...rest}>
  {#if loading}<Spinner />{/if}
  {@render children()}
</button>
```

Extending `HTMLButtonAttributes` lets the component accept any native button attribute
without listing them all.

## Typing Events

Event callbacks are just typed props in Svelte 5:

```svelte
<script lang="ts">
  interface Props {
    onselect?: (id: string) => void
    ondelete?: (id: string) => Promise<void>
  }

  let { onselect, ondelete }: Props = $props()
</script>
```

## Typing Snippets

```ts
import type { Snippet } from 'svelte'

interface Props {
  children: Snippet                          // no args
  header?: Snippet                           // optional, no args
  row: Snippet<[{ id: string; name: string }]>  // with typed arg
}
```

## Generic Components

```svelte
<script lang="ts" generics="T extends { id: string }">
  interface Props {
    items: T[]
    selected?: T
    onselect: (item: T) => void
    row: Snippet<[T]>
  }

  let { items, selected, onselect, row }: Props = $props()
</script>

{#each items as item}
  <div
    class:active={item.id === selected?.id}
    onclick={() => onselect(item)}
    role="option"
    aria-selected={item.id === selected?.id}
    tabindex="0"
    onkeydown={(e) => e.key === 'Enter' && onselect(item)}
  >
    {@render row(item)}
  </div>
{/each}
```

## Shared Types

Put types shared between frontend and backend (e.g. API response shapes) in
`src/lib/types/`. If you're sharing with a Go backend, keep these types manually
in sync or generate them from your OpenAPI spec.

```ts
// src/lib/types/api.ts
export interface Post {
  id: string
  title: string
  body: string
  createdAt: string   // ISO 8601 — Go's time.Time serializes to this
  author: {
    id: string
    name: string
  }
}
```

## tsconfig

SvelteKit scaffolds a reasonable `tsconfig.json`. Key settings to verify:

```json
{
  "compilerOptions": {
    "strict": true,
    "moduleResolution": "bundler",
    "verbatimModuleSyntax": true
  }
}
```

`strict: true` is non-negotiable. `verbatimModuleSyntax` ensures `import type` is
used correctly and avoids subtle issues with type-only imports.
