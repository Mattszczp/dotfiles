# Dashboards & Data-Heavy Layouts

Dashboards are about information density done right — not cramming everything in, but
making important data immediately scannable. The key tension is between showing enough
context and avoiding overwhelm.

## App Shell

The standard pattern for your use cases (app + desktop):

```svelte
<!-- +layout.svelte -->
<script lang="ts">
  import { page } from '$app/stores'
  import { LayoutDashboard, Users, Settings, ChevronRight } from 'lucide-svelte'

  const navItems = [
    { href: '/dashboard', icon: LayoutDashboard, label: 'Dashboard' },
    { href: '/users', icon: Users, label: 'Users' },
    { href: '/settings', icon: Settings, label: 'Settings' },
  ]

  let { children } = $props()
</script>

<div class="flex h-screen overflow-hidden bg-background">
  <!-- Sidebar -->
  <aside class="flex w-60 shrink-0 flex-col border-r bg-muted/30">
    <!-- Logo / App name -->
    <div class="flex h-14 items-center border-b px-4">
      <span class="font-semibold">AppName</span>
    </div>

    <!-- Nav -->
    <nav class="flex-1 space-y-1 p-2 pt-4">
      {#each navItems as item}
        {@const active = $page.url.pathname.startsWith(item.href)}
        <a
          href={item.href}
          class="flex items-center gap-3 rounded-md px-3 py-2 text-sm transition-colors
            {active
              ? 'bg-primary text-primary-foreground'
              : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'}"
        >
          <item.icon class="h-4 w-4 shrink-0" />
          {item.label}
        </a>
      {/each}
    </nav>

    <!-- Bottom actions (user, theme toggle) -->
    <div class="border-t p-3">
      <!-- user avatar / logout -->
    </div>
  </aside>

  <!-- Main content -->
  <div class="flex flex-1 flex-col overflow-hidden">
    <!-- Optional top bar -->
    <header class="flex h-14 items-center justify-between border-b px-6">
      <h1 class="text-sm font-medium text-muted-foreground">
        <!-- breadcrumb or page title -->
      </h1>
      <div class="flex items-center gap-2">
        <!-- actions -->
      </div>
    </header>

    <main class="flex-1 overflow-y-auto">
      <div class="mx-auto max-w-6xl px-6 py-8">
        {@render children()}
      </div>
    </main>
  </div>
</div>
```

## Stat Cards

The top of most dashboards. Keep them scannable — one number, one label, one trend.

```svelte
<script lang="ts">
  import * as Card from '$lib/components/ui/card'
  import { TrendingUp, TrendingDown } from 'lucide-svelte'

  interface StatCard {
    label: string
    value: string
    change: number      // percentage, positive or negative
    changeLabel: string // e.g. "from last month"
  }

  let { label, value, change, changeLabel }: StatCard = $props()

  let positive = $derived(change >= 0)
</script>

<Card.Root>
  <Card.Header class="flex flex-row items-center justify-between pb-2 space-y-0">
    <Card.Title class="text-sm font-medium text-muted-foreground">{label}</Card.Title>
  </Card.Header>
  <Card.Content>
    <div class="text-2xl font-bold tabular-nums">{value}</div>
    <p class="mt-1 flex items-center gap-1 text-xs text-muted-foreground">
      {#if positive}
        <TrendingUp class="h-3 w-3 text-green-500" />
        <span class="text-green-600 dark:text-green-400 font-medium">+{change}%</span>
      {:else}
        <TrendingDown class="h-3 w-3 text-destructive" />
        <span class="text-destructive font-medium">{change}%</span>
      {/if}
      {changeLabel}
    </p>
  </Card.Content>
</Card.Root>
```

```svelte
<!-- Usage -->
<div class="grid gap-4 grid-cols-2 lg:grid-cols-4">
  <StatCard label="Total Revenue" value="$24,521" change={12.5} changeLabel="from last month" />
  <StatCard label="Active Users" value="1,234" change={-3.2} changeLabel="from last week" />
  <!-- ... -->
</div>
```

## Data Tables

For CRUD-heavy interfaces. Keep actions close to the data, make rows feel interactive.

```svelte
<div class="space-y-4">
  <!-- Toolbar -->
  <div class="flex items-center justify-between">
    <div class="flex items-center gap-2">
      <Input
        placeholder="Search..."
        class="h-8 w-64"
      />
      <!-- filters -->
    </div>
    <Button size="sm">
      <Plus class="mr-2 h-4 w-4" />
      Add New
    </Button>
  </div>

  <!-- Table -->
  <div class="rounded-lg border">
    <Table.Root>
      <Table.Header>
        <Table.Row class="hover:bg-transparent">
          <Table.Head class="w-[300px]">Name</Table.Head>
          <Table.Head>Status</Table.Head>
          <Table.Head>Date</Table.Head>
          <Table.Head class="text-right">Amount</Table.Head>
          <Table.Head class="w-[70px]"></Table.Head>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {#each items as item (item.id)}
          <Table.Row class="cursor-pointer hover:bg-muted/50">
            <Table.Cell class="font-medium">{item.name}</Table.Cell>
            <Table.Cell>
              <Badge variant="outline" class="capitalize">{item.status}</Badge>
            </Table.Cell>
            <Table.Cell class="text-muted-foreground text-sm">
              {formatDate(item.date)}
            </Table.Cell>
            <Table.Cell class="text-right tabular-nums font-medium">
              {formatCurrency(item.amount)}
            </Table.Cell>
            <Table.Cell>
              <!-- row actions dropdown -->
              <DropdownMenu.Root>
                <DropdownMenu.Trigger>
                  <Button variant="ghost" size="icon" class="h-8 w-8">
                    <MoreHorizontal class="h-4 w-4" />
                  </Button>
                </DropdownMenu.Trigger>
                <DropdownMenu.Content align="end">
                  <DropdownMenu.Item>Edit</DropdownMenu.Item>
                  <DropdownMenu.Separator />
                  <DropdownMenu.Item class="text-destructive">Delete</DropdownMenu.Item>
                </DropdownMenu.Content>
              </DropdownMenu.Root>
            </Table.Cell>
          </Table.Row>
        {:else}
          <Table.Row>
            <Table.Cell colspan={5} class="h-32 text-center text-muted-foreground">
              No results found.
            </Table.Cell>
          </Table.Row>
        {/each}
      </Table.Body>
    </Table.Root>
  </div>

  <!-- Pagination -->
  <div class="flex items-center justify-between text-sm text-muted-foreground">
    <span>Showing {start}–{end} of {total}</span>
    <div class="flex gap-2">
      <Button variant="outline" size="sm" disabled={page === 1}
        onclick={() => page--}>Previous</Button>
      <Button variant="outline" size="sm" disabled={page === totalPages}
        onclick={() => page++}>Next</Button>
    </div>
  </div>
</div>
```

## Forms

Forms for settings, creation, editing. Grouped by section, not one long scroll.

```svelte
<div class="space-y-8 max-w-2xl">
  <!-- Section -->
  <div class="space-y-4">
    <div>
      <h3 class="text-base font-semibold">Profile</h3>
      <p class="text-sm text-muted-foreground">Update your personal information.</p>
    </div>
    <Separator />

    <div class="grid gap-4 sm:grid-cols-2">
      <div class="grid gap-2">
        <Label for="first-name">First name</Label>
        <Input id="first-name" bind:value={firstName} />
      </div>
      <div class="grid gap-2">
        <Label for="last-name">Last name</Label>
        <Input id="last-name" bind:value={lastName} />
      </div>
    </div>

    <div class="grid gap-2">
      <Label for="email">Email</Label>
      <Input id="email" type="email" bind:value={email} />
      <p class="text-xs text-muted-foreground">Used for notifications and login.</p>
    </div>
  </div>

  <!-- Section -->
  <div class="space-y-4">
    <div>
      <h3 class="text-base font-semibold">Notifications</h3>
      <p class="text-sm text-muted-foreground">Choose what you want to be notified about.</p>
    </div>
    <Separator />
    <!-- toggle rows -->
  </div>

  <!-- Actions -->
  <div class="flex items-center gap-3 pt-2">
    <Button type="submit">Save changes</Button>
    <Button variant="outline" onclick={reset}>Reset</Button>
  </div>
</div>
```

## Empty States

Never leave a blank area. Every empty state needs: an icon, a message, and a next step.

```svelte
{#if items.length === 0}
  <div class="flex flex-col items-center justify-center py-16 text-center">
    <div class="rounded-full bg-muted p-4 mb-4">
      <InboxIcon class="h-8 w-8 text-muted-foreground" />
    </div>
    <h3 class="text-sm font-semibold">No items yet</h3>
    <p class="mt-1 text-sm text-muted-foreground max-w-xs">
      Get started by creating your first item.
    </p>
    <Button class="mt-4" size="sm">
      <Plus class="mr-2 h-4 w-4" />
      Create Item
    </Button>
  </div>
{/if}
```

## Tauri-Specific Considerations

For desktop apps with Tauri, adjust the shell slightly:

- Remove scrollbar from the outer container (the OS window handles this)
- Use `data-tauri-drag-region` on the custom titlebar if you're hiding the native one
- Avoid `hover:cursor-pointer` on things that aren't actually clickable — desktop users
  notice this more than web users
- Sidebar widths can be fixed (no responsive collapse needed unless the window is resizable)
- Dense layouts are more acceptable — desktop users expect more information density
  than mobile web
