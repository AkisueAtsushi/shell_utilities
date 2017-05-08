# shell_utilities
Any useful shell scripts for maintaining server

---

### ping_check.sh

it only contains "ping_check" function.  

Usage:  
	$1=destination IP   
	$2=the limit of retry(optional, default: 5)  
	$3=retry interval(optional, [smhd]option available, default: 10s)  

Example:

```
#!/bin/bash

DESTINATION_IP=192.168.0.1

. /Directory/to/your/ping_check.sh

#retry limit: 5times(default), retry interval: 10seconds(default)
ping_check $DESTINATION_IP

#retry limit: 10times, retry interval: 5seconds
ping_check $DESTINATION_IP 10 5s
```

Result:  
Success: Return empty.  
Failure: Output ERROR message to stderr.
