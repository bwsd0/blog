HTMLTEST_VERSION=latest
export HTMLTEST_VERSION

.PHONY: all
all: run 

PORT := 1313

.PHONY: run
run: ## Serve content locally
	@hugo server -b localhost -D --port=$(PORT) --bind=0.0.0.0

.PHONY: build
build: # build with production settings
	@hugo --cleanDestinationDir --minify --environment production

.PHONY: favicons
favicons: ## Generate favicons for common resolutions
	@echo "Generate favicons"
	./scripts/favicons static/b.png static/favicon.ico

.PHONY: rm-exif
rm-exif: ## remove EXIF metadata from images
	@echo "Scrub image metadata"
	./scripts/rm-exif

.PHONY: test
test: ## run tests on generated HTML
	@docker pull wjdp/htmltest:$(HTMLTEST_VERSION)
	@hugo --cleanDestinationDir -b http://localhost:$(PORT) --environment development
	@docker run -w "/test" --mount "type=bind,source=$(CURDIR),target=/test" --rm \
		wjdp/htmltest:$(HTMLTEST_VERSION) -c /test/.htmltest.yml

.PHONY: clean
clean: ## clean most generated files
	@rm -rf public resources
	-@hugo --quiet --gc

.PHONY: help
help: ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'
