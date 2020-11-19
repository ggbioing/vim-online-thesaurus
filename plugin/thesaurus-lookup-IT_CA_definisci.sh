#!/usr/bin/env bash
DEFINITIONS=${HOME}/.vim/bundle/vim-online-thesaurus/plugin/IT_CA/definizioni.txt
awk -v RS='' "/${*}/" ${DEFINITIONS}
