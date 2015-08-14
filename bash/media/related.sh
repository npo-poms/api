#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh

if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <MID> [<json/xml file with search form>]"
    echo "e.g.: "
    echo " $0 VPWON_1174494 $(dirname ${BASH_SOURCE[0]})/../../examples/media/example1.json | jsonformat"
    exit
fi


if [ -z "$MAX" ] ; then
    MAX=240
fi

parameters="max=$MAX" # make sure they are ordered!

# find the implementation of the post function in ../api-functions.sh
if [[ "$2" == "" ]] ; then
    get "api/media/$1/related" $parameters
else
    post "api/media/$1/related" $parameters $2
fi
