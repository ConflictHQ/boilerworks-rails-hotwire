# Boilerworks Rails + Hotwire

Full-stack Rails 8 template with Hotwire (Turbo + Stimulus), Pundit group-based authorization, JSON forms engine, and JSON workflow engine.

## Stack

- Rails 8.1.3 (Ruby 3.3), Hotwire, Tailwind CSS 4
- Auth: Rails 8 auth generator (session, bcrypt)
- Authorization: Pundit (group-based permissions)
- PostgreSQL 16, Redis 7, Solid Queue, Mailpit, MinIO
- Docker Compose (6 services)

## Features

- Group-based permission system with Pundit policies
- Model concerns: Auditable, SoftDeletable, ExternalId, Versionable
- Product + Category CRUD with Turbo Frame/Stream responses
- JSON Schema forms engine (22 field types, validation, form builder)
- JSON workflow engine (state machines, conditions, async actions)
- Boilerworks dark theme
- RSpec tests with FactoryBot
- GitHub Actions CI

## Quick Start

```bash
make up      # Start all services
make seed    # Seed database
# Open http://localhost:3000
# Admin: admin@boilerworks.dev / password
```

## Commands

```bash
make up / down / restart / logs / status
make seed / migrate / setup / console
make lint / lint-fix / test
make clean
```

## Services

| Service | URL |
|---------|-----|
| App | http://localhost:3000 |
| Health | http://localhost:3000/up |
| Mailpit | http://localhost:8026 |
| MinIO Console | http://localhost:9003 |

## Documentation

- [bootstrap.md](bootstrap.md) -- Conventions and patterns
- [CLAUDE.md](CLAUDE.md) -- Claude agent configuration
- [AGENTS.md](AGENTS.md) -- Generic agent shim
