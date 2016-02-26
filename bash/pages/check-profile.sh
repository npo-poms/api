#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [[ -z "$MAX" ]] ; then
    MAX=240
fi

all=$(dirname ${SOURCE[0]})/../../examples/pages/all.json
if [[ -z "$2" ]] ; then
    offset=0
else
    offset=$2
fi


while true; do
    parameters="max=$MAX&offset=$offset&profile=$1"
    count=0
    for url in $(post "api/pages" $parameters $all | jsongrep -output PATHANDVALUE items[*].result.url,items[*].result.images[*].url) ; do

        path=${url%=*}
        u=${url#*=}
        if [[ $path == *images* ]] ; then
            type="image_from:$lasturl"
        else
            count=$((count + 1));
            type=url
            lasturl=$u
        fi
        status=$(curl  -X HEAD  -w "%{http_code}" $u  2>/dev/null)
        echo -e "$((offset+count))\t$status\t$u\t$type"

    done
    offset=$((offset+count))
    >&2 echo "offset" $offset
    if [ $count == 0 ] ; then
        break
    fi

done
