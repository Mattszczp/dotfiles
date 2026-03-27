# Svelte 5 Runes & Reactivity

## $props()

Declares the component's props. Always type them with an interface.

```svelte
<script lang="ts">
  interface Props {
    name: string
    age?: number
    class?: string          // for passing CSS classes through
    children?: Snippet      // for slot-like content
    onclick?: () => void    // event callbacks are just props
  }

  let { name, age = 0, class: className, children, onclick }: Props = $props()
</script>
```

**Spread remaining props** onto an element (useful for wrapper components):

```svelte
<script lang="ts">
  interface Props {
    label: string
    [key: string]: unknown  // allow arbitrary HTML attributes
  }

  let { label, ...rest }: Props = $props()
</script>

<button {...rest}>{label}</button>
```

## $state()

Local reactive state. Svelte tracks reads and writes deeply for objects and arrays.

```svelte
<script lang="ts">
  let count = $state(0)
  let user = $state({ name: 'Alice', score: 0 })
  let items = $state<string[]>([])

  function addItem(item: string) {
    items.push(item)        // direct mutation works — Svelte tracks it
    user.score++            // same for nested properties
  }
</script>
```

**$state.raw()** — for large data structures you don't want deeply tracked.
Only reassignment triggers reactivity, not mutations:

```svelte
let bigList = $state.raw<Item[]>([])

// Must reassign to trigger reactivity
bigList = [...bigList, newItem]
```

**$state.snapshot()** — get a plain, non-reactive copy of state (useful for
logging, serializing, or passing to non-Svelte code):

```svelte
console.log($state.snapshot(user))  // plain object, not a Proxy
```

## $derived()

Computed values. Recalculates when its reactive dependencies change. Never set it
manually.

```svelte
<script lang="ts">
  let items = $state<number[]>([1, 2, 3])

  let total = $derived(items.reduce((sum, n) => sum + n, 0))
  let hasItems = $derived(items.length > 0)
</script>
```

**$derived.by()** for multi-line logic:

```svelte
let summary = $derived.by(() => {
  const sorted = [...items].sort((a, b) => b - a)
  const top3 = sorted.slice(0, 3)
  return top3.join(', ')
})
```

## $effect()

Runs after the component mounts and after every reactive change it depends on.
Use for side effects — syncing to localStorage, calling external APIs, imperative
DOM manipulation.

```svelte
<script lang="ts">
  let query = $state('')

  $effect(() => {
    // runs when `query` changes
    const controller = new AbortController()
    fetch(`/api/search?q=${query}`, { signal: controller.signal })
      .then(r => r.json())
      .then(data => { results = data })

    // return a cleanup function — runs before the next effect, and on destroy
    return () => controller.abort()
  })
</script>
```

**$effect.pre()** runs before the DOM update — useful when you need to read DOM
dimensions before a render.

**When NOT to use $effect:**
- Syncing derived values → use `$derived` instead
- Computing a value from state → use `$derived` instead
- Transforming props → just compute inline or use `$derived`

A good signal: if your `$effect` only reads state and writes state (no DOM, no
external calls), it should probably be `$derived`.

## Snippets (replacing slots)

Snippets are the Svelte 5 replacement for slots. They're typed and composable.

```svelte
<!-- Parent -->
<script lang="ts">
  import Card from './Card.svelte'
</script>

<Card>
  {#snippet header()}
    <h2>Title</h2>
  {/snippet}

  {#snippet default()}
    <p>Body content</p>
  {/snippet}
</Card>
```

```svelte
<!-- Card.svelte -->
<script lang="ts">
  import type { Snippet } from 'svelte'

  interface Props {
    header?: Snippet
    children?: Snippet   // "default" snippet is always called children
  }

  let { header, children }: Props = $props()
</script>

<div class="card">
  {#if header}
    <div class="card-header">{@render header()}</div>
  {/if}
  <div class="card-body">{@render children?.()}</div>
</div>
```

**Snippets with parameters:**

```svelte
<!-- Usage -->
<List {items}>
  {#snippet item(entry)}
    <span>{entry.label}</span>
  {/snippet}
</List>

<!-- List.svelte -->
<script lang="ts">
  import type { Snippet } from 'svelte'

  interface Props {
    items: Array<{ id: string; label: string }>
    item: Snippet<[{ id: string; label: string }]>
  }

  let { items, item }: Props = $props()
</script>

{#each items as entry}
  {@render item(entry)}
{/each}
```

## Stores (when you actually need them)

Runes are component-scoped. When state genuinely needs to be shared across the
component tree (user session, theme, cart), use a store defined in a `.svelte.ts` file.

```ts
// src/lib/stores/cart.svelte.ts
let items = $state<CartItem[]>([])
let total = $derived(items.reduce((sum, i) => sum + i.price, 0))

function add(item: CartItem) {
  items.push(item)
}

function remove(id: string) {
  const idx = items.findIndex(i => i.id === id)
  if (idx !== -1) items.splice(idx, 1)
}

export const cart = { items, total, add, remove }
```

```svelte
<!-- In any component -->
<script lang="ts">
  import { cart } from '$lib/stores/cart.svelte'
</script>

<p>Items: {cart.items.length}, Total: {cart.total}</p>
<button onclick={() => cart.add(newItem)}>Add</button>
```

Note: the `.svelte.ts` extension is required for runes to work outside `.svelte` files.
