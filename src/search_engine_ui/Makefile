DOCKER_IMAGE_NAME       ?= ${USER_NAME}/$(shell basename `pwd`)
#DOCKER_IMAGE_TAG        ?= $(subst /,-,$(shell git rev-parse --abbrev-ref HEAD))
DOCKER_IMAGE_TAG ?= $(shell git log -1 --pretty=%h)
DOCK_BUILD=docker build -t

all: test coverage

dependencies:
	@echo ">> Installing dependencies"
	@pip install -r requirements.txt -r requirements-test.txt

test: dependencies
	@echo ">> Running tests"
	@python -m unittest discover -s tests/

coverage:
	@coverage run -m unittest discover -s tests/
	@coverage report --include crawler/crawler.py

build:
	@echo ">> Building Docker Image for UI Component"
	$(DOCK_BUILD) "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" .
	$(DOCK_BUILD) "$(DOCKER_IMAGE_NAME):latest" .

# @TODO: Build latest image just in master branch

.PHONY: all dependencies test build
