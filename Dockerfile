FROM ubuntu:20.04
ENV BIND9_VERSION 9.16.20

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /usr/local/src

RUN apt-get update -y && \
    apt-get install -y wget tar python3-dev python3-ply build-essential pkg-config && \
    apt-get install -y libssl-dev libffi-dev libuv1-dev && \
    \
    wget https://downloads.isc.org/isc/bind9/${BIND9_VERSION}/bind-${BIND9_VERSION}.tar.xz && \
    tar Jxfv bind-${BIND9_VERSION}.tar.xz && \
    cd bind-${BIND9_VERSION}/ && \
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    LDFLAGS=-ldl && \
    ./configure --disable-linux-caps && \
    make -j 4 && \
    make install && \
    \
    apt-get update -y && \
    apt-get remove --purge wget tar python3-dev python3-ply build-essential pkg-config && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd named && \
    mkdir -p /var/named && \
    chown named:named -R /var/named/ && \
    mkdir -p /run/named && \
    chown named:named -R /run/named && \
    mkdir -p /var/cache/bind && \
    chown named:named -R /var/cache/bind

USER named

EXPOSE 53
EXPOSE 53/udp

CMD ["/usr/local/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "named"]
