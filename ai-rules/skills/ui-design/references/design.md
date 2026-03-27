# Design Decisions: Color, Typography, Spacing, Layout

This is the opinionated core of the skill. These aren't rules for rules' sake — they're
the decisions that separate "looks like a template" from "looks like someone made this."

## Color

**Use shadcn-svelte's CSS variable tokens.** They automatically switch between light
and dark mode. Never hardcode hex values for semantic colors.

| Token | Use for |
|-------|---------|
| `bg-background` | Page background |
| `bg-card` | Card/surface backgrounds |
| `bg-muted` | Subtle backgrounds, empty states, sidebars |
| `text-foreground` | Primary text |
| `text-muted-foreground` | Secondary text, labels, captions |
| `border` | Default borders |
| `bg-primary` / `text-primary-foreground` | Primary action, key highlight |
| `bg-destructive` | Errors, delete actions |
| `ring` | Focus rings |

**Pick one accent and use it consistently.** The primary color is your accent. Use it
for the one thing on a screen that matters most — the main CTA, active nav item, a
metric that needs attention. If everything is accented, nothing is.

**Muted colors do a lot of work.** `text-muted-foreground` and `bg-muted` create
visual hierarchy without adding noise. Use them for metadata, secondary labels,
placeholder states, and sidebar backgrounds.

**Status colors have meaning — use them correctly:**
- `text-destructive` / `bg-destructive` → errors, destructive actions only
- Green → success (Tailwind `green-500` / `dark:green-400`)
- Yellow/amber → warnings
- Don't invent new semantic colors

**Customize the base palette** in `app.css` when the project has a personality. 
Shadcn's zinc/slate/stone neutrals all read differently — slate is cool and tech-y,
zinc is neutral, stone is warm. Pick deliberately.

## Typography

Typography is the fastest way to make something look more designed.

**Establish clear hierarchy with size and weight — not just size:**

```svelte
<!-- Page title -->
<h1 class="text-2xl font-semibold tracking-tight">Invoices</h1>

<!-- Section header -->
<h2 class="text-sm font-medium text-muted-foreground uppercase tracking-wider">
  Recent Activity
</h2>

<!-- Card value / metric -->
<p class="text-3xl font-bold tabular-nums">$24,521</p>

<!-- Supporting label -->
<p class="text-sm text-muted-foreground">+12% from last month</p>

<!-- Body text -->
<p class="text-sm leading-relaxed">...</p>
```

**`tabular-nums` for numbers.** Any numeric data that changes or sits in a table
should use `tabular-nums` so digits don't cause layout shift.

**`tracking-tight` on large text.** Headings at `text-2xl` and above look better with
slightly tighter letter-spacing.

**Don't go below `text-xs` for readable content.** `text-xs` is fine for badges and
metadata; below that is inaccessible.

**Avoid more than 3 font sizes on one screen.** More than that creates noise, not
hierarchy.

## Spacing

**Use Tailwind's scale consistently.** The 4px base unit (`1 = 4px`) compounds well.
Common spacings that feel right:

- `gap-2` / `gap-3` — tight, within a component
- `gap-4` / `gap-6` — between related elements
- `gap-8` / `gap-12` — between sections
- `p-4` / `p-6` — card padding
- `px-4 py-2` — compact list items
- `px-6 py-4` — comfortable list items

**Give things room to breathe.** The most common spacing mistake is too little — not
too much. When in doubt, add more space between sections.

**Consistent padding within a surface.** If a card uses `p-6`, all cards on that page
should use `p-6`. Inconsistent padding is immediately visible.

## Layout

**Start with a clear information hierarchy.** Before thinking about columns and grids,
decide: what's the most important thing on this screen? That should be biggest, highest,
or most prominent. Everything else is secondary.

**Common layout patterns for your use cases:**

App shell (sidebar + content):
```svelte
<div class="flex h-screen overflow-hidden">
  <aside class="w-64 shrink-0 border-r bg-muted/40 flex flex-col">
    <!-- nav -->
  </aside>
  <main class="flex-1 overflow-y-auto">
    <div class="container mx-auto px-6 py-8 max-w-5xl">
      <!-- content -->
    </div>
  </main>
</div>
```

Dashboard stats row:
```svelte
<div class="grid grid-cols-2 gap-4 lg:grid-cols-4">
  <!-- stat cards -->
</div>
```

Content + sidebar:
```svelte
<div class="grid grid-cols-1 gap-8 lg:grid-cols-[1fr_320px]">
  <div><!-- main content --></div>
  <aside><!-- sidebar --></aside>
</div>
```

**Tables need horizontal scroll on mobile:**
```svelte
<div class="rounded-lg border overflow-hidden">
  <div class="overflow-x-auto">
    <table class="w-full text-sm">...</table>
  </div>
</div>
```

## Micro-details That Matter

These are the things that separate "finished" from "almost there":

- **Rounded corners**: Use `rounded-lg` consistently on cards/surfaces. Mix `rounded-md`
  (buttons) and `rounded-full` (badges/avatars) deliberately.
- **Border opacity**: `border` in dark mode can look harsh. `border-border/50` softens it.
- **Empty states**: Never show a blank space. Add an icon, a message, and a CTA.
- **Loading states**: Add `animate-pulse` skeleton placeholders for async content.
- **Focus rings**: shadcn handles these — don't disable `outline-none` without replacing
  it with `ring`.
- **Hover states**: Every interactive element needs a visible hover. `hover:bg-accent`
  on list items, `hover:bg-muted` on rows.

## Dark Mode

shadcn-svelte uses `mode-watcher` and the `class` strategy. Colors via CSS vars
switch automatically. But watch out for:

```svelte
<!-- ✗ This breaks dark mode -->
<div class="bg-gray-100 text-gray-900">

<!-- ✓ This works in both modes -->
<div class="bg-muted text-foreground">
```

For Tailwind colors that aren't CSS vars (e.g. status colors), always pair them:
```svelte
<span class="text-green-600 dark:text-green-400">Active</span>
<span class="bg-red-50 dark:bg-red-950 text-red-700 dark:text-red-300">Error</span>
```
