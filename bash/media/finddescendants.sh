#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <MID> [<json file with search form>|profile]"
    echo "e.g.: "
    echo " $0 VPWON_1174494 $(dirname ${BASH_SOURCE[0]})/../../examples/media/example1.json | jsonformat"
    exit
fi

if [[ -z $MAX ]] ; then
    MAX=100
fi

file=$(dirname ${SOURCE[0]})/../../examples/media/empty.json
profile=
if  [ -e "$2" ] ; then
    file=$2
else
    profile=$2
fi

if [ ! -z "$3" ] ; then
    if  [ -e "$3" ] ; then
        file=$3
    else
        profile=$3
    fi
fi


parameters="max=$MAX&offset=0&profile=$profile"

post "api/media/$1/descendants" $parameters $file
