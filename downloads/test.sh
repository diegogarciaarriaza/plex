#!/bin/bash
echo ls $1 > /downloads/scripts/logs.txt
#mv "$1" "$2"
mv -v -f "$1" "$2" > /downloads/scripts/logs.txt 2> /downloads/scripts/logs_errors.txt
echo moved $1 to $2 >> /downloads/scripts/logs.txt

