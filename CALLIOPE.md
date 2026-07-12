# Calliope — Boilerworks Rails + Hotwire
<!-- Agent shim for https://github.com/calliopeai/calliope-cli -->

Primary conventions doc: [`bootstrap.md`](bootstrap.md)
Context seed: [`memory.md`](memory.md)

Read both before writing any code.

---

## Project-specific notes

- Stack: Rails 8.1.3 / Ruby 3.3, Hotwire (Turbo + Stimulus), Tailwind 4, Pundit, PostgreSQL 16, Redis 7, Solid Queue.
- All domain models include the concerns: Auditable, SoftDeletable, ExternalId, Versionable.
- Group-based permissions via Pundit (`has?(slug)`); `authorize` on every controller action.
- Expose `uuid` via `to_param`, never integer IDs; soft delete via `soft_delete!`, never `destroy`.
- JSON forms engine (FormDefinition → FormSubmission, 22 field types) and JSON workflow engine (AASM state machines + TransitionLog).
- Docker via `make up`/`make seed`; RSpec + FactoryBot via `make test`; RuboCop via `make lint`.
