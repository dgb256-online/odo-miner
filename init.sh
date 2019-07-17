#!/bin/bash

cd ~/odo-miner/src/pool/stratum/
screen -dmS stratum python stratum.py $STRATUM_HOST $STRATUM_PORT $STRATUM_USER $STRATUM_PASS $STRATUM_ARGS

cd ~/odo-miner/src/miner/ && ./mine_in_screen.sh

tail -f /dev/null
