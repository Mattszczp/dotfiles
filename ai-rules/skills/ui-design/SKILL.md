---
name: ui-design
description: >
  Design and build UI with Tailwind CSS and shadcn-svelte. Use this skill whenever
  the user needs to build, style, or improve a UI — components, layouts, dashboards,
  forms, or any visual interface. Covers design decisions (typography, color, spacing,
  layout), shadcn-svelte component usage, Tailwind patterns, dark mode, and making
  interfaces that look considered and distinctive without being over-designed. Trigger
  on: "design this", "make this look better", "build a dashboard", "build a form",
  "layout", "UI for", "component for", "style this", or any request involving how
  something looks or is laid out on screen.
---

# UI Design Skill

You are helping someone who is a capable developer but not a natural designer. Your
job is to make interfaces that look deliberate and well-crafted — not template-y,
not AI-slop, and definitely not purple gradients on white.

The stack is: **Svelte 5 + shadcn-svelte + Tailwind CSS + lucide-svelte icons**.
Dark mode is always supported via `mode-watcher`.

Before writing any code, think about what the UI needs to *do* and *feel like*. Then
read the relevant reference file(s):

- **shadcn-svelte components & patterns** → `references/shadcn.md`
- **Design decisions: color, type, spacing, layout** → `references/design.md`
- **Dashboard & data-heavy layouts** → `references/dashboards.md`

For most tasks, read `references/design.md` first — it's the opinionated core of this
skill.

## The Goal: Considered, Not Flashy

Good UI for apps and dashboards isn't about being bold or creative for its own sake.
It's about clarity, consistency, and the small details that make something feel
professional:

- Spacing that breathes but doesn't waste space
- Typography with real hierarchy (not everything the same size)
- Colors used with restraint — one accent, used consistently
- Components that behave predictably
- Dark mode that looks as good as light mode

Avoid:
- Generic "SaaS blue" everywhere
- Identical card grids with no visual hierarchy
- Every element the same weight and size
- Gratuitous animations that slow the user down
- Purple. Gradients. On. White.

## Workflow

1. **Understand the context** — what is this screen for? Who is using it? What's the
   most important action or piece of information?
2. **Choose the right shadcn-svelte components** — don't build from scratch what
   shadcn already provides well
3. **Apply design decisions** — read `references/design.md` for concrete guidance
4. **Write the code** — Svelte 5 with `$props()`, TypeScript, Tailwind utilities
5. **Check dark mode** — every color choice must work in both modes using CSS vars

## Non-Negotiables

- Always use `lang="ts"` in `<script>` tags
- Always use shadcn-svelte's CSS variable system for colors — never hardcode `#hex`
  or `rgb()` values for semantic colors
- Always support dark mode — use `dark:` variants or CSS vars that switch automatically
- Use `lucide-svelte` for icons, not emoji or ad-hoc SVG
- Keep components focused — if a component is getting complex, suggest splitting it
