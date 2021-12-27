

FROM  starport/cli
USER root
RUN apt-get install unzip -y
RUN set -x \
    ENVCONSUL_VERSION=${VERSION:-0.6.2} \
    ENVCONSUL_ZIP=envconsul.zip \
    ENVCONSUL_URL=${URL:-https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/${ENVCONSUL_ZIP}} \
    ENVCONSUL_USER=${USER:-envconsul} \
    ENVCONSUL_GROUP=${GROUP:-envconsul} \
    CONFIG_DIR=/etc/envconsul.d \
    DATA_DIR=/opt/envconsul/data \
    DOWNLOAD_DIR=/tmp 
RUN echo "Downloading envconsul ${ENVCONSUL_VERSION}"  
RUN curl --silent --output /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.12.1/envconsul_0.12.1_linux_amd64.zip
RUN echo "Installing envconsul" 
RUN unzip -o /tmp/envconsul.zip -d /usr/local/bin/ 

COPY . /app
USER root
EXPOSE $PORT

#ENTRYPOINT [ "starport", "chain", "serve", "-p", "/app" ]
#ENTRYPOINT [ "bash", "/app/deploy/run.sh"]

ENTRYPOINT ["/usr/local/bin/envconsul", "-prefix", "pylons", "startport", "chain", "serve"]