#!/bin/bash
if [ -z "$1" ] ; then
    echo use "$0 <url>"
    exit
fi


source ./creds.sh
source ./functions.sh

target=$rs/pages/updates/$(rawurlencode "$1" )

echo $target >&2

curl -i -s --insecure --user $user --header "Content-Type: application/xml" --header "Accept: application/xml" -X DELETE  \
    ${target}
