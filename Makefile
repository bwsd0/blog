AWS_S3_BUCKET := blog.bwasd.io
AWS_ACCESS_KEY := ${AWS_ACCESS_KEY_ID}
AWS_SECRET_KEY := ${AWS_SECRET_ACCESS_KEY}
AWS_CF_DISTRIBUTION_ID := ${AWS_CF_DISTRIBUTION_ID}

export AWS_S3_BUCKET AWS_ACCESS_KEY AWS_SECRET_KEY

REGISTRY := ${AWS_ECR_REGISTRY}
DOCKER_IMAGE := $(REGISTRY)/blog

.PHONY: all
all: deploy


PORT := 1313

.PHONY: build
build: ## Build Docker image from Dockerfile
	@docker build --rm --force-rm -t $(DOCKER_IMAGE) .

.PHONY: deploy
deploy: build ## Upload content to S3
	@docker run --rm -it \
		-e AWS_S3_BUCKET \
		-e AWS_ACCESS_KEY \
		-e AWS_SECRET_KEY \
		$(DOCKER_IMAGE)

.PHONY: run
run: build ## Serve content locally
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
		-e AWS_S3_BUCKET \
		$(REGISTRY)/cf-reset-cache

.PHONY: clean
clean: ## Clean most generated files
	@rm -rf public \
		resources
	-@docker rm -vf blog 2>/dev/null || true
	-@hugo --quiet --gc

.PHONY: help
help: ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'
