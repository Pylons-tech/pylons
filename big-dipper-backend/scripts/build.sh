#!/bin/bash
pwd = $(pwd)
cd app
echo "Pre Builing node_modules production..."
meteor npm install --allow-superuser
echo "Builing for production..."
meteor build ../output/ --architecture os.linux.x86_64 --server-only --allow-superuser
cd ../output
tar -xf *.tar.gz 
cd $pwd