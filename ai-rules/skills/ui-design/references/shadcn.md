# shadcn-svelte Components & Patterns

shadcn-svelte v5 is built on Bits UI and Tailwind CSS. Components live in
`$lib/components/ui/` and are installed via CLI: `npx shadcn-svelte@latest add <name>`.

## Import Pattern

All shadcn components use namespace imports:

```svelte
<script lang="ts">
  import * as Card from '$lib/components/ui/card'
  import * as Dialog from '$lib/components/ui/dialog'
  import { Button } from '$lib/components/ui/button'
  import { Input } from '$lib/components/ui/input'
  import { Label } from '$lib/components/ui/label'
  import { Badge } from '$lib/components/ui/badge'
</script>
```

## Core Components

### Button

```svelte
<Button>Default</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="destructive">Delete</Button>
<Button variant="link">Link</Button>
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>
<Button size="icon"><Icon /></Button>
<Button disabled>Disabled</Button>
```

### Card

```svelte
<Card.Root>
  <Card.Header>
    <Card.Title>Title</Card.Title>
    <Card.Description>Supporting description</Card.Description>
  </Card.Header>
  <Card.Content>
    <!-- content -->
  </Card.Content>
  <Card.Footer class="flex justify-between">
    <Button variant="outline">Cancel</Button>
    <Button>Save</Button>
  </Card.Footer>
</Card.Root>
```

### Form Inputs

```svelte
<div class="grid gap-2">
  <Label for="email">Email</Label>
  <Input id="email" type="email" placeholder="alice@example.com" />
</div>

<!-- Textarea -->
<div class="grid gap-2">
  <Label for="bio">Bio</Label>
  <Textarea id="bio" placeholder="Tell us about yourself" />
</div>

<!-- Select -->
<Select.Root>
  <Select.Trigger class="w-full">
    <Select.Value placeholder="Select status" />
  </Select.Trigger>
  <Select.Content>
    <Select.Item value="active">Active</Select.Item>
    <Select.Item value="inactive">Inactive</Select.Item>
  </Select.Content>
</Select.Root>
```

### Dialog / Modal

```svelte
<script lang="ts">
  import * as Dialog from '$lib/components/ui/dialog'
  import { Button } from '$lib/components/ui/button'

  let open = $state(false)
</script>

<Dialog.Root bind:open>
  <Dialog.Trigger>
    <Button>Open</Button>
  </Dialog.Trigger>
  <Dialog.Content class="sm:max-w-md">
    <Dialog.Header>
      <Dialog.Title>Edit Profile</Dialog.Title>
      <Dialog.Description>Make changes to your profile here.</Dialog.Description>
    </Dialog.Header>

    <!-- form content -->

    <Dialog.Footer>
      <Button variant="outline" onclick={() => open = false}>Cancel</Button>
      <Button>Save changes</Button>
    </Dialog.Footer>
  </Dialog.Content>
</Dialog.Root>
```

### Table

```svelte
<script lang="ts">
  import * as Table from '$lib/components/ui/table'
</script>

<div class="rounded-lg border overflow-hidden">
  <Table.Root>
    <Table.Header>
      <Table.Row>
        <Table.Head>Name</Table.Head>
        <Table.Head>Status</Table.Head>
        <Table.Head class="text-right">Amount</Table.Head>
      </Table.Row>
    </Table.Header>
    <Table.Body>
      {#each rows as row}
        <Table.Row class="hover:bg-muted/50">
          <Table.Cell class="font-medium">{row.name}</Table.Cell>
          <Table.Cell><Badge variant="outline">{row.status}</Badge></Table.Cell>
          <Table.Cell class="text-right tabular-nums">{row.amount}</Table.Cell>
        </Table.Row>
      {/each}
    </Table.Body>
  </Table.Root>
</div>
```

### Badge

```svelte
<Badge>Default</Badge>
<Badge variant="secondary">Secondary</Badge>
<Badge variant="outline">Outline</Badge>
<Badge variant="destructive">Error</Badge>

<!-- Status badge pattern -->
<Badge
  class={status === 'active'
    ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
    : 'bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400'}
>
  {status}
</Badge>
```

### Tabs

```svelte
<Tabs.Root value="overview">
  <Tabs.List>
    <Tabs.Trigger value="overview">Overview</Tabs.Trigger>
    <Tabs.Trigger value="analytics">Analytics</Tabs.Trigger>
    <Tabs.Trigger value="settings">Settings</Tabs.Trigger>
  </Tabs.List>
  <Tabs.Content value="overview">...</Tabs.Content>
  <Tabs.Content value="analytics">...</Tabs.Content>
  <Tabs.Content value="settings">...</Tabs.Content>
</Tabs.Root>
```

### Tooltip

```svelte
<Tooltip.Root>
  <Tooltip.Trigger>
    <Button size="icon" variant="ghost"><InfoIcon class="h-4 w-4" /></Button>
  </Tooltip.Trigger>
  <Tooltip.Content>
    <p>Helpful explanation here</p>
  </Tooltip.Content>
</Tooltip.Root>
```

### Toast (Sonner)

```svelte
<script lang="ts">
  import { toast } from 'svelte-sonner'
</script>

<!-- In app root (+layout.svelte) -->
<Toaster richColors />

<!-- Trigger anywhere -->
toast.success('Saved successfully')
toast.error('Something went wrong')
toast('Record updated', {
  description: 'Changes have been saved.',
  action: { label: 'Undo', onClick: () => undo() }
})
```

## Icons (lucide-svelte)

```svelte
<script lang="ts">
  import { Search, Plus, Trash2, ChevronRight, Loader2 } from 'lucide-svelte'
</script>

<Search class="h-4 w-4" />
<Plus class="h-4 w-4" />

<!-- Loading spinner -->
<Loader2 class="h-4 w-4 animate-spin" />

<!-- Icon button -->
<Button size="icon" variant="ghost">
  <Trash2 class="h-4 w-4 text-destructive" />
</Button>

<!-- Icon + label -->
<Button>
  <Plus class="mr-2 h-4 w-4" />
  Add Item
</Button>
```

Always use `h-4 w-4` for inline icons (matches text-sm). Use `h-5 w-5` for slightly
larger contexts. Never use emoji as icons.

## Dark Mode Toggle

```svelte
<script lang="ts">
  import { toggleMode } from 'mode-watcher'
  import { Sun, Moon } from 'lucide-svelte'
  import { Button } from '$lib/components/ui/button'
</script>

<Button variant="ghost" size="icon" onclick={toggleMode}>
  <Sun class="h-4 w-4 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
  <Moon class="absolute h-4 w-4 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
</Button>
```

## Customizing shadcn Components

Components live in your codebase — edit them directly. To extend a button variant:

```ts
// $lib/components/ui/button/index.ts
export const buttonVariants = cva('...base...', {
  variants: {
    variant: {
      // existing variants...
      success: 'bg-green-600 text-white hover:bg-green-700',  // add yours
    }
  }
})
```

Don't fight the component — if you need significant customization, copy the component
and create a variant rather than overriding with deep CSS.
