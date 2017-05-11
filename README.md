# shell_utilities
Any useful shell scripts for maintaining server

---

### ping_check.sh

Description:  
　To check ping status. try to ping to the destination IP until success or the limit comes.  
　once it gets successed, never try to ping again, before the limit comes.

Usage:  
  ping_check.sh [-d destination IP] [-n the limit of retry(optional, default:5)] [-t retry interval((optional, [smhd]option available, default: 10s)]  

Example:

```
#!/bin/bash

DESTINATION_IP=192.168.0.1

#retry limit: 5times(default), retry interval: 10seconds(default)
/Directory/to/your/ping_check.sh -d $DESTINATION_IP

#retry limit: 10times, retry interval: 5seconds
/Directory/to/your/ping_check.sh -d $DESTINATION_IP -n 10 -t 5s
```

Result:  
Success: Return empty.  
Failure: Output ERROR message to stderr.
