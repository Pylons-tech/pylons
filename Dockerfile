FROM starport/cli as builder

USER root

COPY app            /root/app/
COPY x              /root/x/
COPY docs           /root/docs/
COPY testutil       /root/testutil/
COPY proto          /root/proto/
COPY cmd            /root/cmd/
COPY config.yml     /root/config.yml
COPY go.mod         /root/go.mod

WORKDIR /root/

RUN starport chain init --home=/root/.pylons

CMD starport chain serve

FROM ubuntu:21.04 as pylons

USER root

COPY --from=builder /root/.pylons/ /root/.pylons/

COPY --from=builder /go/bin/pylonsd  /usr/bin/

CMD pylonsd start --home=/root/.pylons/

EXPOSE 1317 26657 26656