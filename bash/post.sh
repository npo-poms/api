#!/bin/bash
if [ -z "$1" ] ; then
    echo use "$0 <update.xml>"
    exit
fi


source ./creds.sh

target="$rs/pages/updates"

echo $target >&2

curl -i -s --insecure --user $user --header "Content-Type: application/xml" --header "Accept: application/json" -X POST --data @$1 \
    ${target}
