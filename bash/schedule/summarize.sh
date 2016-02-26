#!/usr/bin/env bash
type=search
if [ ! -z $1 ] ; then
   type=$1
fi

if [ $type == "search" ] ; then
    pref=".result"
else
    pref=""
fi
jsongrep -output VALUE \
         -sep ' ' \
         -recordsep $'\n'\
         -record 'items.*' \
         "$pref.channel,$pref.start,$pref.midRef,$pref.media.objectType,$pref.media.titles[0].value,$pref.media.broadcasters[0].id" \
    | sed -e 's/^/  /'
