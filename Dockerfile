FROM golang:1.18-alpine3.16 AS go-builder
ARG BINARY_VERSION=v1.0.0-rc2
RUN addgroup -S appgroup && adduser -S big-dipper -G appgroup
USER big-dipper
RUN set -eux

WORKDIR /home/big-dipper/code

# Install babyd binary
RUN echo "Installing pylonsd binary"
ADD https://github.com/Pylons-tech/pylons/archive/refs/tags/${BINARY_VERSION}.tar.gz /home/big-dipper/code/
USER root
RUN tar -xf /home/big-dipper/code/${BINARY_VERSION}.tar.gz -C /home/big-dipper/code/ --strip-components=1

RUN go build -o bin/pylonsd -mod=readonly ./cmd/pylonsd

#-------------------------------------------
FROM golang:1.18-alpine3.16
RUN apk add --no-cache git bash py3-pip jq curl ruby supervisor
RUN addgroup -S appgroup && adduser -S big-dipper -G appgroup
RUN pip install toml-cli
USER big-dipper

WORKDIR /home/big-dipper/

COPY --from=go-builder /home/big-dipper/code/bin/pylonsd /usr/bin/pylonsd
COPY --from=go-builder /home/big-dipper/code/bin/pylonsd /home/big-dipper/
COPY scripts/* /home/big-dipper/
COPY trace.rb /home/big-dipper/trace.rb
USER root
RUN chmod +x /home/big-dipper/*.sh
RUN bash -c 'gem install google-cloud-bigquery'
# create and install the config to 
RUN mkdir -p /var/log/supervisord
RUN chown -R big-dipper:appgroup /var/log/supervisord
USER big-dipper
RUN pylonsd init test --chain-id pylons-testnet-3
RUN mkdir -p /home/big-dipper/.pylons/config/
COPY networks/pylons-testnet-3/genesis.json /home/big-dipper/.pylons/config/genesis.json

# rest server
EXPOSE 1317
# tendermint rpc
EXPOSE 26657
# p2p address
EXPOSE 26656
# gRPC address
EXPOSE 9090
# crete fifo trace file
RUN mkdir -p /home/big-dipper/trace
RUN mkfifo /home/big-dipper/trace/trace.fifo



COPY supervisord.conf /etc/supervisord/conf.d/supervisord.conf


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord/conf.d/supervisord.conf"]

 #CMD ["/start.sh"]

