TAG := foo

build:
	docker build -t $(TAG) .

shell:
	docker run --rm \
		-v $$(pwd):/app \
		-it $(TAG) bash
