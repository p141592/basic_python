# Registry where you want store your Docker images
DOCKER_REGISTRY = p141592
PORTS = 8000:8000
TAG = latest
PROJECT_NAME = base_python
ENV = dev

requirements:
	pip install --upgrade pip
	pip install poetry
	poetry install

unpack: requirements

build: freez
	docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG} .

run: build
	docker run -p ${PORTS} --rm --env-file .env ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG}

push: build
	docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG}

test:
	pytest -vv tests${TEST_CASE}

lock:
	poetry lock 

freez: lock
	poetry export -f requirements.txt > requirements.pip

helm: freez push
	helm upgrade -i ${ENV}-${PROJECT_NAME} --wait --set image.tag=${TAG} -f k8s/${ENV}-values.yaml k8s/${PROJECT_NAME}