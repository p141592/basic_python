#!/usr/bin/env bash

COMMAND=$1
REGISTRY=''
CONTAINER_NAME=''
PORTS='8000:8000'
DIRECTORY=$(pwd)

kill_container () {
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
    docker build -t ${REGISTRY}/${CONTAINER_NAME} ${DIRECTORY}/.
}

d
case ${COMMAND} in
'push')
build
echo '=============PUSH================='
    docker push ${REGISTRY}/${CONTAINER_NAME}
;;

'logs')
build
echo '=============LOGS================='
kill_container
    docker run -d -p ${PORTS} --name ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME}
    docker log ${CONTAINER_NAME} -f
;;

'local')
build
echo '=============LOCAL================='
kill_container
    docker run -it -p ${PORTS} --name ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME} bash
;;

'daemon')
build
echo '=============DAEMON================='
kill_container
    docker run -d -p ${PORTS} --name ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME}
    sleep 2
    docker ps
;;

'start')
build
echo '=============START================='
kill_container
    docker run -d -p ${PORTS} --name ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME}
    sleep 2
    docker ps
;;

'stop')
echo '=============STOP================='
kill_container
    sleep 2
    docker ps
;;

'compose-start')
echo '=============COMPOSE START================='
    docker-compose -f ${DIRECTORY}/docker-compose.yml build
    docker-compose -f ${DIRECTORY}/docker-compose.yml up -d
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
