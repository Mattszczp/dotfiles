# Vitest — Unit & Integration Tests (TypeScript)

## Setup Patterns

Always check for an existing `vitest.config.ts`. If there isn't one, suggest creating
it — don't assume defaults are sufficient for the project.

```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    globals: true,       // enables describe/it/expect without imports
    environment: 'node', // or 'jsdom' for browser-like code
    coverage: {
      provider: 'v8',
      reporter: ['text', 'lcov'],
    },
  },
})
```

## File Naming

- Unit tests: `src/utils/format.test.ts` (co-located with source)
- Integration tests: `src/__tests__/user-service.integration.test.ts`
- Use `.test.ts` or `.spec.ts` consistently — pick what the project already uses

## Test Structure

```ts
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { formatCurrency } from './format'

describe('formatCurrency', () => {
  it('formats positive amounts with currency symbol', () => {
    // Arrange
    const amount = 1234.56
    const currency = 'USD'

    // Act
    const result = formatCurrency(amount, currency)

    // Assert
    expect(result).toBe('$1,234.56')
  })

  it('handles zero', () => {
    expect(formatCurrency(0, 'USD')).toBe('$0.00')
  })

  it('throws on negative amount', () => {
    expect(() => formatCurrency(-1, 'USD')).toThrow('Amount must be non-negative')
  })
})
```

## Mocking

**Mock modules** — use `vi.mock()` at the top of the file (it's hoisted):

```ts
import { vi, describe, it, expect } from 'vitest'
import { sendEmail } from './email-service'
import { notifyUser } from './notifications'

vi.mock('./email-service')  // auto-mocks all exports

it('sends email on successful purchase', async () => {
  const mockSend = vi.mocked(sendEmail).mockResolvedValue({ id: 'msg_123' })

  await notifyUser({ userId: 'u1', event: 'purchase' })

  expect(mockSend).toHaveBeenCalledOnce()
  expect(mockSend).toHaveBeenCalledWith(expect.objectContaining({
    to: 'user@example.com',
    subject: expect.stringContaining('purchase'),
  }))
})
```

**Mock only what you need.** Prefer mocking at the boundary (HTTP client, DB driver)
rather than deep inside your own code — that's a sign of poor separation.

**Spy on methods** without replacing them:

```ts
const spy = vi.spyOn(logger, 'warn')
// ... trigger the code
expect(spy).toHaveBeenCalledWith('rate limit exceeded')
```

**Restore mocks** — use `vi.restoreAllMocks()` in `afterEach` or configure
`restoreMocks: true` in vitest.config.ts.

## Async Tests

```ts
it('fetches user by id', async () => {
  const user = await userService.findById('u_abc')
  expect(user).toMatchObject({ id: 'u_abc', email: 'alice@example.com' })
})

it('rejects with NotFoundError for unknown id', async () => {
  await expect(userService.findById('u_unknown')).rejects.toThrow('NotFoundError')
})
```

## Integration Tests with a Real Database

Use a real (test) database — don't mock the DB layer in integration tests, it defeats
the purpose.

```ts
import { beforeAll, afterAll, beforeEach } from 'vitest'
import { db } from '../db'
import { migrate } from '../db/migrations'

beforeAll(async () => {
  await migrate(db)  // run migrations once
})

beforeEach(async () => {
  await db.execute('DELETE FROM users')  // clean state per test
})

afterAll(async () => {
  await db.close()
})

it('persists a user and retrieves it', async () => {
  const created = await userRepo.create({ email: 'bob@example.com' })
  const found = await userRepo.findById(created.id)

  expect(found).toMatchObject({ email: 'bob@example.com' })
})
```

Prefer truncating tables over dropping and recreating the DB per test — it's much
faster.

## Snapshot Testing

Use sparingly — only for complex serialized outputs where the shape matters more than
specific values. Never snapshot volatile data (timestamps, IDs).

```ts
it('renders invoice line items', () => {
  const result = renderInvoice(mockInvoice)
  expect(result).toMatchSnapshot()
})
```

Update snapshots intentionally: `vitest --update-snapshots`.

## Common Pitfalls to Avoid

- **Don't mock `Date.now()` globally** — use dependency injection instead
- **Don't test private methods** — if the public API is hard to test, refactor
- **Don't assert on exact error messages** — assert on error type/code so messages can change
- **Don't share mutable state between tests** — always reset in `beforeEach`
- **Don't `expect(true).toBe(true)`** — this is a dead test that proves nothing
