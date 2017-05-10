#!/bin/bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C
export LANG=C

#validation - number of arguments 
if [ $# -eq 0 ]; then
  cat <<EOF
    ping_check() is a tool for ...

    Usage:
      ping_check [destination IP] [the limit of retry(optional, default:5)] [retry interval((optional, [smhd]option available, default: 10s)]
EOF

  exit 0 
fi

#$1 IP validation
readonly DESTINATION_IP=$1
IP_CHECK=$(echo ${DESTINATION_IP} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")

if [ ! "${IP_CHECK}" ] ; then
  echo "[ERROR] $DESTINATION_IP is not IP Address." 1>&2
  exit 1
fi

#$2 Natural number validation
readonly RETRY_LIMIT=${2:-5}
expr ${RETRY_LIMIT} + 1 > /dev/null 2>&1
if [ $? -ge 2 -o $RETRY_LIMIT -lt 0 ]; then
  echo "$RETRY_LIMIT is not natural number." 1>&2
  exit 1
fi

#$3 sleep seconds
readonly SLEEP_TIME=${3:-"10s"}
 
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
