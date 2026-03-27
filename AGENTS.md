# Agents -- Boilerworks Rails + Hotwire

Read [`bootstrap.md`](bootstrap.md) before writing any code.

## Stack

- Rails 8.1.3 (Ruby 3.3) + Hotwire + Tailwind CSS 4
- Auth: Rails 8 auth generator
- Authorization: Pundit
- PostgreSQL 16, Redis 7, Solid Queue

## Key Files

- `app/models/concerns/` -- Auditable, SoftDeletable, ExternalId, Versionable
- `app/policies/` -- Pundit policies
- `app/services/` -- FormValidationService, WorkflowTransitionService
- `docker/docker-compose.yml` -- All services
- `Makefile` -- Common commands

## Quick Commands

```bash
make up    # Start services
make seed  # Seed data
make lint  # Lint
make test  # Test
```
