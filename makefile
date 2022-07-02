TAG := rails-from-scratch

.built: Dockerfile
	docker build -t $(TAG) .
	touch .built

# Usage: PROJECT=foobar make create-rails-app
create-rails-app: .built
	docker run --rm \
		-v $$(pwd):/app \
		-e PROJECT=$${PROJECT} \
		$(TAG) ./create-rails-app.sh; \
	cd $${PROJECT}; \
	make provision; \
	git add . ; git commit -m "Initial commit"

shell: .built
	docker run --rm \
		-v $$(pwd):/app \
		-it $(TAG) bash

# Clean up docker artifacts, so we can re-use rails application names
clean:
	docker volume prune
	docker image prune
