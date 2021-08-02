FROM ubuntu:latest as alpha-validator

RUN apt-get update && \
    apt-get -y install curl jq file

ADD  /release/pylons_linux_amd64.tar.gz                         /usr/bin/
COPY /docker/.pylonsd/                                          /root/.pylonsd/
COPY /docker/entrypoint.sh                                      /usr/bin/entrypoint.sh


USER root

STOPSIGNAL SIGTERM

ENTRYPOINT entrypoint.sh

EXPOSE 26656 26657


FROM ubuntu:latest as validator

RUN apt-get update && \
    apt-get -y install curl jq file

ADD  /release/pylons_linux_amd64.tar.gz                         /usr/bin/
COPY /docker/entrypoint.sh                                      /usr/bin/entrypoint.sh

USER root

STOPSIGNAL SIGTERM

RUN pylonsd init $(hostname) --home /root/.pylonsd/

COPY /docker/.pylonsd/config/genesis.json                       /root/.pylonsd/config/genesis.json



ENTRYPOINT entrypoint.sh

EXPOSE 26656 26657

