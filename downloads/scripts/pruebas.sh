#!/bin/bash

#Get params
file_path=$1
tag=$2
base_incompleted="/downloads/incoming/"
base_completed="/downloads/completed/"
base_media="/media/"
file_name=${file_path#$base_incompleted} #delete base_path of param1, if find it at the begining


find "$file_path" -regex ".*\.\(mpg\|mpeg\|h.264\|xvid\|divx\|mkv\|mp4\|avi\)" -exec echo {} >> /downloads/scripts/logs 2>> /downloads/scripts/logs_errors \;


