#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [ -z "$MAX" ] ; then
    MAX=240
fi

all=$(dirname ${SOURCE[0]})/../../examples/pages/all.json
offset=0

while true; do
    parameters="max=$MAX&offset=$offset&profile=$1"
    count=0
    for url in $(post "api/pages" $parameters $all | jsongrep -output VALUE items[*].result.url) ; do
        count=$((count + 1));
        status=$(curl  -X HEAD  -w "%{http_code}" $url  2>/dev/null)
        echo -e "$((offset+count))\t$status\t$url"
    done
    offset=$((offset+count))
    >&2 echo "offset" $offset
    if [ $count == 0 ] ; then
        break
    fi

done
