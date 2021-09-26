FROM ubuntu:20.04
ENV BIND9_PPA isc/bind
ENV BIND9_PACKAGE 1:9.16.21-1+ubuntu21.04.1+isc+1 

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends --no-install-suggests software-properties-common && \
    add-apt-repository --yes --update ppa:${BIND9_PPA} && \
    apt-get -y install --no-install-recommends --no-install-suggests bind9=${BIND9_PACKAGE} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/named /etc/bind/zones && \
    chmod 775 /var/run/named && \
    chown root:bind /var/run/named

EXPOSE 53
EXPOSE 53/udp

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
