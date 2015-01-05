#!/usr/bin/env bash
#set -x

source $(dirname ${BASH_SOURCE[0]})/../creds.sh
source $(dirname ${BASH_SOURCE[0]})/../api-functions.sh

parameters=("profile=vpro")

echo "Tempdir $tempdir" 2>&1
post "api/media/iterate" $parameters $1
