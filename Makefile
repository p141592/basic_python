# Registry where you want store your Docker images
DOCKER_REGISTRY = gcr.io/${GCLOUD-PROJECT-ID}
PORTS = 8080:8080
PROJECT_NAME = basic-python
GCLOUD-PROJECT-ID = home-260209
ENV = dev
MEMORY_LIMIT = 50M
ENV_VARIABLES = $(shell ./utils/convert_env.py $(shell pwd)/.env)

REPO_PATH := $(shell git rev-parse --show-toplevel)
CHANGED_FILES := $(shell git diff-files)

ifeq ($(strip $(CHANGED_FILES)),)
GIT_VERSION := $(shell git describe --tags --long --always)
else
GIT_VERSION := $(shell git describe --tags --long --always)-dirty-$(shell git diff | shasum -a256 | cut -c -6)
endif

IMG ?= ${DOCKER_REGISTRY}/${PROJECT_NAME}
TAG ?= $(GIT_VERSION)

activate:
	pip install --user poetry
	poetry install
	poetry shell

test:
	pytest -vv ${TEST_CASE}

lock:
	poetry lock

freez: lock
	poetry export -f requirements.txt > requirements.pip

linter:
	PYTHONPATH=$(shell pwd)/project poetry run black .

# pre production
build: linter test
	docker build -t ${IMG}:${TAG} .

run: build
	docker run -it -p ${PORTS} --rm --env-file .env ${IMG}:${TAG}

push: freez build
	docker push ${IMG}:${TAG}

# deploy
gcloud-deploy: push
	gcloud run deploy ${PROJECT_NAME} --image ${IMG}:${TAG} --memory ${MEMORY_LIMIT} --platform managed --set-env-vars ${ENV_VARIABLES}

gcloud-remove:
	gcloud run service delete ${PROJECT_NAME}
