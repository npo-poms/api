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



value=$(get "api/media/$1" | jsongrep -output VALUE $field)

if [[ -z $value ]] ; then
    echo "$1 Field '$field' not found. Known fields are"
    get "api/media/$1" | jsongrep -output PATH '*'
    exit 1
else
    echo -n "$1 $field "
    $(dirname ${SOURCE[0]})/../../perl/ts $value
    exit 0
fi
