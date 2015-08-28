#!/usr/bin/env bash
#set -x


SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [[ -z "$2" ]] ; then
    parameters="guideDay=`date +'%Y-%m-%d'`&max=240&proeprties=scheduleEvents"
else
    parameters="guideDay=$2&max=240&properties=scheduleEvents"
fi


if [[ "$1" == "" ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <channel> [<guide day>]"
    echo "e.g.: "
    echo " $0 NED1 2015-08-28 | jsonformat"
    exit
fi


get "api/schedule/channel/$1" $parameters
