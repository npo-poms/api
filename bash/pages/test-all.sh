#!/usr/bin/env bash

cd $(dirname ${BASH_SOURCE[0]})
source ../creds.sh
source ../api-functions.sh

parameters="max=2" # make sure they are ordered!

mkdir -p testresults
for form in `ls ../../examples/pages` ; do
    target=testresults/$form
    echo "$form -> $target"
    post "api/pages" $parameters ../../examples/pages/$form | jsonformat > $target
done

#also embed entire media forms
mkdir -p testresults/media
mkdir -p testresults/forms
for mediaForm in `ls ../../examples/media` ; do
    target=testresults/media/$mediaForm
    echo "$mediaForm -> $target"
    pageForm=testresults/forms/$mediaForm

    echo " {\"mediaForm\" :" >  $pageForm
    cat ../../examples/media/$mediaForm >> $pageForm
    echo "}" >> $pageForm
    echo "Using $pageForm";
    post "api/pages" $parameters $pageForm | jsonformat > $target
done
