#!/usr/bin/env bash

#This does a search and returns all YEAR sortDate buckets
# Then it convert each individual bucktet to a search request, and performs _that_ search
# You should expect exactly one facet result in each individual search then.
# https://jira.vpro.nl/browse/NPA-183


SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../../api-functions.sh


sortDates=$(dirname ${SOURCE[0]})/../../../examples/pages/sortDates.xml
xslt=$(dirname ${SOURCE[0]})/buckets_to_search.xslt
xsltfilter=$(dirname ${SOURCE[0]})/filter_facets.xslt
tmpFile=tmp


if [ -z "$MAX" ] ; then
    MAX=2
fi


parameters="max=$MAX&profile=$2&properties=$PROPERTIES" # make sure they are ordered!



# find the implementation of the post function in ../api-functions.sh
post "api/pages" $parameters $sortDates | xsltproc --stringparam tempDir $tmpFile $xslt - > /dev/null

for i in `ls $tmpFile/*.xml`; do
    echo "##teamcity[testStarted name='$i' captureStandardOutput='true']"
    #count=`post "api/pages" $parameters $i | xsltproc $xsltfilter - | xmllint --format - | grep "<sortDates" | wc  -l | xargs`
    post "api/pages" $parameters $i | xsltproc $xsltfilter - | xmllint --format -
    echo $count
    if [ "$count" -gt "1" ] ; then
       echo "##teamcity[testFailed name='$i' message='Too many results from facet search $count' details='']"
    fi
done
rm -rf $tmpFile/*
