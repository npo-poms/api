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
    echo " $0 [<text to seach on>] [<profile>]"
    echo "e.g.: "
    echo " $0 'fotostudio de jong' | jsonformat"
    exit
fi

file=$tempdir/searchtext.xml

xsltproc  --stringparam text "$1" $(dirname ${SOURCE[0]})/set_text.xslt $(dirname ${SOURCE[0]})/../../examples/pages/textSearch.xml > $file

if [ -z "$CONTENT_TYPE" ] ; then
    CONTENT_TYPE=application/json
fi


post "api/pages" $parameters $file
