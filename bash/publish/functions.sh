

tempdir=$(mktemp -dt `basename $0.XXX`)

thislocation=$(dirname $BASH_SOURCE)
if [ -e $thislocation/../../../creds.sh ]; then
    source $thislocation/../../../creds.sh
elif [ -e $thislocation/../../creds.sh ]; then
    source $thislocation/../../creds.sh
else
    source $thislocation/creds.sh
fi


environments=("prod=http://publish.pages.omroep.nl/api" "test=http://publish-test.pages.omroep.nl/api" "dev=http://publish-dev.pages.omroep.nl/api" "localhost=http://localhost:8060/api")

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
