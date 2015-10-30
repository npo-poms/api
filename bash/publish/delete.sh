#!/bin/bash
if [ -z "$1" ] ; then
    echo use "$0 <url>"
    exit
fi

source $(dirname ${BASH_SOURCE[0]})/functions.sh

target=$(getUrl)/pages/updates?url=$(rawurlencode "$1" )

echo $target >&2

curl -i -s --insecure --user $user --header "Content-Type: application/xml" --header "Accept: application/xml" -X DELETE  \
    ${target}
