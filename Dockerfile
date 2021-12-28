

FROM  starport/cli
USER root
COPY . /app
USER root
EXPOSE $PORT

ENTRYPOINT [ "bash", "/app/deploy/run.sh"]
