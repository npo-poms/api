#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
DIR=$(dirname ${SOURCE[0]});


$DIR/get.sh $1 | jsongrep -recordsep '  ' -output VALUE "mid,titles[0].value,titles[1].value"
echo -e "\nRelated:"
MAX=10 $DIR/related.sh $1 | jsongrep -output VALUE -sep ' ' -recordsep $'\n' -record "items.*" "items.*.mid,items.*.objectType,items.*.titles[0].value,items.*.titles[1].value" | sed -e 's/^/  /'
