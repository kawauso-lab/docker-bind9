# BIND9 Docker image

It is a docker image of bind9.

[Open Docker Hub](https://hub.docker.com/r/kawausolab/bind9/)

# Usage

1. Check out [Docker Hub](https://hub.docker.com/r/kawausolab/bind9/tags) to see what tags are available. This example uses 9.16.20. 
2. Prepare config files. ([example](https://github.com/marineotter/bind9-docker-example/tree/main/conf))
3. Run `docker run --rm -it -v /PATH/TO/CONFIGDIR:/etc/bind -p 53:53 -p 53:53/udp kawausolab/bind9:9.16.20`

# Contact

Please set up an Issue in this repository. This organization is a volunteer, but we will do our best to accommodate you. 
