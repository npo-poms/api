#!/usr/bin/env bash
#set -x

# example useage:  ENV=prod ./iterate.sh 1000000 woord | tee woord5.json | jsongrep "mediaobjects.*.mid"

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh

function useage() {
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 [<max number of results> [<profile>]"
    echo "e.g.: "
    echo " $0  100000000 vpro | jsongrep -output FULLVALUE -recordsep $'\n\n' -record items.*.result items.*.result.mid,items.*.result.objectType,items.*.result.locations.*.programUrl,items.*.result.locations.*.platform | tee /tmp/vpro.txt"
    exit
}


if [ -z "$1" ] ; then
    parameters="max=100"
else
    if [[ $1 =~ ^-?[0-9]+$ ]] ; then
        parameters="max=$1"
    else
        useage
    fi
fi


if [ ! -z "$2" ] ; then
    parameters="$parameters&profile=$2"
fi

if [ ! -z "$3" ] ; then
    parameters="max=$1&offset=$3&profile=$2"
fi

post "api/media/iterate" $parameters $(dirname ${SOURCE[0]})/../../examples/media/empty.json

dumpHeaders 1>&2
