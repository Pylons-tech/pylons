From  starport/cli
COPY . /app
ENTRYPOINT [ "starport", "chain", "serve", "-p", "/app" ]