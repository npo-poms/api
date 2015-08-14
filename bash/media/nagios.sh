#!/usr/bin/env bash
#set -x

start=$(date '+%s')

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/../api-functions.sh

if [[ "$1" == ""  ]] ; then
    echo Usage:
    echo "[ENV=<prod|test|dev>] $0 <MID>"
    exit
fi


temp=$tempdir/ngout
# find the implementation of the post function in ../api-functions.sh
get "api/media/$1" > $temp
bytes=$(cat $temp | wc -c)
head=$(head -c 100 $temp)
rm -r $tempdir
if [ "$status" == "200" ] ; then
    end=$(date '+%s')
    diff=$(echo "$end - $start" | bc)

    if ! echo $head | grep -E -q '^{\"objectType\":\"program|segment|group\".*' ; then
        # See https://jira.vpro.nl/browse/NPA-225
        echo "NOT OK: HTTP/1.1 $status -  $bytes bytes in $diff seconds response time. Object doesn't have a correct objectType ($head) ($ENV)"
        exit 2;
    fi
    echo "OK: HTTP/1.1 $status OK -  $bytes bytes in $diff seconds response time ($ENV)"
    exit 0;
else
    echo "NOT OK: HTTP/1.1 $status -  $bytes bytes in $diff seconds response time ($ENV)"
    exit 2;
fi
