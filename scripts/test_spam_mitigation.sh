#!/bin/bash

#deploy node
chmod +x scripts/test_node_deploy.sh
screen -dmS deploynode scripts/test_node_deploy.sh
#wait for node run
sleep 10
#spam mitigation
bash scripts/spam_mitigation.sh