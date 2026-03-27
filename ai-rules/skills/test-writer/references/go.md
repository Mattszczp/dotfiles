# Go — Tests with testify and Table-Driven Tests

## Packages

```go
import (
    "testing"
    "github.com/stretchr/testify/assert"   // non-fatal assertions (test continues)
    "github.com/stretchr/testify/require"  // fatal assertions (test stops immediately)
    "github.com/stretchr/testify/mock"     // mocking
    "github.com/stretchr/testify/suite"    // test suites with shared setup/teardown
)
```

**Rule of thumb:** Use `require` when the test cannot meaningfully continue if the
assertion fails (e.g., if `err != nil`, further assertions are meaningless). Use
`assert` when you want to collect multiple failures in one run.

## File Naming

- `internal/billing/invoice.go` → `internal/billing/invoice_test.go`
- Integration tests: `internal/billing/invoice_integration_test.go`
- Use `package billing_test` for black-box testing (preferred), or `package billing`
  for white-box when you need to access unexported internals.

## Table-Driven Tests

Table-driven tests are idiomatic Go. Use them whenever you have the same logic to test
with multiple inputs. They eliminate repetition and make it easy to add cases.

```go
func TestFormatCurrency(t *testing.T) {
    tests := []struct {
        name     string
        amount   float64
        currency string
        want     string
        wantErr  bool
    }{
        {
            name:     "positive USD amount",
            amount:   1234.56,
            currency: "USD",
            want:     "$1,234.56",
        },
        {
            name:     "zero amount",
            amount:   0,
            currency: "USD",
            want:     "$0.00",
        },
        {
            name:     "negative amount returns error",
            amount:   -1,
            currency: "USD",
            wantErr:  true,
        },
        {
            name:     "unknown currency returns error",
            amount:   10,
            currency: "XYZ",
            wantErr:  true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := FormatCurrency(tt.amount, tt.currency)

            if tt.wantErr {
                require.Error(t, err)
                return
            }

            require.NoError(t, err)
            assert.Equal(t, tt.want, got)
        })
    }
}
```

Name cases descriptively — they appear in test output as
`TestFormatCurrency/positive_USD_amount`. Avoid generic names like `"case 1"`.

## Mocking with testify/mock

Define an interface for the dependency, then mock it:

```go
// In production code — depend on the interface, not the concrete type
type EmailSender interface {
    Send(ctx context.Context, msg EmailMessage) (string, error)
}

// In test file
type MockEmailSender struct {
    mock.Mock
}

func (m *MockEmailSender) Send(ctx context.Context, msg EmailMessage) (string, error) {
    args := m.Called(ctx, msg)
    return args.String(0), args.Error(1)
}

func TestNotifyUser(t *testing.T) {
    sender := &MockEmailSender{}
    sender.On("Send", mock.Anything, mock.MatchedBy(func(msg EmailMessage) bool {
        return msg.To == "alice@example.com"
    })).Return("msg_123", nil)

    svc := NewNotificationService(sender)
    err := svc.NotifyUser(context.Background(), "alice@example.com", "purchase")

    require.NoError(t, err)
    sender.AssertExpectations(t)  // verifies Send was called as expected
}
```

Always call `sender.AssertExpectations(t)` at the end — it catches unexpected or
missing calls.

## Integration Tests

Use build tags to separate integration tests so they don't run on every `go test ./...`:

```go
//go:build integration

package billing_test

import (
    "context"
    "testing"
    "github.com/stretchr/testify/require"
    "github.com/stretchr/testify/suite"
)
```

Run them explicitly: `go test -tags=integration ./...`

**Suite pattern for shared DB setup:**

```go
type InvoiceRepoSuite struct {
    suite.Suite
    db   *sql.DB
    repo *InvoiceRepository
}

func (s *InvoiceRepoSuite) SetupSuite() {
    db, err := sql.Open("postgres", os.Getenv("TEST_DATABASE_URL"))
    s.Require().NoError(err)
    s.db = db
    s.repo = NewInvoiceRepository(db)
}

func (s *InvoiceRepoSuite) SetupTest() {
    // clean state before each test
    _, err := s.db.Exec("TRUNCATE invoices CASCADE")
    s.Require().NoError(err)
}

func (s *InvoiceRepoSuite) TearDownSuite() {
    s.db.Close()
}

func (s *InvoiceRepoSuite) TestCreateAndRetrieve() {
    ctx := context.Background()

    created, err := s.repo.Create(ctx, InvoiceInput{
        CustomerID: "cust_abc",
        Amount:     9900,
        Currency:   "USD",
    })
    s.Require().NoError(err)
    s.NotEmpty(created.ID)

    found, err := s.repo.FindByID(ctx, created.ID)
    s.Require().NoError(err)
    s.Equal(created.ID, found.ID)
    s.Equal(int64(9900), found.Amount)
}

// Required boilerplate to run the suite
func TestInvoiceRepoSuite(t *testing.T) {
    suite.Run(t, new(InvoiceRepoSuite))
}
```

## Testing HTTP Handlers

Use `net/http/httptest` — no need for a real server:

```go
func TestCreateInvoiceHandler(t *testing.T) {
    tests := []struct {
        name       string
        body       string
        wantStatus int
        wantBody   string
    }{
        {
            name:       "valid request creates invoice",
            body:       `{"customer_id":"cust_1","amount":1000}`,
            wantStatus: http.StatusCreated,
            wantBody:   `"id"`,
        },
        {
            name:       "missing customer_id returns 400",
            body:       `{"amount":1000}`,
            wantStatus: http.StatusBadRequest,
        },
        {
            name:       "invalid JSON returns 400",
            body:       `not-json`,
            wantStatus: http.StatusBadRequest,
        },
    }

    handler := NewInvoiceHandler(mockInvoiceService)

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            req := httptest.NewRequest(http.MethodPost, "/invoices",
                strings.NewReader(tt.body))
            req.Header.Set("Content-Type", "application/json")
            rec := httptest.NewRecorder()

            handler.ServeHTTP(rec, req)

            assert.Equal(t, tt.wantStatus, rec.Code)
            if tt.wantBody != "" {
                assert.Contains(t, rec.Body.String(), tt.wantBody)
            }
        })
    }
}
```

## Parallel Tests

Mark independent tests as parallel to speed up your suite:

```go
func TestSomething(t *testing.T) {
    t.Parallel()  // this test can run concurrently with other parallel tests
    // ...
}
```

In table-driven tests, capture the loop variable:

```go
for _, tt := range tests {
    tt := tt  // capture range variable (required before Go 1.22)
    t.Run(tt.name, func(t *testing.T) {
        t.Parallel()
        // ...
    })
}
```

## Common Pitfalls to Avoid

- **Don't use `assert` when the test can't continue** — use `require` for nil checks
  before dereferencing, DB setup, etc.
- **Don't name cases `"test 1"`, `"case 2"`** — names appear in output; make them descriptive
- **Don't ignore `err` in tests** — always `require.NoError(t, err)` or explicitly
  assert the error
- **Don't use `time.Sleep()` in tests** — use channels, `sync.WaitGroup`, or retries
- **Don't share global state between tests** — each test should be independent
- **Don't forget `TearDownSuite`** — always close DB connections and release resources
