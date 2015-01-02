tempdir=$(mktemp -dt "$0")

npodate() {
    gdate --rfc-822
}

authenticateHeader() {
    #$1: date $2: uri $3 parameters
    message="origin:$origin,x-npo-date:$1,uri:$2"
    for param in $3 ; do
        message="$message,${param//=/:}"
    done
    #note: $secret and $apiKey variables are coming from creds.sh, which should have been included
    # should be possible with openssl, but I can't get it working. This is in python
    base64=`python -c "import hmac, hashlib,base64,sys; print base64.b64encode(hmac.new(b\"$secret\", msg=\"$message\", digestmod=hashlib.sha256).digest())"`
    echo "NPO $apiKey:$base64"
}


post() {
    npodate=$(npodate)
    call=$1
    uri="/v1/$call"
    parameters=$2
    datafile=$3

    output=$tempdir/curloutput
    separator="&" # to join the parameters array correctly
    header=$(authenticateHeader "$npodate" "$uri" $parameters)
    status=$(curl  -sw "%{http_code}" -H "Authorization: $header"  -H "Content-Type: application/json" -H "X-NPO-Date: $npodate" -H "Origin: $origin"  -X POST --data \@$datafile  "$baseUrl$call?${parameters}" --output $output)
    if [ "$status" != "200" ] ; then
        echo "ERROR: $status, $baseUrl$call?${parameters} @$3"  1>&2
        echo "See $output" 1>&2
    fi
    cat $output

}
