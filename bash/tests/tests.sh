#!/usr/bin/env bash


SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi

ENV=dev source $(dirname ${SOURCE[0]})/pages/bucketsearches.sh
