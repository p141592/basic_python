# DjangoUP Python basic image

### Before start 

Everything what you need you can find in project root.

Project settings `.env`

Project source `src`

Project requirements `requirements.pip` 

Script for start project localy `controle.sh`

### Start develop

You can make control script like global util and run anywhere

* Open project root directory 

* Create link `ln -s $(pwd)/control.sh /usr/local/bin/djangoup`

* Get except rights for script `chmod +x /usr/local/bin/djangoup`

### Run

`$ djangoup compose-start` 

Control script commands:

```text
push
  push docker image to registry

logs
  follow to docker container logs

local
  start docker container with `-it` arguments

daemon
  start docker container in background

start
  start docker container in interactive

stop
  stop docker container

compose-start
  start background docker-compose project

compose-stop
  stop background docker-compose project

``` 