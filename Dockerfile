FROM nginx:1.12.2

MAINTAINER Weiyan Shao "lighteningman@gmail.com"

WORKDIR /root

ENV DOCKER_GEN_VERSION 0.7.4

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-armhf.tar.gz /tmp/
ADD https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz /tmp/
ADD https://raw.githubusercontent.com/diafygi/acme-tiny/ad7802f1c47e5c31a8e7dfedb3577e6c7d04844a/acme_tiny.py /bin/acme_tiny

RUN tar xzf /tmp/s6-overlay-armhf.tar.gz -C / &&\
    tar -C /bin -xzf /tmp/docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/s6-overlay-armhf.tar.gz && \
    rm /etc/nginx/conf.d/default.conf && \
    apt-get update && \
    apt-get install -y python ruby cron iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./fs_overlay /

RUN chmod a+x /bin/*

VOLUME /var/lib/https-portal

ENTRYPOINT ["/init"]
