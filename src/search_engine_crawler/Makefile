DOCKER_IMAGE_NAME       ?= ${USER_NAME}/$(shell basename `pwd`)
#DOCKER_IMAGE_TAG        ?= $(subst /,-,$(shell git rev-parse --abbrev-ref HEAD))
DOCKER_IMAGE_TAG ?= $(shell git log -1 --pretty=%h)

dependencies:
	@echo ">> Installing dependencies"
	@pip install -r requirements.txt -r requirements-test.txt

test: dependencies
	@echo ">> Running tests"
	@python -m unittest discover -s tests/

build:
	@echo ">> Building Docker Image for Crawler Component"
	@docker build -t "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" .
	@docker build -t "$(DOCKER_IMAGE_NAME):latest" .

.PHONY: all dependencies test builds
