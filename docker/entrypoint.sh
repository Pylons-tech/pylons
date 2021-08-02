#!/usr/bin/env bash

allseeds=""
for i in $(echo $PEERS | sed "s/,/ /g")
do
    seedaddress="$(curl -s $i:26657/status |jq -r '.result.node_info.id')@$i:26656"
    if [[ -n "$allseeds" ]];then
      allseeds="$allseeds,$seedaddress"
    else
      allseeds="$seedaddress"
    fi
done


if [[ -z "$allseeds" ]];then
  echo "no seeds"
  pylonsd start --home /root/.pylonsd/
else
  echo "seeds: $allseeds"
  pylonsd start --home /root/.pylonsd/  --p2p.persistent_peers $allseeds
fi
