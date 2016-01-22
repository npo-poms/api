#!/usr/bin/env bash
jsongrep -output VALUE \
         -sep ' ' \
         -recordsep $'\n'\
         -record 'items.*' \
         ".result.channel,.result.start,.result.midRef,.result.media.objectType,.result.media.titles[0].value,.result.media.broadcasters[0].id" \
    | sed -e 's/^/  /'
