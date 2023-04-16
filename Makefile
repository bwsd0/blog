AWS_S3_BUCKET := blog.bwsd.dev
AWS_ACCESS_KEY := ${AWS_ACCESS_KEY_ID}
AWS_SECRET_KEY := ${AWS_SECRET_ACCESS_KEY}
AWS_CF_DISTRIBUTION_ID := ${AWS_CF_DISTRIBUTION_ID}

.PHONY: all
all: run 

PORT := 1313

.PHONY: run
run: ## Serve content locally
	@hugo server -D --port=$(PORT) --bind=0.0.0.0

.PHONY: favicons
favicons: ## Generate favicons for common resolutions
	@echo "Generate favicons"
	$(shell convert static/b.png  -background white \
		\( -clone 0 -resize 16x16 -extent 16x16 \) \
		\( -clone 0 -resize 32x32 -extent 32x32 \) \
		\( -clone 0 -resize 48x48 -extent 48x48 \) \
		\( -clone 0 -resize 64x64 -extent 64x64 \) \
		-delete 0 -alpha on -colors 256 static/favicon.ico)

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
