#!/usr/bin/env bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../creds.sh
source $(dirname ${SOURCE[0]})/../api-functions.sh


sortDates=$(dirname ${SOURCE[0]})/../../examples/pages/sortDates.xml
xslt=$(dirname ${SOURCE[0]})/buckets_to_search.xslt
xsltfilter=$(dirname ${SOURCE[0]})/filter_facets.xslt
tmpFile=tmp


if [ -z "$MAX" ] ; then
    MAX=2
fi


parameters="max=$MAX&profile=$2&properties=$PROPERTIES" # make sure they are ordered!



# find the implementation of the post function in ../api-functions.sh
post "api/pages" $parameters $sortDates | xsltproc --stringparam tempDir $tmpFile $xslt -

for i in `ls $tmpFile/*.xml`; do
    post "api/pages" $parameters $i | xsltproc $xsltfilter - | xmllint --format -
done
