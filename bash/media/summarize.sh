#!/usr/bin/env bash
jsongrep -output VALUE \
         -sep ' ' \
         -recordsep $'\n'\
         -record 'items.*' \
         ".result.mid,.result.objectType,.result.titles[0].value,.result.broadcasters[0].id,.score" \
    | sed -e 's/^/  /'
