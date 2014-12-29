#!/usr/bin/env bash

mkdir -p testresults
for i in `ls ../../examples/pages` ; do
    target=testresults/$i
    echo "$i -> $target"
    ./search.sh ../../examples/pages/$i | jsonformat > $target
done
