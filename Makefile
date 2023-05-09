SHELL=/bin/bash
export SHELL
HTMLTEST_VERSION=latest
export HTMLTEST_VERSION

.PHONY: all
all: run 

PORT := 1313

.PHONY: run
run: ## Serve content locally
	@hugo server -b localhost -D --port=$(PORT) --bind=0.0.0.0

.PHONY: build
build: ## build a Docker development environment
	@docker build . --platform linux/amd64 -t bwsd.dev/blog:latest

.PHONY: prod
prod: build # build for production environment
	@hugo --cleanDestinationDir -v --minify --environment production

.PHONY: dev
dev: build ## build for development environment
	@hugo --cleanDestinationDir -b https://localhost:$(PORT) --environment development

.PHONY: images
images: favicons rm-exif svg

.PHONY: favicons
favicons: ## Generate favicons for common resolutions
	@echo "Generate favicons"
	./scripts/favicons static/images/b.png static/favicon.ico

.PHONY: rm-exif
rm-exif: ## remove EXIF metadata from images
	@echo "Scrub image metadata"
	./scripts/rm-exif

.PHONY: svg
svg: ## Run svgcheck on SVG images
	@docker run -i -w "/test" -v ./static:/test bwsd.dev/blog:latest /bin/sh -c \
		'find . -type f -iname "*.svg" -exec  svgcheck {} \;'

.PHONY: test
test: ## run tests on generated HTML
	@docker pull wjdp/htmltest:$(HTMLTEST_VERSION)
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
