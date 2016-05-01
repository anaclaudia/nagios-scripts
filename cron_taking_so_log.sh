#!/bin/bash

WARN=$2
CRIT=$3

if [[ (-z $1 || -z $2 || -z $3) ]]
then
  echo "Usage:"
  echo "$0 PROCESS_NAME WARNING CRITICAL"
  exit 1
fi

if [[ "$CRIT" -lt "$WARN" ]]
then
  echo "Please inform a WARNING value lower than the CRITICAL value"
  exit 1
fi

for i in $(pgrep $1)
do
  PROC_PID=`ps -o pid -p $i | grep -v PID`
  PROC_PPID=`ps -o ppid -p $i | grep -v PPID`
  ETIME=`ps -o etime -p $i | cut -d ":" -f1 | grep -v ELAPSED`
  PROC_NAME=`ps -o comm -p $i | grep -v COMMAND`
  
  if [[ ("$ETIME" -gt "$WARN") && ("$ETIME" -lt "$CRIT") ]]
    then
      echo "WARNING - Process $PROC_NAME is running for $ETIME minutes. PID: $PROC_PID, PPID: $PROC_PPID"
      exit 1
  elif [[ "$ETIME" -ge "$CRIT" ]]
    then
      echo "CRITICAL - Process $PROC_NAME is running for $ETIME minutes. PID: $PROC_PID, PPID: $PROC_PPID"
      exit 2
  fi
done
