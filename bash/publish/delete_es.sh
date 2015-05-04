#!/bin/bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi

source $(dirname ${SOURCE[0]})/functions.sh


if [ -z "$1" -o -e "$1" ] ; then
    while read -r url; do
        target=$(getEsUrl)/apipages/page/$(rawurlencode "$url" )
        echo $target
        curl -i -s --insecure  -X DELETE   ${target}
    done < "${1:-/dev/stdin}"
else
    target=$(getEsUrl)/apipages/page/$(rawurlencode "$1" )
    curl -i -s --insecure  -X DELETE   ${target}
fi
