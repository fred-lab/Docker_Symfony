FROM alpine:latest

LABEL maintainer="Fred Gauthier <fred.gauthier.dev@gmail.com>" \
    Description="A lightweigth MariaDB container, build with Alpine"

ENV DB_DATA_PATH="/var/lib/mysql"
ARG MAX_ALLOWED_PACKET="200M"
ARG TIMEZONE=Europe/Paris

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN apk update \
    # Install MariaDB + tzdata
    && apk add --no-cache mariadb mariadb-client \
    && apk add --no-cache --virtual timezone-dependencies tzdata\
    # Configure MariaDB
    && chmod 777 /usr/local/bin/docker-entrypoint.sh \
    # Configure local timezone
    && ls /usr/share/zoneinfo  \
    && cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE >  /etc/timezone \
    # Edit Mariadb
    && sed -ire 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf \
    && sed -ie "/\[mysqld\]/a max_allowed_packet=$MAX_ALLOWED_PACKET" /etc/my.cnf.d/mariadb-server.cnf \
    && sed -ie "/\[mysqld\]/a skip-name-resolve" /etc/my.cnf.d/mariadb-server.cnf \
    #Create initdb.d folder
    && mkdir  initdb.d\
    # Clean up
    && apk del --purge timezone-dependencies \
    && rm -rf /var/cache/apk/*

VOLUME /var/lib/mysql

COPY ./initdb.d /initdb.d

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld_safe"]