FROM alpine:3.14
ENV BIND9_VERSION 9.16.20

WORKDIR /usr/local/src

RUN apk --no-cache add wget tar xz make gcc g++ pkgconfig linux-headers py3-ply perl perl-doc libuv-dev openssl-dev && \
    wget https://downloads.isc.org/isc/bind9/${BIND9_VERSION}/bind-${BIND9_VERSION}.tar.xz && \
    tar Jxfv bind-${BIND9_VERSION}.tar.xz && \
    cd bind-${BIND9_VERSION}/ && \
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    LDFLAGS=-ldl && \
    ./configure --disable-linux-caps && \
    make -j 4 && \
    make install && \
    apk del --purge wget tar xz make gcc g++ pkgconfig linux-headers py3-ply perl perl-doc && \
    cd /usr/local/src/ && \
    rm -r bind-${BIND9_VERSION} && rm bind-${BIND9_VERSION}.tar.xz

RUN adduser -D named && \
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
