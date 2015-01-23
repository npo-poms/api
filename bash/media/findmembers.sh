#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../creds.sh
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <MID> [<json file with search form>]"
    echo "e.g.: "
    echo " $0 VPWON_1174494 $(dirname ${BASH_SOURCE[0]})/../../examples/media/example1.json | jsonformat"
    exit
fi

post "api/media/$1/members" "max=100" $2
