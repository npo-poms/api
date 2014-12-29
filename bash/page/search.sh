#!/usr/bin/env bash
#set -x

source $(dirname ${BASH_SOURCE[0]})/../creds.sh
source $(dirname ${BASH_SOURCE[0]})/../api-functions.sh

parameters=("max=2") # make sure they are ordered!

# find the implementation of the post function in ../api-functions.sh
post "api/page" $parameters $1
