#!/usr/bin/env bash
#set -x
DIR="${BASH_SOURCE%/*}"

$DIR/get.sh $1 | jsongrep -ignoreArrays -recordsep '  ' -output VALUE "mid,titles.value"

echo -e "\nRelated:"

MAX=10 $DIR/related.sh $1 | jsongrep -output VALUE \
                                     -sep ' ' -recordsep $'\n'\
                                     -record "items.*" \
                                     "result.mid,.objectType,.titles[0].value,.broadcasters[0].id" \
    | sed -e 's/^/  /'
