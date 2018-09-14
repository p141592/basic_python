#!/usr/bin/env bash

COMMAND=$1
REGISTRY='0.0.0.0:5000'
CONTAINER_NAME='djangoup-python'
PORTS='8000:8000'
DIRECTORY=$(pwd)

kill_container () {
    echo '=============KILL OLD================='
    if [ -n $(docker container ps -q -f name=${CONTAINER_NAME}) ]; then
        docker kill ${CONTAINER_NAME}
    fi
    sleep 2

    if [ -n $(docker container ps -a -q -f name=${CONTAINER_NAME}) ]; then
        docker rm ${CONTAINER_NAME}
    fi

}

build (){
    echo '=============BUILD================='
    docker build -t ${REGISTRY}/${CONTAINER_NAME} ${DIRECTORY}
}


case ${COMMAND} in
'demo')
    ./control.sh daemon && ./control.sh logs

;;

'push')
build
echo '=============PUSH================='
    docker push ${REGISTRY}/${CONTAINER_NAME}
;;

'logs')
echo '=============LOGS================='
    docker logs -f ${CONTAINER_NAME}
;;

'local')
build
kill_container
echo '=============LOCAL================='
    docker run -it -p ${PORTS} --env-file .env --name ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME} bash
;;

'daemon')
build
kill_container
echo '=============DAEMON================='
    docker run -d -p ${PORTS} --env-file .env --name ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME}
    sleep 2
    docker ps
;;

'start')
build
kill_container
echo '=============START================='
    docker run -p ${PORTS} --env-file .env --name ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME}
    sleep 2
    docker ps
;;

'stop')
kill_container
echo '=============STOP================='
    sleep 2
    docker ps
;;

'compose-start')
echo '=============COMPOSE START================='
    docker-compose -f ${DIRECTORY}/docker-compose.yml --env-file .env up --build
    sleep 2
    docker ps
;;

'compose-stop')
echo '=============COMPOSE STOP================='
    docker-compose -f ${DIRECTORY}/docker-compose.yml down
    sleep 2
    docker ps
;;

'help')
echo '=============HELP================='
echo '# REGISTRY'
echo ${REGISTRY}

echo '# CONTAINER_NAME'
echo ${CONTAINER_NAME}

echo '# PORTS'
echo ${PORTS}

echo '# DIRECTORY'
echo ${DIRECTORY}

esac

echo $(date)
