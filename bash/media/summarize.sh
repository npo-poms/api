#!/usr/bin/env bash
jsongrep -output VALUE \
         -sep $'\t' \
         -recordsep $'\n'\
         -record 'items.*' \
         ".result.mid,.result.objectType,.result.titles[0].value,.result.broadcasters[0].id,.result.scheduleEvents[0].channel,.result.scheduleEvents[0].start,.score" \
    | perl -lan -F'\t' -e 'use DateTime; print "$F[0]\t$F[1]\t$F[2]\t$F[3]\t($F[4]\t".DateTime->from_epoch(epoch=>$F[5] / 1000).")\t$F[6]"'
