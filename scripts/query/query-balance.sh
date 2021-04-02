#!/bin/bash

pylonsd query bank balances $(pylonsd keys show -a node0 --keyring-backend=test --home=$HOME/.pylonsd)