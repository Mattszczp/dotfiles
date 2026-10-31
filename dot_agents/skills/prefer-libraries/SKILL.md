---
name: "prefer-libraries"
description: "Before hand-writing general-purpose functionality (HTTP, routing, data fetching, validation, dates, retries, CLI, dataframes), use or adopt a well-maintained library instead. Must always apply."
---

# Prefer well-maintained libraries over hand-rolled code

Don't write infrastructure that a mature library already provides. Hand-rolled HTTP clients, routers, caches, retry loops, date arithmetic, validators and dataframe logic are bugs and maintenance cost. Write your own code for the domain logic that is specific to this project.

## Step 1: Check what the project already uses

- Read the manifest and lockfile (package.json, pyproject.toml, requirements*.txt, go.mod, Cargo.toml).
- If a dependency already covers the need, use it. Don't add a second library for the same job.
- Check the codebase for an existing wrapper that does it, and use that.

## Step 2: If nothing fits, adopt a library

The picks below are starting points. The project's existing stack wins.

**Go is stdlib-first.** Use the standard library when it is good enough: net/http, encoding/json, log/slog (structured logging, since Go 1.21), time, context, flag, crypto/*, and sync. Reach for a library only for what the stdlib lacks:

- HTTP routing for anything beyond a single endpoint: go-chi/chi (it works directly with net/http handlers and middleware, so it fits stdlib-first code), or labstack/echo if the project wants a fuller framework with its own context type. Don't hand-write a router or a path-matching switch.
- Note: since Go 1.22, net/http's ServeMux matches methods and path wildcards (`mux.HandleFunc("GET /items/{id}", ...)`). A handful of routes can stay on the stdlib. Once you need route groups, nested routers, or middleware stacks per group, use chi.
- Concurrency groups, limits and panic-safe goroutines: golang.org/x/sync (errgroup, semaphore), or github.com/sourcegraph/conc, which adds panic propagation and a bounded pool. Pick one per project and don't mix them for the same job.
- Single-flight dedup of identical concurrent calls: golang.org/x/sync/singleflight (conc doesn't cover this)
- Rate limiting: golang.org/x/time/rate
- Retries and backoff: cenkalti/backoff, or hashicorp/go-retryablehttp for HTTP
- Config from env: caarlos0/env or koanf
- CLI: spf13/cobra or urfave/cli
- Validation tags on structs: go-playground/validator
- In-memory cache: hashicorp/golang-lru or dgraph-io/ristretto
- Postgres: jackc/pgx with sqlc for type-safe queries

**TypeScript / React:**

- Server-state fetching, caching, retries, invalidation: TanStack Query (framework-agnostic core is @tanstack/query-core)
- HTTP client: ky or ofetch. Native fetch is fine for a single call, but don't build a client layer over it.
- Schema validation of untrusted data: zod or valibot
- Dates and times: date-fns
- Retries and backoff: p-retry
- Concurrency limits: p-limit
- CLI parsing: commander or citty
- Env and config: zod parsing process.env
- Structured logging: pino

**Python:**

- HTTP client: httpx
- Schema validation and parsing: pydantic
- Dates and times: stdlib datetime with zoneinfo
- Retries and backoff: tenacity
- Concurrency limits: asyncio.Semaphore (stdlib)
- CLI: typer or click
- Env and config: pydantic-settings
- Structured logging: structlog

**Data science and dataframes:**

- Default to polars for in-memory tabular work. It has a lazy API (`pl.scan_*` then `.collect()`), so prefer it for anything beyond small files.
- Default to duckdb for SQL over files or larger-than-memory data. It queries CSV and Parquet directly (`duckdb.sql("select ... from 'data.parquet'")`), and has Python, Node, R, Go and other bindings.
- Don't introduce pandas into new code. Keep it only where the project already depends on it or a required library demands it (some statsmodels APIs, for example). Convert at the boundary with `to_pandas()` or `to_numpy()`, and don't rewrite working pandas code unless asked.

Security-sensitive code is never hand-rolled. Use the platform (node:crypto, Web Crypto, Go crypto/*, Python secrets and hashlib) or a widely used library.

## Step 3: Vet the candidate

Check the registry or module proxy and the repository. Don't rely on memory for versions or maintenance status.

- Maintained: a release in roughly the last year, issues answered, no deprecation or archive notice
- Adopted: high download counts or import counts, and recognisable users
- License compatible with the project
- Types included or maintained (for TypeScript)
- Footprint: bundle size for frontend code, number of transitive dependencies
- Fits the problem without forcing the app's architecture around it
- For a tiny single-maintainer package on a security-relevant job, choose a more established option or the platform's

## Step 4: Report the choice

- In the reply, name the library, its version and one line on why.
- Install with the project's package manager (go get, npm, uv, pip). Don't vendor or copy library code into the repo.
- Ask before adding when the choice is significant: a framework, a database layer, or a second library that overlaps an existing one.

## Don't

- Don't add a dependency for a few lines of code. Judge by the size of the problem.
- Don't reach for a library when the stdlib already does the job well, especially in Go.
- Don't wrap a library in your own abstraction just so you can swap it later. Use it directly.
