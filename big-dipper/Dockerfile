FROM geoffreybooth/meteor-base:2.7.3

COPY . app/

RUN bash app/scripts/build.sh

FROM node:14.19.3-alpine

RUN apk --no-cache add \
    bash \
    g++ \
    make 


COPY --from=0 output/bundle app/bundle/
COPY --from=0 app/scripts app/scripts

RUN bash app/scripts/post_build.sh

CMD ["node","--max-old-space-size=4096", "app/bundle/main.js"]

