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


date() {
    gdate --rfc-822
}

authenticateHeader() {
    #$1: date $2: uri
    message="origin:$origin,x-npo-date:$1,uri:$2"
    #echo "$message\n"
    base64=`python -c "import hmac, hashlib,base64,sys; print base64.b64encode(hmac.new(b\"$secret\", msg=\"$message\", digestmod=hashlib.sha256).digest())"`
    echo "NPO $apiKey:$base64"
}
