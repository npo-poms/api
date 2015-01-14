#!/usr/bin/env bash

cd $(dirname ${BASH_SOURCE[0]})
source ../creds.sh
source ../api-functions.sh

parameters=("max=2") # make sure they are ordered!

mkdir -p testresults
for i in `ls ../../examples/media` ; do
    target=testresults/$i
    echo "$i -> $target"
    post "api/media" $parameters ../../examples/media/$i | jsonformat > $target
done

#iterateparameters=("profile=human")
#post "api/media/iterate" $iterateparameters | jsonformat > testresults/iterate.json
