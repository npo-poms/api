#!/usr/bin/env bash


SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
if [ -z "$ENV" ] ; then
    ENV=dev
fi
source $(dirname ${SOURCE[0]})/pages/bucketsearches.sh
