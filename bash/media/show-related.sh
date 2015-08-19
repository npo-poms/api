#!/usr/bin/env bash
#set -x
DIR="${BASH_SOURCE%/*}"

$DIR/get.sh $1 | jsongrep -recordsep '  ' -output VALUE "mid,titles[0].value,titles[1].value"

echo -e "\nRelated:"

MAX=10 $DIR/related.sh $1 | jsongrep -output VALUE \
                                     -sep ' ' -recordsep $'\n'\
                                     -record "items.*" \
                                     "items.*.mid,items.*.objectType,items.*.titles[0].value,items.*.titles[1].value" \
    | sed -e 's/^/  /'
