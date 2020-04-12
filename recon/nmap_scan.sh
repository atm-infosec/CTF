#!/bin/bash

# Simple nmap script

display_help()
{
	echo "Simple nmap port scanner"
	echo 
	echo "usage: $(basename $0) -h [-o output]"
	echo
	echo "where:"
	echo "-h  hostname (ip or domain)"
	echo "-o  outputfile (optional)"
}

while getopts ":h:o:" arg; do
  case $arg in
    h) HOST=$OPTARG;;
    o) OUTPUT=$OPTARG;;
  esac
done

if [ -z $HOST ]
then
  display_help
  exit 1
fi

# Speed up port scan
# first scan on target only on open ports and save them as comma seperated line
# second scan to determine service/version info
ports=$(nmap -p- --min-rate=1000 -T5 $HOST | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)

if [ -n $OUTPUT ]
then
  nmap -p$ports -sC -sV $HOST | tee $OUTPUT
else
  nmap -p$ports -sC -sV $HOST
fi
