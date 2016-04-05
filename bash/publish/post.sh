#!/bin/bash
if [ -z "$1" ] ; then
    echo use "$0 <update.xml>"
    exit
fi


source $(dirname ${BASH_SOURCE[0]})/functions.sh

target="$(getUrl)/pages/updates"

echo $target >&2


curl -i -s --insecure --user $user --header "Content-Type: application/xml" --header "Accept: application/xml" -X POST --data @$1 \
    ${target}

echo
xsltproc $(dirname ${BASH_SOURCE[0]})/get_url.xslt $1
echo
