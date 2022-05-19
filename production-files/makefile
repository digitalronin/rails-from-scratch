# Build production docker image
PROJECT := PROJECT_NAME
PREFIX := docker compose --file compose-production.yml --project-name $(PROJECT)-application
RAILS := $(PREFIX) run --rm rails rails

TAG := $$PROJECT-rails

# Set RAILS_MASTER_KEY using '. .env' before running this
build-production-image:
	docker build \
		-f Dockerfile.production \
		--build-arg RAILS_MASTER_KEY=$$RAILS_MASTER_KEY \
		-t $(TAG) .

# Set RAILS_MASTER_KEY using '. .env' before running this
shell-on-production-image:
	docker run --rm \
		-e RAILS_MASTER_KEY=$$RAILS_MASTER_KEY \
		-it $(TAG) bash
