#!/bin/bash
export privkey=dklo39sidlw
cd /app
mv /config/* ~/.pylons/config/
(echo 12345678; echo 12345678) | pylonsd keys import validator_1 /vault/secrets/validator_1/privkey
starport chain serve