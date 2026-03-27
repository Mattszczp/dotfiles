---
name: svelte-component
description: >
  Write, refactor, or reason about Svelte 5 components. Use this skill whenever the
  user is working with Svelte — building components, using runes ($state, $derived,
  $effect, $props), structuring stores, handling forms, managing reactivity, or asking
  about Svelte patterns and best practices. Trigger on mentions of Svelte, SvelteKit,
  runes, components, .svelte files, or questions about reactivity and UI patterns in
  TypeScript frontend code.
---

# Svelte 5 Component Skill

You are working with Svelte 5. The runes system is the default — do not use the legacy
Svelte 4 API (`writable`, `readable`, `$:`, `export let`) unless the user explicitly
asks for it.

Before writing any component, read the relevant file(s) if they exist. Understand the
surrounding context — what props are expected, what stores or state are in play, what
the component needs to do.

## Reference Files

Read these when the task involves the relevant domain:

- **Runes & reactivity** → `references/runes.md`
- **SvelteKit routing, load functions, form actions** → `references/sveltekit.md`
- **TypeScript integration** → `references/typescript.md`

For general component work, `references/runes.md` is almost always relevant.

## Component Design Principles

**Keep components focused.** A component should do one thing well. If it's growing
beyond ~150 lines or managing several unrelated concerns, suggest splitting it.

**Co-locate state with the component that owns it.** Don't reach for a global store
until state genuinely needs to be shared across distant parts of the tree.

**TypeScript first.** Always type props, events, and returned values explicitly.
Avoid `any`. Use `interface` for props shapes.

**Accessibility by default.** Use semantic HTML. Add `aria-*` attributes where
interactive elements need them. Don't put click handlers on `<div>` when `<button>`
exists.

## Anatomy of a Svelte 5 Component

```svelte
<script lang="ts">
  import { someUtil } from '$lib/utils'

  interface Props {
    label: string
    count?: number
    onchange?: (value: number) => void
  }

  let { label, count = 0, onchange }: Props = $props()

  let internal = $state(count)

  let doubled = $derived(internal * 2)

  function increment() {
    internal++
    onchange?.(internal)
  }
</script>

<button onclick={increment}>
  {label}: {internal} (doubled: {doubled})
</button>
```

## Quick Rune Reference

| Rune | Purpose |
|------|---------|
| `$props()` | Declare component props |
| `$state()` | Reactive local state |
| `$derived()` | Computed value from reactive state |
| `$derived.by(() => ...)` | Computed with complex logic |
| `$effect()` | Side effects when state changes |
| `$effect.pre()` | Side effect before DOM update |

Details and patterns in `references/runes.md`.

## Common Mistakes to Avoid

- **Don't mutate props.** Props are read-only. If you need local mutation, copy into
  `$state`: `let value = $state(props.value)`
- **Don't overuse `$effect`.** If you're using it to sync derived values, use
  `$derived` instead. `$effect` is for side effects (DOM manipulation, logging, syncing
  to external systems).
- **Don't use `$:` reactive statements.** That's Svelte 4. Use `$derived` or `$effect`.
- **Don't use `export let`.** Use `$props()` instead.
- **Don't reach for stores immediately.** Runes + prop drilling handles most cases.
  Use stores for genuinely global or cross-tree state.
