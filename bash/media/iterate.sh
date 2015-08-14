#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [ -z "$1" ] ; then
    parameters=""
else
    parameters="max=$1"
fi


if [ ! -z "$2" ] ; then
    parameters="$parameters&profile=$2"
fi

if [ ! -z "$3" ] ; then
    parameters="max=$1&offset=$3&profile=$2"
fi

echo "Tempdir $tempdir" 1>&2
post "api/media/iterate" $parameters $1
