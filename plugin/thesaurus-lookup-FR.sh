#!/usr/bin/env sh

# Vim plugin for looking up words in an online thesaurus
# Author:       Anton Beloglazov <http://beloglazov.info/>
# Version:      0.3.2
# Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

URL="https://www.dictionnaire-synonyme.com/synonyme-$(echo $1 | tr ' ' '-')"
MAX_WORDS=20

if [ "$(uname)" = "FreeBSD" ]; then
        PROGRAM="fetch"
        OPTIONS="-qo"
elif command -v curl > /dev/null; then
        PROGRAM="curl"
        OPTIONS='-sw "%{http_code}" -o'
elif command -v wget > /dev/null; then
        PROGRAM="wget"
        OPTIONS="-qO"
else
        echo "FreeBSD fetch, curl, or wget not found"
        exit 1
fi

if command -v mktemp > /dev/null; then
        OUTFILE="$(mktemp /tmp/XXXXXXX)"
else
        NEW_RAND="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12)"
        touch /tmp/$NEW_RAND
        OUTFILE="/tmp/$NEW_RAND"
fi

STATUS_CODE=$(eval "$PROGRAM" "$OPTIONS" "$OUTFILE" "$URL")

if [[ $STATUS_CODE =~ 2.. ]]; then
    printf "Richerche url: $URL\n"
    printf "Synonimes: "
    grep -Po '(href="/synonyme-).*?(?=">)' "$OUTFILE" | cut -d"-" -f2 | head -n $MAX_WORDS | tr '\n' ',' | sed 's/,/, /g;s/, $//'
    printf "\n"
    printf "Antonymes: "
    grep -Po '(href="/antonyme-).*?(?=">)' "$OUTFILE" | cut -d"-" -f2 | head -n $MAX_WORDS | tr '\n' ',' | sed 's/,/, /g;s/, $//'
    printf "\n"
else
    echo "mot \"${1}\" pas trouvé"
fi

rm "$OUTFILE"
