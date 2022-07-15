---
title: "Getting Started"
date: 2022-04-26T12:58:40-05:00
draft: false
---

[A] GIT CLONE



[1] git clone repository

[with ssh]

% git clone git@github.com:Pylons-tech/big-dipper.git

OR

[with https]

% git clone https://github.com/Pylons-tech/big-dipper.git 



[2] Copy settings.json

% cd big-dipper

% git checkout staging

% git branch [check staging branch]

% cp default_settings.json settings.json





[B] REQUIREMENTS 



[3] Install METEOR

% curl https://install.meteor.com/ | sh



[4] Check meteor node version

% meteor node -v

v14.19.1 [example]



[5] Install NVM 

[macOS]

% brew update

% brew install nvm

% nvm ls [check nvm versions]

[linux]

% curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

OR

% wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

% nvm ls [check nvm versions]



[6] Install node 14 

% nvm install 14

% nvm use 14

% node -v

v14.19.1 [example]

% meteor node -v

v14.19.1 [example]



[7] MongoDB install

1. Install MongoDB Atlas [Cloud]

https://www.mongodb.com/ 

   OR

   Install MongoDB Community Edition [Local]

   [macOS]

https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/ 

   [linux]

https://www.mongodb.com/docs/manual/administration/install-on-linux/ 



2. Export MONGO_URL

[MongoDB Community Edition: example]

% export MONGO_URL=mongodb://127.0.0.1:27017/big-dipper-v1

OR

% export MONGO_URL=mongodb://localhost:27017/big-dipper-v1



3. Run MongoDB

[macOS intel processor]

% mongod --config /usr/local/etc/mongod.conf --fork



4. Test MongoDB

% mongo $MONGO_URL





[C] Run in local



[8] Update settings.json [no need to change if default_settings.json is copied unless there is a problem]

1. update the RPC and API URLs

2. update Bech32 address prefixes

3. add coins settings

4. update ledger settings



[9] Run in command-line

% meteor npm install --save

% meteor --settings settings.json



[10] Run in docker-compose 

1. Modify docker-compose.yml

MONGO_URL: mongodb://mongo:27017/big-dipper-v1

2. Run following

% METEOR_SETTINGS=$(cat settings.json) docker-compose up





[D] Run in production



[11] Run build.sh

% ./scripts/build.sh

% cd ../output

% tar -xvf big-dipper.tar.gz   

% cd bundle

% cd programs 

% cd server

% npm install 

% npm remove fibers

% npm install fibers

% cd ../../../bundle

% cp ../../big-dipper/settings.json .

% PORT=3018 ROOT_URL=http://localhost/ MONGO_URL=mongodb://127.0.0.1:27017/big-dipper-v1 METEOR_SETTINGS="$(cat settings.json)" meteor node main.js