FROM ubuntu:latest as pylonsnode

RUN apt-get update && \
    apt-get -y install curl jq file

ARG   NODE
ARG   ACCOUNT_NAME
ENV   ACCOUNT=$ACCOUNT_NAME
COPY  pylonsd                                        /usr/bin/

STOPSIGNAL SIGTERM

EXPOSE 26656 26657