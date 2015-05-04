

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
esenvironments=("prod=http://localhost:9208" "test=http://localhost:9207" "dev=http://localhost:9206" "localhost=http://localhost:9200")
couchdbenvironments=("prod=http://docs.pages.omroep.nl" "test=http://docs-test.pages.omroep.nl" "dev=http://docs-dev.pages.omroep.nl" "localhost=http://127.0.0.1:5984")

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



getEsUrl() {
    if [ ! -z "$ENV" ] ; then
        for env  in "${esenvironments[@]}" ; do
            if [ ${env%%=*} == $ENV ] ; then
                echo "${env##*=}"
                return
            fi
        done
        echo "Not recognized $ENV. Use one of ${esenvironments[@]}" 1>&2
        kill -s TERM $TOP_PID
    fi
    ENV=prod getEsUrl
    return
}

getCouchdbUrl() {
    if [ ! -z "$ENV" ] ; then
        for env  in "${couchdbenvironments[@]}" ; do
            if [ ${env%%=*} == $ENV ] ; then
                echo "${env##*=}"
                return
            fi
        done
        echo "Not recognized $ENV. Use one of ${couchdbenvironments[@]}" 1>&2
        kill -s TERM $TOP_PID
    fi
    ENV=prod getCouchdbUrl
    return
}

rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}
