#!/usr/bin/env bash
#set -x

source $(dirname ${BASH_SOURCE[0]})/../creds.sh
source $(dirname ${BASH_SOURCE[0]})/../api-functions.sh



# find the implementation of the post function in ../api-functions.sh
get "api/media/$1"
