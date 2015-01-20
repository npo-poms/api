#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../creds.sh
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [ -z "$2" ] ; then
    parameters="max=$1"
else
    parameters="profile=$2&max=$1"
fi

echo "Tempdir $tempdir" 2>&1
get "api/media/changes" $parameters
