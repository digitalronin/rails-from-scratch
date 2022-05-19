TAG := rails-from-scratch

.built: Dockerfile
	docker build -t $(TAG) .
	touch .built

shell: .built
	docker run --rm \
		-v $$(pwd):/app \
		-it $(TAG) bash

# Clean up docker artifacts, so we can re-use rails application names
clean:
	docker volume prune
	docker image prune
