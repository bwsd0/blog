SHELL := /bin/bash

AWS_S3_BUCKET := blog.bwasd.io
AWS_ACCESS_KEY := ${AWS_ACCESS_KEY_ID}
AWS_SECRET_KEY := ${AWS_SECRET_ACCESS_KEY}
export AWS_S3_BUCKET AWS_ACCESS_KEY AWS_SECRET_KEY

.PHONY: all
all: deploy

REGISTRY := 118167577690.dkr.ecr.eu-west-1.amazonaws.com/bwasd
DOCKER_IMAGE := $(REGISTRY)/blog

PORT := 1313

.PHONY: build
build: ## Build Docker image from Dockerfile
	docker build --rm --force-rm -t $(DOCKER_IMAGE) .

.PHONY: deploy
deploy: build ## Upload content to S3
	@docker run --rm -it \
		-e AWS_S3_BUCKET \
		-e AWS_ACCESS_KEY \
		-e AWS_SECRET_KEY \
		$(DOCKER_IMAGE)

.PHONY: run
run: clean build ## Serve content locally
	@docker run -d -v $(CURDIR):/usr/src/blog \
		-p $(PORT):$(PORT) \
		--name blog \
		$(DOCKER_IMAGE) hugo server -D --port=$(PORT) --bind=0.0.0.0

.PHONY: purge-cache
purge-cache: ## Invalidate CF CDN cache
	@docker run --rm -it \
		-e AWS_ACCESS_KEY \
		-e AWS_SECRET_KEY \
		-e AWS_CF_DISTRIBUTION_ID \
		-e AWS_S3_BUCKET=blog.bwasd.io \
		$(REGISTRY)/cf-reset-cache

.PHONY: clean
clean: ## Clean most generated files
	sudo $(RM) -r public
	-@docker rm -vf blog > /dev/null 2>&1

.PHONY: help
help: ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'
