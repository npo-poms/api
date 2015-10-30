#!/bin/bash
if [ -z "$1" ] ; then
    echo use "$0 <url>"
    exit
fi


status=$(curl  -X HEAD  -w "%{http_code}" $1  2>/dev/null)


if [[ "$status" == "404" ]] ; then
    source $(dirname ${BASH_SOURCE[0]})/functions.sh
    target=$(getUrl)/pages/updates?url=$(rawurlencode "$1" )
    curl -i -s --insecure --user $user --header "Content-Type: application/xml" --header "Accept: application/xml" -X DELETE  \
         ${target}
else
    echo "$1 is $status"
fi
