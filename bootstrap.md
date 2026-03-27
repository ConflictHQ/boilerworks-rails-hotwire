# Boilerworks Rails + Hotwire -- Bootstrap

> Full-stack Rails 8 template with Hotwire, Pundit authorization, forms engine, and workflow engine.

## Stack

- Rails 8.1.3 (Ruby 3.3), Hotwire (Turbo + Stimulus), Tailwind CSS 4
- Auth: Rails 8 auth generator (session, bcrypt)
- Authorization: Pundit (group-based permissions)
- PostgreSQL 16, Redis 7, Solid Queue, Mailpit, MinIO

## Model Concerns

All domain models include: Auditable, SoftDeletable, ExternalId, Versionable.

## Permission System

Permission (slug) -> Group (HABTM) -> User. Pundit policies use `has?(slug)`.

## Forms Engine

FormDefinition (JSON schema) -> FormSubmission (JSON data). 22 field types. FormValidationService.

## Workflow Engine

WorkflowDefinition (JSON states/transitions) -> WorkflowInstance -> TransitionLog. AASM + WorkflowTransitionService.

## Docker

`make up` starts all services. `make seed` populates data. Admin: admin@boilerworks.dev / password.

## Testing

RSpec + FactoryBot. `make test`. Request/model/service/policy specs.

See [CLAUDE.md](CLAUDE.md) for full reference.
