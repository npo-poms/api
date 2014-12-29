#!/usr/bin/env bash

mkdir -p testresults
for i in `ls ../../examples/media` ; do
    target=testresults/$i
    echo "$i -> $target"
    ./search.sh ../../examples/media/$i | jsonformat > $target
done
