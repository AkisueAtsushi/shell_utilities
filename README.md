# shell_utilities
Any useful shell scripts for maintaining server

---

### webhooks.sh

Description:  
　To post message on slack.

Usage:  
　webhooks.sh [-u webhook url] [-m head for message] [-c channel] [-i icon] [-n botname]  

Option:  
　-u Your slack webhook url *\*required\**  
　-m message header (option)  
　-c channel which is posted the message (default: #general)  
　-i icon(default: :ok:)  
　-n Bot Name(default: MyBot)  
 
Example:

```
#!/bin/bash

WEBHOOKS="YOUR SLACK WEBHOOK URL"

#Post message at #general on your slack, Name is "MyBot", Icon is ":ok:", No message header
echo "Test" | /Directory/to/your/webhooks.sh -u ${WEBHOOKS}

#To notify your cronjob result
echo "Success" | /Directory/to/your/webhooks.sh -u ${WEBHOOKS} -m "my cron job" -i ":ok:" -c "#specific-channel" -n "cronjob" 
```
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
