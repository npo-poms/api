#!/usr/bin/env bash
while read line; do
    IFS=' '
    read -ra split <<< "$line"
    filename=${split[0]}
    starttijd=${split[1]:11:19}
    IFS=' '
    midpart=${filename#restriction_}
    mid=${midpart:0:${#midpart}-12}
    api=`ENV=dev ./get_restriction.sh $mid PLUSVOD`
    read -ra apiparts <<< "$api"
    apistarttijd=${apiparts[1]:0:19}
    if [ "$starttijd" != "$apistarttijd" ] ; then
        echo "NOTOK" $mid $starttijd $apistarttijd
    else
        echo "OK" $mid $starttijd $apistarttijd
    fi

done < $1
