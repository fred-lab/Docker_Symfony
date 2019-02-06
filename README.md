# Docker Symfony

Lightweight dev environment for Symfony 4 with Docker.

## Requirement
- Docker
- Docker-compose

## How to use
- Clone this repo at the racine of the Symfony's project
- Rename **docker-compose.yml.dist** to **docker-compose.yml**
- Update **docker-compose.yml** with your information (port, database id....)
- Run ```docker-compose up -d```
- Go to "localhost" in a web browser
- Enjoy

## Annex
### Usefull command

```docker-compose up -d``` : Create and start containers. Each time the docker-compose.yml is modified, run this command.

```docker-compose build``` : Build or rebuild containers. Each time a Dockerfile is modified, run this command.

```docker-compose down``` : Stop and remove containers, networks, images and volumes. Usefull to restart with a clean state

```docker-compose ps``` : Display the list of containers and their status.

```docker-compose logs```: Display the logs

```docker-compose exec service_name sh``` : Connect to a running container with a shell terminal. Usefull to  test the container

```docker-compose run --rm service_name /bin/sh``` : Run a container and log into it with a shell terminal. This container is removed when it is stop. Usefull for debug

```docker images``` : Display all the image and their size

```docker rmi $(docker images -q) -f ``` : Force to remove every  unused images. Usefull to optimize the size

```docker rm $(docker images -q) -f ``` : Force to remove every  unused containers. Usefull to optimize the size