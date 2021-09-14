# Docker nginx proxy with LetsEncrypt SSL

This package aims to help you start a nginx proxy with LetsEncrypt SSL certificates using docker containers

- Docker containers to speed up development and deployment
- Nginx is a great web server and proxy, the best in performance says Buddha
- LetsEncrypts offers free SSL certificates to anyone

## Requirements

1. Tener Docker instalado
2. Instalar GITLAB RUNNER
3. Declar Variables de Entorno
4. Docker volume "certs", create it using the command `docker volume create certs`
5. Docker network "nginx-proxy", create it using the command `docker network create -d bridge nginx-proxy`

## 1. Tener Docker instalado

Pasos para la instalacion [Docker](https://www.digitalocean.com/community/tutorials/como-instalar-y-usar-docker-en-ubuntu-18-04-1-es)

## 2. Instalar GITLAB RUNNER

### Documentacion Oficial [Gitlab Runner](https://docs.gitlab.com/runner/install/docker.html), pasos a seguir :

2.1 Crar Volumenes para el contenedor :

Nomenglatura:

GR -> GITLAB RUNNER

GR - < NOMBRE-GRUPO > - < NOMBRE DEL VOLUMEN >

```
docker volume create GR-AZUDUPROB01-PROBONO-1-ETC
```

```
docker volume create GR-AZUDUPROB01-PROBONO-1-HOME
```

2.2 Generar Contenedor :
cambiar el nombre del runner por el nombre del grupo del repositorio ejemplo : --name GR-AZUDUPROB01-PROBONO-1

```
docker run -d \
  --name GR-AZUDUPROB01-PROBONO-1 \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v GR-AZUDUPROB01-PROBONO-1-ETC:/etc/gitlab-runner \
  -v GR-AZUDUPROB01-PROBONO-1-HOME:/home/gitlab-runner \
  --privileged \
  gitlab/gitlab-runner:latest
```

2.3 Configurar Contenedor, Cambiar "yourGitlabGroupToken" por el token de tu runner y tag-list por el nombre de la VM ejemplo AZUDUPROB01 :

```
docker exec -it GR-AZUDUPROB01-PROBONO-1 gitlab-runner register \
  --non-interactive \
  --executor docker \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
  --url "https://gitlab.com/" \
  --docker-image "tmaier/docker-compose" \
  --registration-token "NhtQsFR5_y4VrcAzzbo9" \
  --description "docker-runner" \
  --tag-list "AZUDUPROB01" \
  --run-untagged="true" \
  --locked="false"
  --docker-privileged

```

## Logging

```bash
# print all logs
docker-compose logs

# print all logs and follow them
docker-compose logs -f

# print all logs but only last 100 lines
docker-compose logs --tail=100

# to print logs from only one service, just add the service name at the end of the command
docker-compose logs -f --tail=100 nginx
```

GitLab Runner must be installed on the project server, the requirements:

- Executor must be docker.
- Tag used in the GitLab Runner must match the one on the `.gitlab-ci.yml` file

### Portainer

[Portainer](http://portainer.io/) consists of a web UI that allows you to easily manage your Docker containers, images, networks and volumes.

### Generate a new password

```shell
# You can generate an encrypted password with the following command:
$ htpasswd -nb -B admin <password> | cut -d ":" -f 2

# or if your system does not provide htpasswd you can use a docker container with the command:
$ docker run --rm httpd:2.4-alpine htpasswd -nbB admin <password> | cut -d ":" -f 2

# After generated, you must update the files on the htpasswd folder
# If portainer, you must update the 'command' keyword on docker-compose.yml
# default password: ayudarparaayudarProbono
```
