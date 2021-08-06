FROM ubuntu:latest as pylonsnode

RUN apt-get update && \
    apt-get -y install curl jq file

ARG CONFIG_DIR

COPY pylonsd                        /usr/bin/
COPY dasel                          /usr/bin/

STOPSIGNAL SIGTERM

CMD pylonsd start

EXPOSE 26656 26657 1317
