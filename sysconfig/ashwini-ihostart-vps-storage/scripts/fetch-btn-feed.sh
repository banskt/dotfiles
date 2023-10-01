#!/usr/bin/env bash

source /home/banskt/.bashrc
micromamba activate py311
python local/apps/btn-automagic/fetch-btn-feed.py
echo "Fetched database from BTN"
micromamba deactivate
