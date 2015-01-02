tempdir=$(mktemp -dt "$0")

npodate() {
    gdate --rfc-822
}

authenticateHeader() {
    #$1: date $2: call $3 parameters
    message="origin:$origin,x-npo-date:$1,uri:/v1/$2"
    for param in $3 ; do
        message="$message,${param//=/:}"
    done
    #note: $secret and $apiKey variables are coming from creds.sh, which should have been included
    # should be possible with openssl, but I can't get it working. This is in python
    base64=`python -c "import hmac, hashlib,base64,sys; print base64.b64encode(hmac.new(b\"$secret\", msg=\"$message\", digestmod=hashlib.sha256).digest())"`
    echo "NPO $apiKey:$base64"
}


post() {
    call=$1       # e.g. api/pages
    parameters=$2 # an array of <param>=<value>
    datafile=$3   # a file containing the form to post (in json)

    npodate=$(npodate) # call this method

    output=$tempdir/curloutput
    separator="&" # to join the parameters array correctly
    header=$(authenticateHeader "$npodate" $call $parameters)

    # now we call curl
    # We let the http_code come on stdout and the output itself is stored to a tempory file (which is afterwards returned with cat).
    #
    # We set the headers as specified
    # and post a file  in json
    status=$(\
        curl \
        `# these two option just take arrange curl's output as we want it`\
        -sw "%{http_code}"  \
        --output $output \
        `# authentication related headers` \
        -H "Authorization: $header" \
        -H "X-NPO-Date: $npodate" \
        -H "Origin: $origin"  \
        `# post file in json` \
        -H "Content-Type: application/json" \
        -X POST --data \@$datafile  \
        `#url` \
        "$baseUrl$call?${parameters}" \
        )
    if [ "$status" != "200" ] ; then
        echo "ERROR: $status, $baseUrl$call?${parameters} @$3"  1>&2
        echo "See $output" 1>&2
    fi
    cat $output
    if [ "$status" == "200" ] ; then
        rm $output
    fi

}
