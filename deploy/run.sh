#!/bin/bash
cd /app
mv /config/* ~/.pylons/config/
echo $privkey | apt-key --keyring /etc/apt/trusted.gpg.d/docker-apt-key.gpg add
starport chain serve