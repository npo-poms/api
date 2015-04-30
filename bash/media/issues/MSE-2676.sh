#!/usr/bin/env bash
IFS=' '
while read line; do
    read -ra split <<< "$line"
    filename=${split[0]}
    starttijd=${split[1]:11:19}
    midpart=${filename#restriction_}
    mid=${midpart:0:${#midpart}-12}
    api=`ENV=dev ../get_restriction.sh $mid PLUSVOD`
    read -ra apiparts <<< "$api"
    apistarttijd=${apiparts[1]:0:19}
    apilastmodified=${apiparts[4]:0:19}
    if [ "$starttijd" != "$apistarttijd" ] ; then
        echo $apistarttijd
        echo "NOTOK $mid $starttijd != $apistarttijd $apilastmodified"
    else
        echo "OK" $mid $apistarttijd $apilastmodified
    fi

done < $1
