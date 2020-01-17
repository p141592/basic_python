DOCKER_IMAGE = base_project
DOCKER_REGISTRY = registry.gitlab.com # Registry where you want store your Docker images
PORTS = 8000:8000

requirements:
	pip install -r requirements.pip

unpack: requirements

build:
	docker build -t $(DOCKER_IMAGE) .

run:
	docker run -p ${PORTS} --rm --env-file .env $(DOCKER_IMAGE)

push:
	docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${tag:-"latest"}

test:
	pytest -vv tests${TEST_CASE}

freez:
	pip-compile --generate-hashes --output-file requirements.pip requirements.in
