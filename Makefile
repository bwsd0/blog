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
build:
	docker build --rm --force-rm -t $(DOCKER_IMAGE) .

.PHONY: deploy
deploy: build
	@docker run --rm -it \
		-e AWS_S3_BUCKET \
		-e AWS_ACCESS_KEY \
		-e AWS_SECRET_KEY \
		$(DOCKER_IMAGE)

.PHONY: run
run: clean build
	@docker run -d -v $(CURDIR):/usr/src/blog \
		-p $(PORT):$(PORT) \
		--name blog \
		$(DOCKER_IMAGE) hugo server --port=$(PORT) --bind=0.0.0.0

.PHONY: purge-cache
purge-cache:
	@docker run --rm -it \
		-e AWS_ACCESS_KEY \
		-e AWS_SECRET_KEY \
		-e AWS_CF_DISTRIBUTION_ID \
		-e AWS_S3_BUCKET=blog.bwasd.io \
		$(REGISTRY)/cf-reset-cache

.PHONY: clean
clean:
	sudo $(RM) -r public
	-@docker rm -vf blog > /dev/null 2>&1
