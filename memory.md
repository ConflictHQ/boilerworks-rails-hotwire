# Boilerworks Memory

This file is the **AI context seed** for the Boilerworks Rails + Hotwire template. It captures decisions, constraints, and non-obvious facts that are not derivable from reading a single file.

For conventions and patterns, see [`bootstrap.md`](bootstrap.md).

---

## Template purpose

Server-rendered reactive Ruby starter: Rails 8.1.3 (Ruby 3.3), Hotwire (Turbo + Stimulus), Tailwind CSS 4, Pundit group-based authorization. Ships with the Rails 8 auth generator (session, bcrypt), Items/Categories CRUD, a JSON-schema forms engine (FormDefinition/FormSubmission, 22 field types), and a JSON-defined workflow engine (WorkflowDefinition/WorkflowInstance/TransitionLog, AASM).

## Key architectural decisions

| Decision | Why |
|---|---|
| Solid Queue / Solid Cache / Solid Cable | DB-backed Rails 8 defaults in production; dev uses the `async` job adapter and `memory_store` cache. No Redis dependency in the app (see known issues) |
| UUID as external identifier (`ExternalId` concern) | `to_param` is `uuid`; integer PKs are never exposed in routes or APIs |
| Soft deletes via `SoftDeletable` | Use `soft_delete!`, never `destroy`, on business data |
| `Auditable` + `Versionable` on all domain models | Audit trail is a hard requirement |
| Permission (slug) → Group (HABTM) → User | Pundit policies check `has?(slug)`; permissions are never assigned directly to users; `authorize` on every controller action |
| Turbo Stream for create/delete, Turbo Frame for edit | Reference Hotwire patterns; JS is importmaps + Stimulus (no package.json, no node build) |

## Things that bite newcomers

- **Seed credentials**: `admin@boilerworks.dev` / `password` (`db/seeds.rb`). Dev-only; change before any real deployment.
- **Tests**: RSpec via `make test`; SimpleCov enforces 60% minimum coverage (`spec/spec_helper.rb`).
- **App serves on 3000** (`docker/docker-compose.yml`); health check at `/up`; Mailpit on 8025, MinIO console on 9001.
- **No package.json** — JS is importmaps; `bin/importmap audit` is the JS dependency scanner in CI (dependabot covers bundler + github-actions only).

## Known issues (fleet audit 2026-07, issue #34)

- **Gemfile.lock is stale (as of 2026-07)** — `bin/bundler-audit` fails CI on main with three known CVEs (addressable, erb, net-imap); 12 dependabot PRs are stuck behind the red scan_ruby job. Needs a `bundle update` and PR triage.
- **Redis 7 is documented but unused** — README/bootstrap/CLAUDE/AGENTS list Redis and compose/CI run a redis service, but the Gemfile has no redis gem; cache/cable/jobs are all Solid (DB-backed). Known P2; remove or wire up.
- **Ruby patch mismatch** — `.ruby-version` pins 3.3.7 (CI, local dev) vs Dockerfile `RUBY_VERSION=3.3.11` (prod image). Align to 3.3.11.

## Release status

Template is feature-complete (10 models, forms + workflow engines, Pundit policies per model, RSpec suite, CI, docker). CI scan_ruby job is red pending the dependency refresh; last green run on main was 2026-03-30 (f3ae28e).
