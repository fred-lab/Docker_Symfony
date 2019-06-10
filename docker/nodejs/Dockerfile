FROM node:lts-alpine

LABEL maintainer="Fred Gauthier <fred.gauthier.dev@gmail.com>" \
    Description="A lightweigth Nodejs container, build with Alpine"

ARG HOST_USER
ARG HOST_USERGROUP

WORKDIR /home/docker

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN apk update \
#    && npm install  nodemon -g \
    && chmod 777 /usr/local/bin/docker-entrypoint.sh \
    # Change the host user id to node to avoid permissions issues
    && echo -e '\033[0;31m' Change user permissions '\033[0m' \
    && cd /home/docker \
    && apk --no-cache add shadow && usermod -u $HOST_USER node && groupmod -g $HOST_USERGROUP node \
    && echo -e '\033[0;31m' Check Permissions for Workdir'\033[0m' $PWD \
    && ls -la \
    && apk del shadow \
    # Clean up apk cache folder and the virtuals folders
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000

USER node

