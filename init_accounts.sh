#!/bin/sh
pylonscli keys add michael <<< 11111111 --keyring-backend=test
pylonscli keys add iain <<< 11111111 --keyring-backend=test
pylonscli keys add afti <<< 11111111 --keyring-backend=test
pylonscli keys add girish <<< 11111111 --keyring-backend=test
pylonscli keys add eugen <<< 11111111 --keyring-backend=test
pylonsd add-genesis-account $(pylonscli keys show michael -a --keyring-backend=test) 10000000pylon,10000000michaelcoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show iain -a --keyring-backend=test) 10000000pylon,10000000iaincoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show afti -a --keyring-backend=test) 10000000pylon,10000000afticoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show girish -a --keyring-backend=test) 10000000pylon,10000000girishcoin,10000000loudcoin,100000000stake
pylonsd add-genesis-account $(pylonscli keys show eugen -a --keyring-backend=test) 10000000pylon,10000000eugencoin,10000000loudcoin,100000000stake
