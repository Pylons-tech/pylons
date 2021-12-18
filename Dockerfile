FROM  starport/cli
COPY . /app
USER root
EXPOSE $PORT

#ENTRYPOINT [ "starport", "chain", "serve", "-p", "/app" ]
ENTRYPOINT [ "bash", "/app/deploy/run.sh"]