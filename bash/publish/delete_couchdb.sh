#!/bin/bash
if [ -z "$1" ] ; then
    echo use "$0 <url>"
    exit
fi

source $(dirname ${BASH_SOURCE[0]})/functions.sh

target=$(getEsUrl)/apiages/$(rawurlencode "$1" )

echo $target >&2

curl -i -s --insecure  -X DELETE   ${target}
