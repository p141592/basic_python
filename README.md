# DjangoUP Python basic image

### Before start 

Everything what you need you can find in project root.

Project settings `.env`

Project source `src`

Project requirements `requirements.pip` 

Script for start project localy `controle.sh`

### Run

`$ ./control.sh demo` 

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

[RU Guide](https://github.com/djangoup/basic_python/wiki/User-guide-%5BRU%5D)