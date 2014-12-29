#!/usr/bin/env bash
#set -x

source $(dirname ${BASH_SOURCE[0]})/../creds.sh
source $(dirname ${BASH_SOURCE[0]})/../functions.sh

call="api/media/"
uri="/v1/$call"

# The npodate function can be found in ../functions.sh
npodate=$(npodate)
parameters=("max=2") # make sure they are ordered!
separator="&"

# The authenticateHeader function can be found in ../functions.sh
header=$(authenticateHeader "$npodate" "$uri" $parameters)
curl -s -H "Authorization: $header"  -H "Content-Type: application/json" -H "X-NPO-Date: $npodate" -H "Origin: $origin"  -X POST --data \@$1  "$baseUrl$call?${parameters}"
echo $!
