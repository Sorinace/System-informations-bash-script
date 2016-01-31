#!/bin/sh
# Author: Sorin Aram
# Date: 25/01/2016

# the file name for saving
FILE="system.txt"

HOST=$(hostname -s)

IP=$(hostname --ip-address)

SERVER_N=$(cat /etc/apache2/apache2.conf | grep ServerName | grep -v '#' | awk '{print $2}')

SERVER_A=$(cat /etc/apache2/apache2.conf | grep ServerAlias | grep -v '#' | awk '{print $1, "\t", $2}')

M_TOTAL=$(less /proc/meminfo | grep MemTotal: | awk '{print $2/1024/1024}')
M_FREE=$(less /proc/meminfo | grep MemFree: | awk '{print $2/1024/1024}')
M_USED=$(less /proc/meminfo | grep Active: | awk '{print $2/1024/1024}')
M_SWAP=$(less /proc/meminfo | grep SwapTotal: | awk '{print $2/1024/1024}')
M="MB"

DISK=$(df -k / | tail -1 | awk '{print $3/1024}')

VERSION=$(uname -a | awk '{print $3}')

PORTS=$(netstat -vatn | awk '$6 == "LISTEN"'| awk '{print $1, "\t", $4}')

STATUS_R=$(service --status-all | awk '$2 == "+"'| awk '{print $4, "\t", "running"}')
STATUS_S=$(service --status-all | awk '$2 == "-"'| awk '{print $4, "\t", "stopped"}')

#in SE you can put the service you want to check the status
SE='httpd'
 
if ps ax | grep -v grep | grep $SE > /dev/null
then
    SERVICE=$(echo "$SE  running")
else
    SERVICE=$(echo "$SE  stopped")
fi

MEM=$(ps axo rss,comm,pid \
| awk '{ proc_list[$2]++; proc_list[$2 "," 1] += $1; } \
END { for (proc in proc_list) { printf("%d\t%s\n", \
proc_list[proc "," 1],proc); }}' | sort -n | tail -n 10 | sort -rn \
| awk '{$1/=1024;printf "%s\t%.0f MB\n",$2,$1}')

/bin/cat <<EOM >$FILE
Hostname  $HOST
IP  $IP
ServerName  $SERVER_N
$SERVER_A
Memory
Total $M_TOTAL $M
Free  $M_FREE $M
Used  $M_USED $M
Swap  $M_SWAP $M
Disk Space Used $DISK $M
OS Version  $VERSION
Listening ports
$PORTS
Service status
$STATUS_R
$STATUS_S
Service status
$SERVICE
Memory in use by a runing application/service
$MEM
EOM
