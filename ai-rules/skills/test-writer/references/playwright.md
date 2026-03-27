# Playwright — End-to-End Tests (TypeScript)

## When to Write E2E Tests

E2E tests are expensive to write, slow to run, and brittle to maintain. Only write them
for **critical user journeys** — the flows that, if broken, would immediately harm the
business. Examples: login, checkout, onboarding, core feature workflows.

Don't write E2E tests for things that are better tested at the unit or integration
level. A good rule: if you can test it with Vitest, don't use Playwright.

## File Structure

```
e2e/
  auth.spec.ts          # login, logout, session expiry
  checkout.spec.ts      # cart → payment → confirmation
  fixtures/
    auth.ts             # shared login fixture
  pages/
    LoginPage.ts        # Page Object for login screen
```

## Page Object Model

Always use the Page Object Model (POM). It keeps tests readable and makes UI changes
easy to maintain — you update one place instead of every test.

```ts
// e2e/pages/LoginPage.ts
import { type Page, type Locator } from '@playwright/test'

export class LoginPage {
  readonly emailInput: Locator
  readonly passwordInput: Locator
  readonly submitButton: Locator
  readonly errorMessage: Locator

  constructor(private readonly page: Page) {
    this.emailInput = page.getByLabel('Email')
    this.passwordInput = page.getByLabel('Password')
    this.submitButton = page.getByRole('button', { name: 'Sign in' })
    this.errorMessage = page.getByRole('alert')
  }

  async goto() {
    await this.page.goto('/login')
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email)
    await this.passwordInput.fill(password)
    await this.submitButton.click()
  }
}
```

## Test Structure

```ts
import { test, expect } from '@playwright/test'
import { LoginPage } from './pages/LoginPage'

test.describe('Authentication', () => {
  test('redirects to dashboard after successful login', async ({ page }) => {
    const loginPage = new LoginPage(page)
    await loginPage.goto()

    await loginPage.login('alice@example.com', 'correct-password')

    await expect(page).toHaveURL('/dashboard')
    await expect(page.getByRole('heading', { name: 'Welcome, Alice' })).toBeVisible()
  })

  test('shows error message for invalid credentials', async ({ page }) => {
    const loginPage = new LoginPage(page)
    await loginPage.goto()

    await loginPage.login('alice@example.com', 'wrong-password')

    await expect(loginPage.errorMessage).toContainText('Invalid email or password')
    await expect(page).toHaveURL('/login')  // stays on login page
  })

  test('blocks access to protected routes when not authenticated', async ({ page }) => {
    await page.goto('/dashboard')
    await expect(page).toHaveURL('/login')
  })
})
```

## Fixtures for Shared State

Use fixtures to share setup across tests, especially for auth:

```ts
// e2e/fixtures/auth.ts
import { test as base } from '@playwright/test'
import { LoginPage } from '../pages/LoginPage'

type AuthFixtures = {
  authenticatedPage: Page
}

export const test = base.extend<AuthFixtures>({
  authenticatedPage: async ({ page }, use) => {
    const loginPage = new LoginPage(page)
    await loginPage.goto()
    await loginPage.login(process.env.TEST_USER_EMAIL!, process.env.TEST_USER_PASSWORD!)
    await page.waitForURL('/dashboard')
    await use(page)
  },
})
```

```ts
// e2e/checkout.spec.ts
import { test, expect } from './fixtures/auth'

test('completes checkout as authenticated user', async ({ authenticatedPage }) => {
  // already logged in
  await authenticatedPage.goto('/checkout')
  // ...
})
```

## Locator Strategy

Prefer locators that reflect user intent, in this priority order:

1. `getByRole()` — most resilient, reflects accessibility
2. `getByLabel()` — for form inputs
3. `getByText()` — for visible text content
4. `getByTestId()` — for interactive elements with no good semantic locator
5. `locator('css')` — last resort only

Avoid XPath and brittle CSS selectors like `.btn-primary > span:nth-child(2)`.

## API Mocking and State Setup

Don't drive the UI to set up preconditions — use the API directly. This makes tests
faster and more reliable:

```ts
test('displays order history', async ({ page, request }) => {
  // Seed data via API, not through the UI
  await request.post('/api/test/seed', {
    data: { userId: 'u_test', orders: 3 }
  })

  await page.goto('/orders')
  await expect(page.getByRole('row')).toHaveCount(4)  // header + 3 rows
})
```

Mock third-party APIs (payments, email) to avoid real charges and external dependencies:

```ts
await page.route('**/api/stripe/charge', async route => {
  await route.fulfill({ json: { status: 'succeeded', id: 'ch_test_123' } })
})
```

## Assertions

Always use Playwright's web-first assertions — they automatically wait and retry:

```ts
// ✓ Web-first — waits for element to appear
await expect(page.getByText('Order confirmed')).toBeVisible()
await expect(page.getByRole('button', { name: 'Submit' })).toBeDisabled()

// ✗ Don't manually wait — brittle
await page.waitForTimeout(2000)
```

## Configuration Essentials

```ts
// playwright.config.ts
import { defineConfig } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  use: {
    baseURL: process.env.BASE_URL ?? 'http://localhost:3000',
    trace: 'on-first-retry',    // capture traces on failure
    screenshot: 'only-on-failure',
  },
})
```

## Common Pitfalls to Avoid

- **Don't test every UI interaction** — that's what unit tests are for
- **Don't share browser state between tests** — use fresh contexts
- **Don't `waitForTimeout()`** — use `waitForURL()`, `waitForSelector()`, or web-first assertions
- **Don't hardcode credentials** — use environment variables
- **Don't assert on exact pixel positions** — use semantic assertions
- **Don't run E2E in watch mode** — they're too slow; run them in CI
