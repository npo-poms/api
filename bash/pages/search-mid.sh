#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh


if [ -z "$MAX" ] ; then
    MAX=240
fi

parameters="max=$MAX&profile=$2" # make sure they are ordered!




if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo " $0 [<mid to search on>] [<profile>]"
    echo "e.g.: "
    echo " $0  POW_00939964 vpro | jsonformat"
    exit
fi


file=$tempdir/search-mid.xml

xsltproc  --stringparam text "$1" $(dirname ${SOURCE[0]})/set_mid.xslt $(dirname ${SOURCE[0]})/../../examples/pages/mediaIdSearch.xml > $file

if [ -z "$CONTENT_TYPE" ] ; then
    CONTENT_TYPE=application/json
fi

post "api/pages" $parameters $file
