#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [ -z "$MAX" ] ; then
    MAX=2
fi


parameters="max=$MAX&profile=$2&properties=$PROPERTIES" # make sure they are ordered!

if [[ "$1" != "" &&  ! -e $1 ]] ; then
    echo Usage:
    echo " $0 [<json file with search form>] [<profile>]"
    echo "e.g.: "
    echo " $0 $(dirname ${BASH_SOURCE[0]})/../../examples/pages/tags.json | jsonformat"
    exit
fi

# find the implementation of the post function in ../api-functions.sh
get "api/pages" $parameters $1
