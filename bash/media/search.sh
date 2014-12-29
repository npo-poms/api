#!/usr/bin/env bash
#set -x

source ../creds.sh
source ../functions.sh

call="api/media/"
uri="/v1/$call"
npodate=$(date)
parameters=("max=2")
separator="&"
header=$(authenticateHeader "$npodate" "$uri" $parameters)
curl -s -H "Authorization: $header"  -H "Content-Type: application/json" -H "X-NPO-Date: $npodate" -H "Origin: $origin"  -X POST --data \@$1  "$baseUrl$call?${parameters}"
echo $!
