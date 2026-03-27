.PHONY: help up down restart logs build lint test seed clean status

DOCKER_DIR = docker

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Start all services
	cd $(DOCKER_DIR) && docker compose up -d --build

down: ## Stop all services
	cd $(DOCKER_DIR) && docker compose down

restart: ## Restart all services
	cd $(DOCKER_DIR) && docker compose restart

logs: ## Tail logs for all services
	cd $(DOCKER_DIR) && docker compose logs -f

logs-web: ## Tail Rails logs
	cd $(DOCKER_DIR) && docker compose logs -f web

build: ## Build Docker images
	cd $(DOCKER_DIR) && docker compose build

lint: ## Run RuboCop
	cd $(DOCKER_DIR) && docker compose exec web bundle exec rubocop

lint-fix: ## Fix RuboCop offenses
	cd $(DOCKER_DIR) && docker compose exec web bundle exec rubocop -A

test: ## Run RSpec tests
	cd $(DOCKER_DIR) && docker compose exec web bundle exec rspec

seed: ## Seed the database
	cd $(DOCKER_DIR) && docker compose exec web bin/rails db:seed

migrate: ## Run database migrations
	cd $(DOCKER_DIR) && docker compose exec web bin/rails db:migrate

setup: ## Set up database (create, migrate, seed)
	cd $(DOCKER_DIR) && docker compose exec web bin/rails db:prepare

console: ## Open Rails console
	cd $(DOCKER_DIR) && docker compose exec web bin/rails console

status: ## Show service status
	cd $(DOCKER_DIR) && docker compose ps

clean: ## Remove containers, volumes, build artifacts
	cd $(DOCKER_DIR) && docker compose down -v --remove-orphans

install: ## Install gems
	cd $(DOCKER_DIR) && docker compose exec web bundle install
