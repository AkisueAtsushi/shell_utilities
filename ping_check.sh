#!/bin/bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C
export LANG=C

ping_check() {

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
  local DESTINATION_IP=$1
  IP_CHECK=$(echo ${DESTINATION_IP} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")

  if [ ! "${IP_CHECK}" ] ; then
        echo "[ERROR] $DESTINATION_IP is not IP Address." 1>&2
        exit 1
  fi

  #$2 Natural number validation
  if [ -z $2 ]; then
    local readlonly RETRY_LIMIT=5
  else
    expr ${2} + 1 > /dev/null 2>&1
    local readonly RESULT=$?
    if [ $RESULT -lt 2 -a $2 -gt 0 ]; then
      local readonly RETRY_LIMIT=$2
    else
        echo "$2 is not natural number." 1>&2
      exit 1
    fi
  fi

  #$3 sleep seconds 
  if [ -z $3 ]; then
    #default(second)
    local SLEEP_TIME="10s"
  else
    local SLEEP_TIME="$3"
  fi

  local RETRY_COUNT=0
  while :
  do
          /bin/ping $DESTINATION_IP -c 1 > /dev/null 2>&1

          if [ $? -eq 0 ]; then
                  break
          else
                  let RETRY_COUNT++

                  if [ $RETRY_COUNT -eq $RETRY_LIMIT ]; then
                          echo "ping did not reached to $1" 1>&2
                          exit 1
                  fi
          fi

    /bin/sleep $SLEEP_TIME
  done
}
