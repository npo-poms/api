#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
dir=$(dirname ${SOURCE[0]})
source $dir/../api-functions.sh

if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <MID>"
    exit
fi

platform=PLUSVOD


# find the implementation of the post function in ../api-functions.sh
CONTENT_TYPE='application/xml' get "api/media/$1" | xsltproc --stringparam platform "${platform}" $dir/get_restriction.xslt -
