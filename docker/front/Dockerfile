FROM nginx:mainline-alpine

LABEL maintainer="Fred Gauthier <fred.gauthier.dev@gmail.com>" \
  Description="A lightweigth Nginx container, build with Alpine"

# To avoid bugs with Windows to copy "nginx.conf" with Volume, simply copy it when container is build.
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx

RUN apk update \
  && rm -rf /var/cache/apk/*

EXPOSE 80

WORKDIR /home/docker
