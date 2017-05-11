#!/bin/bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C
export LANG=C

_usage() {
  cat <<EOF
Usage:
  ${0##*/} [-d destination IP] [-n the limit of retry(optional, default:5)] [-t retry interval((optional, [smhd]option available, default: 10s)]
EOF

  exit 0 
}

while getopts :d:n:t: opts
do
  case $opts in
    d)
      readonly DESTINATION_IP=$OPTARG
 
      IP_CHECK=$(echo ${DESTINATION_IP} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$") || true
      if [ ! "${IP_CHECK}" ] ; then
        echo "[ERROR] $DESTINATION_IP is not IP Address." 1>&2
        exit 1
      fi
      ;;
    n)
      readonly RETRY_LIMIT=$OPTARG

      set +e
      expr ${RETRY_LIMIT} + 1 > /dev/null 2>&1
      if [ $? -ge 2 ]; then
        echo "$RETRY_LIMIT is not natural number." 1>&2
        exit 1
      elif [ ${RETRY_LIMIT} -le 0 ]; then
        echo "$RETRY_LIMIT is not natural number." 1>&2
        exit 1
      fi
      set -e
      ;;
    t)
      readonly SLEEP_TIME=$OPTARG
      ;;
    :|\?)
      _usage
      ;;
  esac
done

#reconfirm arguments
set +u
test -v ${DESTINATION_IP-} && _usage

test -v ${RETRY_LIMIT-} && readonly RETRY_LIMIT=5

test -v ${SLEEP_TIME-} && readonly SLEEP_TIME="10s"
set -u

retry_count=0
while :
do
  /bin/ping $DESTINATION_IP -c 1 > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    break
  else
    let retry_count++

    if [ $retry_count -eq $RETRY_LIMIT ]; then
      echo "ping did not reached to $DESTINATION_IP" | /root/util/webhooks.sh -m "ping failure" -i ":ng:"
      exit 1
    fi
  fi

  /bin/sleep $SLEEP_TIME
done
