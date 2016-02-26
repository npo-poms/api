#!/usr/bin/env bash

cd $(dirname ${BASH_SOURCE[0]})
source ../api-functions.sh

parameters=("max=2") # make sure they are ordered!

mkdir -p testresults
for i in `ls ../../examples/media` ; do
    target=testresults/$i
    echo "$i -> $target"
    if [ ${i%.xml} == $i ] ; then
        post "api/media" $parameters ../../examples/media/$i | jsonformat > $target
    else
        post "api/media" $parameters ../../examples/media/$i | xmllint -format -  > $target
    fi
done

#iterateparameters=("profile=human")
#post "api/media/iterate" $iterateparameters | jsonformat > testresults/iterate.json
