#!/usr/bin/env bash
DEFINITIONS=IT_CA/definizioni.txt
awk -v RS='' "/${*}/" ${DEFINITIONS}
