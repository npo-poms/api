#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [ -z "$1" ] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <max> [<profile>] [<since>] [ASC|DESC]"
    exit
fi


if [ -z "$4" ] ; then
    order=ASC
else
    order=$4
fi

if [ -z "$3" ] ; then
    parameters="max=$1&order=$order&profile=$2"
else
    parameters="max=$1&order=$order&profile=$2&since=$3"
fi




echo "Tempdir $tempdir" 1>&2
get "api/media/changes" $parameters
