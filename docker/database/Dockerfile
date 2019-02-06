FROM alpine:latest

LABEL maintainer="Fred Gauthier <fred.gauthier.dev@gmail.com>" \
    Description="A lightweigth MariaDB container, build with Alpine"

RUN mkdir /docker-entrypoint-initdb.d \
    && apk update \
    && apk add --no-cache mariadb mariadb-client \
    # Use tzdata to resolve this error : There were fatal errors during processing of zoneinfo directory
    && apk add --no-cache tzdata \
    # ensure that mysql own /var/lib/mysql
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 777 /run/mysqld \
    && rm -rf /var/cache/apk/*

COPY initDB.sh /usr/local/bin/

ENTRYPOINT ["initDB.sh"]

VOLUME /var/lib/mysql
EXPOSE 3306
CMD [ "mysqld", "--user=mysql" ]