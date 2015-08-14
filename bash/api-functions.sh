
# external program used, make sure they are in your path
PYTHON=python
CURL=curl
CAT=cat

tempdir=$(mktemp -dt `basename $0.XXX`)

thislocation=$(dirname $BASH_SOURCE)
if [ -e $thislocation/../../creds.sh ]; then
    source $thislocation/../../creds.sh
else
    source $thislocation/creds.sh
fi

if [ -z "$localhost" ] ; then
    localhost="http://localhost:8070/v1/"
fi


environments=("prod=http://rs.poms.omroep.nl/v1/" "test=http://rs-test.poms.omroep.nl/v1/" "dev=http://rs-dev.poms.omroep.nl/v1/" "localhost=$localhost")

if [ "$DEBUG" = 'true' ]  ; then
    # Use DEBUG=true as prefix to toggle this
    set -x
fi

trap "exit 1" TERM
export TOP_PID=$$
status=""


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

formatter() {
    file=$1

    if [[ "$file" == *.xml ]] ; then
        echo "xmllint -format -"
    elif [[ "$file" == *.json ]] ; then
        echo "jsonformat"
    else
        echo "cat"
    fi
}


scorefilter() {
    file=$1

    if [[ "$file" == *.xml ]] ; then
        echo "cat" # TODO
    elif [[ "$file" == *.json ]] ; then
        echo "grep -v score"
    else
        echo "cat"
    fi
}

post() {
    call=$1       # e.g. api/pages
    parameters=$2 # an <param>=<value>[&<param=value]
    datafile=$3   # a file containing the form to post (in json or xml)

    # RFC 822 date, but not all implementations of 'date' support the '--rfc-822' option.
    npodate=$(LANG=C date "+%a, %d %b %Y %H:%M:%S %z")

    output=$tempdir/curloutput
    separator="&" # to join the parameters array correctly
    header=$(authenticateHeader "$npodate" $call $parameters)
    url=$(getUrl)


    if [[ ! -e $datafile ]] ; then
        echo "The file $datafile does not exist"
        exit 1
    fi

    if [ ${datafile%.xml} != $datafile ] ; then
        accept="application/xml"
        contentType="application/xml"
    else
        accept="application/json"
        contentType="application/json"
    fi
    #accept="application/xml"


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
        -H "Content-Type: $contentType" \
        -H "Accept: $accept" \
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
    else
        kill -s TERM $TOP_PID
    fi

}



get() {
    call=$1       # e.g. api/pages
    parameters=$2 # an array of <param>=<value>

    # RFC 822 date, but not all implementations of 'date' support the '--rfc-822' option.
    npodate=$(LANG=C date "+%a, %d %b %Y %H:%M:%S %z")

    output=$tempdir/curloutput
    separator="&" # to join the parameters array correctly
    header=$(authenticateHeader "$npodate" $call $parameters)
    url=$(getUrl)

    contentType="$CONTENT_TYPE"
    if [ -z "$contentType" ] ; then
        contentType="application/json"
    fi


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
        -H "Content-Type: $contentType" \
        -H "Accept: $contentType" \
        -X GET  \
        \
        "$url$call?${parameters}" \
          )
    if [ "$status" == "500" ] ; then
        echo "ERROR: $status, $baseUrl$call?${parameters} @$3"  1>&2
        cat $output 1>&2
    elif [ "$status" != "200" ] ; then
        echo "ERROR: $status, $baseUrl$call?${parameters} @$3"  1>&2
        echo "See $output" 1>&2
    fi
    $CAT $output
    if [ "$status" == "200" ] ; then
        rm $output
        exitcode=0
    else
        exitcode=$status
    fi
}
