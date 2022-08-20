#!/bin/bash

echo "Builing node_modules production..."
cd app/bundle/programs/server
npm install
cd ../..
