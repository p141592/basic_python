DOCKER_REGISTRY = registry.gitlab.com # Registry where you want store your Docker images
PORTS = 8000:8000
PIP_INDEX = https://pypi.org/simple
TAG = latest
PROJECT_NAME = base_python
ENV = dev

requirements:
	pip install --upgrade pip
	pip install -r requirements.pip

unpack: requirements

build:
	docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG} .

run:
	docker run -p ${PORTS} --rm --env-file .env ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG}

push:
	docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG}

test:
	pytest -vv tests${TEST_CASE}

freez:
	pip-compile --generate-hashes --index-url ${PIP_INDEX} --output-file requirements.pip requirements.in

helm:
	helm upgrade -i ${ENV}-${PROJECT_NAME} --wait --set image.tag=${TAG} -f k8s/${ENV}-values.yaml k8s/${PROJECT_NAME}