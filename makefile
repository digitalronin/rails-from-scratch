TAG := rails-from-scratch

.built: Dockerfile
	docker build -t $(TAG) .
	touch .built

shell: .built
	docker run --rm \
		-v $$(pwd):/app \
		-it $(TAG) bash
