#!/bin/bash
if [ -z "$1" ] ; then
    echo use "$0 <update.xml>"
    exit
fi


source $(dirname ${BASH_SOURCE[0]})/functions.sh

if [ -e "$1" ] ; then
    url=`xsltproc $(dirname ${BASH_SOURCE[0]})/get_url.xslt $1`
else
    url=$1
fi

target=$(getUrl)/pages/updates?url=$(rawurlencode "$url" )


echo $target >&2

curl -s --insecure --user $user --header "Content-Type: application/xml" --header "Accept: application/xml" -X GET    ${target}
