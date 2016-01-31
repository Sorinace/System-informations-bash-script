#!/bin/sh
# Author: Sorin Aram
# Date: 25/01/2016

# the file name for saving
FILE="system.txt"

HOST=$(hostname -s)

IP=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')

SERVER_N=$(cat /etc/apache2/httpd.conf | grep ServerName | grep -v '#' | awk '{print $2}')

SERVER_A=$(cat /etc/apache2/httpd.conf | grep ServerAlias | grep -v '#' | awk '{print $1, "\t", $2}')

M_TOTAL=$(sysctl -a | grep hw.memsize | awk '{print $2/1024/1024}')
M_FREE=$(top -l 1 -s 0 | grep PhysMem | awk '{print $6}')
M_USED=$(top -l 1 -s 0 | grep PhysMem | awk '{print $2}')
M_SWAP=$(sysctl vm.swapusage | awk '{print $4}')
M="M"

DISK=$(df -k / | tail -1 | awk '{print $3/1024/1024}')

VERSION=$(hostinfo | grep Version | awk '{print $4}')

PORTS=$(netstat -vatn | awk '$6 == "LISTEN"'| awk '{print $1, "\t", $4}')

#the service name "-e service_name" can be edited for other services
FILT_1="-e apache -e mysql"
STATUS_R=$(sudo -i launchctl list | grep $FILT_1 | awk '$2 != "0"'| awk '{print $3, "\t", "running"}')
STATUS_S=$(sudo -i launchctl list | grep $FILT_1 | awk '$2 == "0"'| awk '{print $3, "\t", "stopped"}')

FILT_2="-e running  -e stopped"
SERVICE=$(top -l 1 -s 0 | grep $FILT_2 | awk '{print $2, "\t", $13}')

#MEM=$(top -l 1 -o mem -stats mem,command | awk 'NR>12 {print $2, "\t", $1}')
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
Total $M_TOTAL$M
Free  $M_FREE
Used  $M_USED
Swap  $M_SWAP
Disk Space Used $DISK$M
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
