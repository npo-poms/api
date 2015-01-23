
# external program used, make sure they are in your path
GDATE=gdate
PYTHON=python
CURL=curl
CAT=cat

tempdir=$(mktemp -dt `basename $0.xxx`)

environments=("prod=http://rs.poms.omroep.nl/v1/" "test=http://rs-test.poms.omroep.nl/v1/" "dev=http://rs-dev.poms.omroep.nl/v1/" "localhost=http://localhost:8070/v1/")

if [ "$DEBUG" = 'true' ]  ; then
    # Use DEBUG=true as prefix to toggle this
    set -x
fi

trap "exit 1" TERM
export TOP_PID=$$


getUrl() {
    if [ ! -z "$ENV" ] ; then
        for env  in "${environments[@]}" ; do
            if [ ${env%%=*} == $ENV ] ; then
                echo "${env##*=}"
                return
            fi
        done
        echo "Not recognized $ENV. Use one of ${environments[@]}" 1>&2
        kill -s TERM $TOP_PID
    fi
    if [ -z "$baseUrl"] ; then
        ENV=prod getUrl
    else
        echo $baseUrl
    fi
    return
}

authenticateHeader() {
    #$1: date $2: call $3 parameters
    message="origin:$origin,x-npo-date:$1,uri:/v1/$2"
    IFS='&' read -ra ADDR <<< "$3"
    for param in "${ADDR[@]}" ; do
        message="$message,${param//=/:}"
    done
    #note: $secret and $apiKey variables are coming from creds.sh, which should have been included
    # should be possible with openssl, but I can't get it working. This is in python
    base64=`$PYTHON -c "import hmac,hashlib,base64;\
                        print base64.b64encode(hmac.new(b\"$secret\", msg=\"$message\", digestmod=hashlib.sha256).digest())"`
    echo "NPO $apiKey:$base64"
}


post() {
    call=$1       # e.g. api/pages
    parameters=$2 # an <param>=<value>[&<param=value]
    datafile=$3   # a file containing the form to post (in json)

    npodate=$($GDATE --rfc-822)

    output=$tempdir/curloutput
    separator="&" # to join the parameters array correctly
    header=$(authenticateHeader "$npodate" $call $parameters)
    url=$(getUrl)

    #echo "Writing to $output" 1>&2
    # now we call curl
    # We let the http_code come on stdout and the output itself is stored to a tempory file (which is afterwards returned with cat).
    #
    # We set the headers as specified
    # and post a file  in json
    status=$(\
        $CURL \
        `# these two option just take arrange curl's output as we want it`\
        -sw "%{http_code}"  \
        --output $output \
        `# authentication related headers` \
        -H "Authorization: $header" \
        -H "X-NPO-Date: $npodate" \
        -H "Origin: $origin"  \
        `# post file in json` \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -X POST --data \@$datafile  \
        \
        "$url$call?${parameters}" \
        )
    if [ "$status" != "200" ] ; then
        echo "ERROR: $status, $baseUrl$call?${parameters} @$3"  1>&2
        echo "See $output" 1>&2
    fi
    $CAT $output
    if [ "$status" == "200" ] ; then
        rm $output
    fi

}



get() {
    call=$1       # e.g. api/pages
    parameters=$2 # an array of <param>=<value>

    npodate=$($GDATE --rfc-822)

    output=$tempdir/curloutput
    separator="&" # to join the parameters array correctly
    header=$(authenticateHeader "$npodate" $call $parameters)
    url=$(getUrl)

    #echo "Writing to $output" 1>&2
    # now we call curl
    # We let the http_code come on stdout and the output itself is stored to a tempory file (which is afterwards returned with cat).
    #
    # We set the headers as specified
    # and post a file  in json
    status=$(\
        $CURL \
        `# these two option just take arrange curl's output as we want it`\
        -sw "%{http_code}"  \
        --output $output \
        `# authentication related headers` \
        -H "Authorization: $header" \
        -H "X-NPO-Date: $npodate" \
        -H "Origin: $origin"  \
        `# post file in json` \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -X GET  \
        \
        "$url$call?${parameters}" \
        )
    if [ "$status" != "200" ] ; then
        echo "ERROR: $status, $baseUrl$call?${parameters} @$3"  1>&2
        echo "See $output" 1>&2
    fi
    $CAT $output
    if [ "$status" == "200" ] ; then
        rm $output
    fi

}
