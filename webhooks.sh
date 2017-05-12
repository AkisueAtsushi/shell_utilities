#!/bin/bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C
export LANG=C


_usage() {
  echo "Usage: $0 [-m message] [-c channel] [-i icon] [-n botname]" 1>&2
  exit 0
}

while getopts u:c:i:n:m: opts
do
  case $opts in
    u)
      readonly WEBHOOKURL=$OPTARG
      ;;
    c)
      CHANNEL=$OPTARG
      ;;
    i)
      EMOJI=$OPTARG
      ;;
    n)
      BOTNAME=$OPTARG
      ;;
    m)
      HEAD=$OPTARG"\n"
      ;;
    \?)
      _usage
      ;;
    esac
done

#reconfirm arguments
set +u
test -v ${WEBHOOKURL-} && _usage
set -u

#slack channel 
readonly CHANNEL=${CHANNEL:-"#general"}

#slack icon
readonly EMOJI=${EMOJI:-":ok:"}

#slack sender name
readonly BOTNAME=${BOTNAME:-"MyBot"}

#Headline for mesage
readonly HEAD=${HEAD:-""}

#storing message in tmp file
MESSAGEFILE=$(mktemp -t webhooksXXX)

trap "rm ${MESSAGEFILE}" 0

if [ -p /dev/stdin ] ; then
    #Convert linefeed code for slack
    cat - | tr '\n' '\\' | sed 's/\\/\\n/g'  > ${MESSAGEFILE}
else
    echo "nothing stdin"
    exit 1
fi

readonly MESSAGE='```'`cat ${MESSAGEFILE}`'```'

# json fromatting
payload="payload={
    \"channel\": \"${CHANNEL}\",
    \"username\": \"${BOTNAME}\",
    \"icon_emoji\": \"${EMOJI}\",
    \"text\": \"${HEAD}${MESSAGE}\"
}"

#Incoming WebHooks
curl -s -S -X POST --data-urlencode "${payload}" ${WEBHOOKURL} >/dev/null
