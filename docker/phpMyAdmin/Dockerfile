FROM alpine:latest

LABEL maintainer="Fred Gauthier <fred.gauthier.dev@gmail.com>" \
    Description="A lightweigth PhpMyAdmin container for MySql & MariaDB, build with Alpine"

# See available version here : https://www.phpmyadmin.net/files/ or use "lastest" for the latest stable version
ENV PHPMYADMIN_VERSION=latest
# Availables languages : "all-languages" (~10MB) or "english" (~5MB)
ENV PHPMYADMIN_LANGUAGE=english

RUN apk update \
    && apk add --no-cache --virtual build-dependencies wget tar \
    && mkdir -p /var/www/ \
    && cd /var/www/ \
    # Download phpMyAdmin archive
    && wget https://www.phpmyadmin.net/downloads/phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANGUAGE}.tar.gz \
    # Rename phpMyAdmin archive
    && mv phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANGUAGE}.tar.gz phpmyadmin.tar.gz \
    # Extract phpMyAdmin archive
    && tar zxvf phpmyadmin.tar.gz\
    # Delete phpMyAdmin archive
    && rm phpmyadmin.tar.gz \
    && apk del --purge build-dependencies \
    && rm -rf /var/cache/apk/*

# ENTRYPOINT ["/bin/sh"]