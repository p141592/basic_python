# Registry where you want store your Docker images
DOCKER_REGISTRY = gcr.io/${GCLOUD-PROJECT-ID}
PORTS = 8080:8080
TAG = latest
PROJECT_NAME = basic_python
GCLOUD-PROJECT-ID = home-260209
ENV = dev
MEMORY_LIMIT = 25M

# local
unpack: activate
	poetry install 

activate: venv 
	pip install --user poetry
	poetry env use venv/bin/python

venv:
	python -m venv venv

test:
	pytest -vv ${TEST_CASE}

lock:
	poetry lock 

freez: lock
	poetry export -f requirements.txt > requirements.pip

# pre production
build: test freez
	docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG} .

run: build
	docker run -it -p ${PORTS} --rm --env-file .env ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG}

push: build
	docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG}

# deploy
gcloud-deploy: push
	envs=$(python utils/convert_env.py)
	echo ${envs}
	gcloud run deploy ${PROJECT_NAME} --image ${DOCKER_REGISTRY}/${PROJECT_NAME}:${TAG} --memory ${MEMORY_LIMIT} --platform managed --set-env-vars ${envs}

gcloud-remove:
	gcloud run service delete ${PROJECT_NAME}
