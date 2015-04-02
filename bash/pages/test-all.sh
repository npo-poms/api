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
    target=testresults/$form
    echo "$form -> $target"
    post "api/pages" $parameters ../../examples/pages/$form | $(formatter $target) > $target
done

#also embed entire media forms
mkdir -p testresults/media
mkdir -p testresults/forms
for mediaForm in `ls ../../examples/media` ; do
    if [[ "$mediaForm" == *.json ]] ; then
        target=testresults/media/$mediaForm
        echo "$mediaForm -> $target"
        pageForm=testresults/forms/$mediaForm
        echo " {\"mediaForm\" :" >  $pageForm
        cat ../../examples/media/$mediaForm >> $pageForm
        echo "}" >> $pageForm
        echo "Using $pageForm";
        post "api/pages" $parameters $pageForm | $(formatter $target)  > $target
    fi
done
