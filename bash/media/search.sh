#!/usr/bin/env bash
#set -x

source ../creds.sh
source ../functions.sh

call="api/media/"
uri="/v1/$call"
npodate=$(date)
header=$(authenticateHeader "$npodate" "$uri")
curl -H "Authorization: $header"  -H "X-NPO-Date: $npodate" -H "Origin: $origin"  "$baseUrl$call" -X POST
echo $!
