FROM ubuntu:latest as pylonsnode

RUN apt-get update && \
    apt-get -y install curl jq file

ADD  /release/pylons_linux_amd64.tar.gz                         /usr/bin/

RUN pylonsd init $(hostname) --home /root/.pylonsd

COPY /genesis/genesis.json                                      /root/.pylonsd/config/genesis.json

USER root

STOPSIGNAL SIGTERM

CMD pylonsd start

EXPOSE 26656 26657