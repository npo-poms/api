#!/bin/bash
SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi

source $(dirname ${SOURCE[0]})/functions.sh

#set -x

deleteIfNotInCouchdb() {
    url=$(rawurlencode $1)
    targetcouchdb=$(getCouchdbUrl)/apipages/$url
    targetes=$(getEsUrl)/apipages/page/$url
    status=`curl -s --insecure  -w %{http_code}   -X HEAD  ${targetcouchdb}`
    if [ "$status" = "404" ] ;then
        echo;echo "Need to delete $1 ($targetes)"
        curl -i  --insecure  -X DELETE   $targetes
    else
        echo "$1 ($targetcouchdb) is OK ($status)"
    fi
}



if [ -z "$1" -o -e "$1" ] ; then
    while read  url; do
        deleteIfNotInCouchdb $url
    done < "${1:-/dev/stdin}"
else
    deleteIfNotInCouchdb $1
fi
