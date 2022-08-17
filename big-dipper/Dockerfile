FROM geoffreybooth/meteor-base:2.7.3

COPY . app/

RUN bash app/scripts/build.sh

FROM node:14.2.0-alpine

RUN apk --no-cache add \
    bash \
    g++ \
    make \
    python


COPY --from=0 app/output/bundle app/bundle/

CMD ["node","--max-old-space-size=4096", "app/bundle/main.js"]

