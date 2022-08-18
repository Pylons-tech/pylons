#!/bin/bash

KEY="test"
CHAINID="pylons-testnet-1"
KEYRING="test"
MONIKER="localtestnet"
KEYALGO="secp256k1"
LOGLEVEL="info"
TEST_ACCOUNT_1="test_account_1"
TEST_ACCOUNT_2="test_account_2"

# Create testing account address
echo "===> Create testing env"
pylonsd keys add $TEST_ACCOUNT_1 --keyring-backend $KEYRING
MY_TESTING_ACCOUNT_1=$(pylonsd keys show $TEST_ACCOUNT_1 -a --keyring-backend $KEYRING)

pylonsd keys add $TEST_ACCOUNT_2 --keyring-backend $KEYRING
MY_TESTING_ACCOUNT_2=$(pylonsd keys show $TEST_ACCOUNT_2 -a --keyring-backend $KEYRING)

# Send token to testing account
VALIDATOR=$(pylonsd keys show $KEY -a --keyring-backend $KEYRING)
pylonsd tx bank send $VALIDATOR $MY_TESTING_ACCOUNT_1 1000000000upylon --keyring-backend $KEYRING --yes
echo "===> Wait for setting up env"
sleep 5
#spam tx
echo "===> Begin test spam tx"

counter=1
while [ $counter -le 10 ]
do
    echo "=================$counter================="
    RES=$(pylonsd tx bank send $MY_TESTING_ACCOUNT_1 $MY_TESTING_ACCOUNT_2 1000000upylon --keyring-backend $KEYRING --yes)
    # get the return code
    RES_ARRAY=(${RES[@]})
    echo "${RES_ARRAY[0]} ${RES_ARRAY[1]}"
    ((counter++))
done




#query balances
#pylonsd query bank balances $MY_TESTING_ACCOUNT_1
