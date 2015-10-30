#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh



if [[ "$1" == "" ]] ; then
    echo Usage:
    echo " $0 <url>"
    exit
fi

# find the implementation of the get function in ../api-functions.sh
get "api/pages/multiple" "ids=$1"
