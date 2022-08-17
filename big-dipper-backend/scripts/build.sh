#!/bin/bash
pwd = $(pwd)
cd app
echo "Pre Builing node_modules production..."
meteor npm install
echo "Builing for production..."
meteor build output/ --architecture os.linux.x86_64 --server-only --allow-superuser
cd output/
tar -xvf *.tar.gz 
echo "Post Builing node_modules for production..."
cd bundle/program/server && npm install
cd $pwd