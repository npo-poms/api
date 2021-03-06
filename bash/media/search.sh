#!/usr/bin/env bash
#set -x


SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh



if [ -z "$MAX" ] ; then
    MAX=240
fi


parameters="max=$MAX" # make sure they are ordered!
if [[ "$2" != "" ]] ; then
    parameters="max=$MAX&profile=$2"
fi

if [[ "$1" == "" ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <json file with search form> [<profile>]"
    echo "e.g.: "
    echo " $0 $(dirname ${SOURCE[0]})/../../examples/media/example1.json | jsonformat"
    exit
fi


if [[ ! -e "$1"  ]] ; then
    read -r -d '' search <<EOF
{
    "searches" : {
        "text" : "$1"
    }
}
EOF

else
    search=$1
fi



# find the implementation of the post function in ../api-functions.sh
post "api/media" $parameters "$search"
