#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh
cd $(dirname ${BASH_SOURCE[0]})

parameters="max=2" # make sure they are ordered!


mkdir -p testresults
for form in `ls ../../examples/pages` ; do
    if [[ $form = search-with-media** ]] ; then
        target=testresults/$form
        echo "$form -> $target"
        post "api/pages" $parameters ../../examples/pages/$form | $(formatter $target) | $(scorefilter $target) > $target
    fi
done
