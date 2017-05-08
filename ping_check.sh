#!/bin/bash

ping_check() {

	#validation - number of arguments 
	if [ $# -lt 2 ]; then
		echo 'usage: $1=destination ip $2=the limit of retry $3=retry interval(second, optional, default: 10s)' 1>&2
		exit 1
	fi

	#$1 IP validation
	local TARGET_IP=$1
	IP_CHECK=$(echo ${TARGET_IP} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")

	if [ ! "${IP_CHECK}" ] ; then
    		echo "[ERROR] $TARGET_IP is not IP Address." 1>&2
    		exit 1
	fi

	#$2 Natural number validation
	expr ${2} + 1 > /dev/null 2>&1
	if [ $? -lt 2 -a $2 -gt 0 ] ; then
		local readonly RETRY_LIMIT=$2
	else
  		echo "$2 is not natural number." 1>&2
		exit 1
	fi

	#$3 sleep seconds 
	if [ -z $3 ]; then
		#default(second)
		local SLEEP_TIME=10
	else
		local SLEEP_TIME="$3"
	fi

	local RETRY_COUNT=0
	while :
	do
        	/bin/ping $TARGET_IP -c 1 > /dev/null 2>&1

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
