FROM geoffreybooth/meteor-base:1.12.1

COPY package*.json app/

RUN bash scripts/build-app-npm-dependencies.sh

COPY . app/

#bundle is part of buld now
#RUN bash scripts/build-meteor-bundle.sh

FROM node:12.16.1-alpine

ENV APP_BUNDLE_FOLDER /opt/bundle
ENV SCRIPTS_FOLDER /docker

RUN apk --no-cache add \
    bash \
    g++ \
    make \
    python

COPY --from=0 scripts scripts/

COPY --from=0 $APP_BUNDLE_FOLDER/bundle $APP_BUNDLE_FOLDER/bundle/

RUN bash scripts/build-meteor-npm-dependencies.sh --build-from-source

FROM node:12.16.1-alpine

ENV APP_BUNDLE_FOLDER /opt/bundle
ENV SCRIPTS_FOLDER /docker

RUN apk --no-cache add \
    bash \
    ca-certificates

COPY --from=1 scripts scripts/

COPY --from=1 $APP_BUNDLE_FOLDER/bundle $APP_BUNDLE_FOLDER/bundle/
COPY default_settings.json $APP_BUNDLE_FOLDER/bundle/settings.json


ENTRYPOINT ["/docker/entrypoint.sh"]

CMD ["node","--max-old-space-size=4096", "main.js"]

