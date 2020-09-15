AWS_S3_BUCKET := blog.bwasd.io
AWS_ACCESS_KEY := ${AWS_ACCESS_KEY_ID}
AWS_SECRET_KEY := ${AWS_SECRET_ACCESS_KEY}
AWS_CF_DISTRIBUTION_ID := ${AWS_CF_DISTRIBUTION_ID}

export AWS_S3_BUCKET AWS_ACCESS_KEY AWS_SECRET_KEY

.PHONY: all
all: run 

PORT := 1313

.PHONY: deploy
deploy: ## Upload content to S3
	@./deploy.sh

.PHONY: run
run: ## Serve content locally
	@hugo server -D --port=$(PORT) --bind=0.0.0.0

# https://stackoverflow.com/a/47008498
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

# FIXME: supress make error because file is being created
.PHONY: post
post: ## Make a new post
	@hugo new -c ./content $(call args, foo.md) -k post  || true

.PHONY: purge-cache
purge-cache: ## Invalidate all cached files from CloudFront edge servers
	@aws cloudfront create-invalidation \
		--distribution-id $(AWS_CF_DISTRIBUTION_ID) \
		--paths "/*"

.PHONY: clean
clean: ## Clean most generated files
	@rm -rf public resources
	-@hugo --quiet --gc

.PHONY: help
help: ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'
