# Registry where you want store your Docker images
DOCKER_REGISTRY = gcr.io/${GCLOUD-PROJECT-ID}
PORTS = 8080:8080
TAG = latest
PROJECT_NAME = basic_python
GCLOUD-PROJECT-ID = home-260209
ENV = dev

requirements:
	pip install --upgrade pip
	pip install poetry
	poetry install

unpack: requirements

build: freez
	docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG} .

run: build
	docker run -p ${PORTS} --rm -d --env-file .env ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG}

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

gcloud-deploy: push
	gcloud run deploy --image ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG} --platform managed
