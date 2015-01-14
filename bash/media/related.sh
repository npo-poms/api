#!/usr/bin/env bash
#set -x

source $(dirname ${BASH_SOURCE[0]})/../creds.sh
source $(dirname ${BASH_SOURCE[0]})/../api-functions.sh

parameters=("max=2") # make sure they are ordered!

if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <MID> [<json file with search form>]"
    echo "e.g.: "
    echo " $0 VPWON_1174494 $(dirname ${BASH_SOURCE[0]})/../../examples/media/example1.json | jsonformat"
    exit
fi

# find the implementation of the post function in ../api-functions.sh
post "api/media/$1/related" $parameters $2
