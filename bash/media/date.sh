#!/usr/bin/env bash
#set -x

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh

if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <MID> [<field>]"
    exit
fi


if [[ "$2" == "" ]] ; then
    field="lastModified"
else
    field=$2
fi



echo $1 $field
get "api/media/$1" | jsongrep -output VALUE $field  | $(dirname ${SOURCE[0]})/../../perl/ts
