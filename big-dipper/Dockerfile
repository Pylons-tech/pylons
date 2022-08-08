FROM geoffreybooth/meteor-base:2.7.3

COPY package*.json $APP_SOURCE_FOLDER/

RUN bash $SCRIPTS_FOLDER/build-app-npm-dependencies.sh

COPY . $APP_SOURCE_FOLDER/

RUN bash $SCRIPTS_FOLDER/build-meteor-bundle.sh

FROM node:14.20-alpine

ENV APP_BUNDLE_FOLDER /opt/bundle
ENV SCRIPTS_FOLDER /docker

RUN apk --no-cache add \
    bash \
    g++ \
    make \
    python3

COPY --from=0 $SCRIPTS_FOLDER $SCRIPTS_FOLDER/

COPY --from=0 $APP_BUNDLE_FOLDER/bundle $APP_BUNDLE_FOLDER/bundle/

RUN bash $SCRIPTS_FOLDER/build-meteor-npm-dependencies.sh --build-from-source

FROM node:14.20-alpine

ENV APP_BUNDLE_FOLDER /opt/bundle
ENV SCRIPTS_FOLDER /docker

RUN apk --no-cache add \
    bash \
    ca-certificates

COPY --from=1 $SCRIPTS_FOLDER $SCRIPTS_FOLDER/

COPY --from=1 $APP_BUNDLE_FOLDER/bundle $APP_BUNDLE_FOLDER/bundle/
COPY settings.json $APP_BUNDLE_FOLDER/bundle/settings.json


ENTRYPOINT ["/docker/entrypoint.sh"]

CMD ["node","--max-old-space-size=4096", "main.js"]

