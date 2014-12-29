#!/usr/bin/env bash

mkdir -p testresults
for form in `ls ../../examples/pages` ; do
    target=testresults/$form
    echo "$form -> $target"
    ./search.sh ../../examples/pages/$form | jsonformat > $target
done


#also embed entire media forms
mkdir -p testresults/media
mkdir -p testresults/forms
for mediaForm in `ls ../../examples/media` ; do
    target=testresults/media/$mediaForm
    echo "$mediaForm -> $target"
    pageForm=testresults/forms/$mediaForm

    echo " {    \"mediaForm\" :" >  $pageForm
    cat ../../examples/media/$mediaForm >> $pageForm
    echo "}" >> $pageForm
    echo "Using $pageForm";
    ./search.sh $pageForm | jsonformat > $target
done
