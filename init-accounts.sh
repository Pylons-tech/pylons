#!/bin/sh
pylonscli keys add michael <<< 11111111
pylonscli keys add iain <<< 11111111
pylonscli keys add afti <<< 11111111
pylonscli keys add girish <<< 11111111
pylonscli keys add eugen <<< 11111111
pylonsd add-genesis-account $(pylonscli keys show michael -a) 10000000pylon,10000000michaelcoin
pylonsd add-genesis-account $(pylonscli keys show iain -a) 10000000pylon,10000000iaincoin
pylonsd add-genesis-account $(pylonscli keys show afti -a) 10000000pylon,10000000afticoin
pylonsd add-genesis-account $(pylonscli keys show girish -a) 10000000pylon,10000000girishcoin
pylonsd add-genesis-account $(pylonscli keys show eugen -a) 10000000pylon,10000000eugencoin