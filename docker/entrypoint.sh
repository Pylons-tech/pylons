#!/usr/bin/env bash

if [[ -n "${SEEDS}" ]]; then
  allseeds=""
  for i in $(echo $SEEDS | sed "s/,/ /g")
  do
      seedaddress="$(curl -s $i:26657/status |jq -r '.result.node_info.id')@$i:26656"
      if [[ -n "$allseeds" ]];then
        allseeds="$allseeds,$seedaddress"
      else
        allseeds="$seedaddress"
      fi
  done
  pylonsd start --home /root/.pylonsd  --p2p.persistent_peers $allseeds
else
  pylonsd start --home /root/.pylonsd
fi