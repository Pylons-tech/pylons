FROM golang:1.18-alpine3.16 AS go-builder

RUN set -eux

RUN apk add --no-cache ca-certificates git build-base linux-headers

WORKDIR /code

# Install babyd binary
RUN echo "Installing pylonsd binary"
ADD https://github.com/Pylons-tech/pylons/archive/refs/tags/v0.4.2.tar.gz /code/
RUN tar -xf v0.4.2.tar.gz -C /code/ --strip-components=1
RUN go build -o bin/pylonsd -mod=readonly ./cmd/pylonsd

#-------------------------------------------
FROM golang:1.18-alpine3.16

RUN apk add --no-cache bash py3-pip jq curl
RUN pip install toml-cli

WORKDIR /

COPY --from=go-builder /code/bin/pylonsd /usr/bin/pylonsd
COPY --from=go-builder /code/bin/pylonsd /
COPY scripts/* /
RUN chmod +x /*.sh

# rest server
EXPOSE 1317
# tendermint rpc
EXPOSE 26657
# p2p address
EXPOSE 26656
# gRPC address
EXPOSE 9090

# wrong ENTRYPOINT can lead to executable not running
ENTRYPOINT ["/bin/bash", "test_node_deploy.sh"]