DOCKER_IMAGE = base_project
DOCKER_REGISTRY = registry.gitlab.com
PORTS = 8000:8000
SHELL := /bin/bash

requirements:
	pip install -r requirements.pip

venv:
	python -m venv venv
	chroot ${PWD} source /venv/bin/activate

unpack: venv requirements

build:
	docker build -t $(DOCKER_IMAGE) .

run:
	docker run -p ${PORTS} --rm $(DOCKER_IMAGE)
#
# local unpack:
# 	source ${PWD}/.env
# 	set +a
# 	./entrypoint.sh

push:
	docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${tag:-"latest"}

test:
	pytest tests${TEST_CASE}

pip-compile:
	pip-compile --generate-hashes --output-file requirements.pip requirements.in
