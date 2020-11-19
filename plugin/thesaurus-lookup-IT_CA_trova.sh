#!/usr/bin/env bash

LOOKUPFILE=${HOME}/.vim/bundle/vim-online-thesaurus/plugin/IT_CA/lookup.txt

WORD=$1
WORD_NO_ACCENTS=`echo ${WORD} | iconv -f utf8 -t ascii//TRANSLIT`
WORD_LOWERCASE=${WORD_NO_ACCENTS,,}
grep -Ei "${WORD_LOWERCASE}" ${LOOKUPFILE} | cut -f3
