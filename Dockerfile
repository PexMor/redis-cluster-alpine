FROM library/redis:4.0.2-alpine

RUN apk update && \
    apk upgrade && \
    apk add \
      net-tools supervisor ruby

ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

RUN wget -qO redis.tar.gz http://download.redis.io/releases/redis-4.0.2.tar.gz \
    && tar xfz redis.tar.gz -C / \
    && mv /redis-4.0.2 /redis

RUN sed  -i 's/^;childlogdir=/childlogdir=/' /etc/supervisord.conf
RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install redis

RUN mkdir /redis-conf && mkdir /redis-data && mkdir /var/log/supervisor

COPY ./docker-data/redis-cluster.tmpl /redis-conf/redis-cluster.tmpl
COPY ./docker-data/redis.tmpl /redis-conf/redis.tmpl

# Add supervisord configuration
COPY ./docker-data/supervisord.ini /etc/supervisor.d/redisclust.ini

# Add startup script
COPY ./docker-data/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

EXPOSE 7000 7001 7002 7003 7004 7005 7006 7007

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["redis-cluster"]
