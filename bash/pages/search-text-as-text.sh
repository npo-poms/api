#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
tab=$'\t'


IFS=$'\n'
source $(dirname ${SOURCE[0]})/search-text.sh  \
    | jsongrep -sep "$tab" -record "items[*]" -output VALUE ".score,.result.title,.result.url,.result.sortDate" | \
    while read -r line; do
        (
            IFS=$tab
            arr=($line)
            echo -e ${arr[0]}'\t'${arr[1]}'\t'${arr[2]}'\t'`ts ${arr[3]}`
        )
    done
