#!/bin/sh
pylonscli keys add michael --keyring-backend=test <<< y
pylonscli keys add iain --keyring-backend=test <<< y
pylonscli keys add afti --keyring-backend=test <<< y
pylonscli keys add girish --keyring-backend=test <<< y
pylonscli keys add eugen --keyring-backend=test <<< y
pylonsd add-genesis-account $(pylonscli keys show michael -a --keyring-backend=test) 10000000pylon,10000000michaelcoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show iain -a --keyring-backend=test) 10000000pylon,10000000iaincoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show afti -a --keyring-backend=test) 10000000pylon,10000000afticoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show girish -a --keyring-backend=test) 10000000pylon,10000000girishcoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show eugen -a --keyring-backend=test) 10000000pylon,10000000eugencoin,10000000loudcoin,100000000stake
