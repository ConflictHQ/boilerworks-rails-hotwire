# Claude -- Boilerworks Rails + Hotwire

Primary conventions doc: [`bootstrap.md`](bootstrap.md)

Read it before writing any code.

## Stack

- **Backend**: Rails 8.1.3 (Ruby 3.3)
- **Frontend**: Hotwire (Turbo + Stimulus) + Tailwind CSS 4
- **Auth**: Rails 8 auth generator (session-based, bcrypt)
- **Authorization**: Pundit (group-based permissions)
- **ORM**: Active Record (PostgreSQL 16)
- **Jobs**: Solid Queue (async adapter in dev)
- **Cache**: Redis 7
- **Admin**: Dashboard + CRUD views

## Quick Reference

| Service | URL |
|---------|-----|
| App | http://localhost:3000 |
| Health | http://localhost:3000/up |
| Mailpit | http://localhost:8025 |
| MinIO | http://localhost:9001 |

## Commands

```bash
make up          # Start all services
make seed        # Seed database
make lint        # RuboCop
make test        # RSpec
make console     # Rails console
make logs        # Tail logs
```

## Structure

```
app/
  models/concerns/   # Auditable, SoftDeletable, ExternalId, Versionable
  models/            # User, Group, Permission, Product, Category, FormDefinition, FormSubmission, WorkflowDefinition, WorkflowInstance, TransitionLog
  controllers/       # Dashboard, Products, Categories, FormDefinitions, FormSubmissions, WorkflowDefinitions, WorkflowInstances
  policies/          # Pundit policies per model
  services/          # FormValidationService, WorkflowTransitionService
  jobs/              # WorkflowActionJob
  views/             # ERB with Tailwind dark theme
  javascript/        # Stimulus controllers
```

## Rules

- Concerns go in `app/models/concerns/`
- Policies mirror models: `ProductPolicy` for `Product`
- All models use `uuid` for `to_param` (never expose integer IDs)
- Soft delete via `soft_delete!`, never `destroy`
- Pundit `authorize` on every controller action
- Turbo Stream responses for create/delete, Turbo Frame for edit
- No co-authorship messages in commits
