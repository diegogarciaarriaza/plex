#!/bin/bash

#Get params
file_path=$1
tag=$2
base_incompleted="/downloads/incoming/"
base_completed="/downloads/completed/"
base_media="/media/"
file_name=${file_path#$base_incompleted} #delete base_path of param1, if find it at the begining

echo -e "Moving $file_path to $base_media$2" >> /downloads/scripts/logs

#Move downloaded media files to the rigth folder (this is ok for files and for folder with files)
#Process: 1: In file_path find all video files. 2: the results is used in {}. 3: execute mv for move {} into destination. 4: logs and error are saved
find "$file_path" -regex ".*\.\(mpg\|mpeg\|h.264\|xvid\|divx\|mkv\|mp4\|avi\)" -exec mv -v -f {} $base_media$2 >> /downloads/scripts/logs 2>> /downloads/scripts/logs_errors \; &&
#find "$file_path" -regex ".*\.\(mpg\|mpeg\|h.264\|xvid\|divx\|mkv\|mp4\|avi\)" -exec rsync --remove-source-files -ahvP {} $base_media$2 >> /downloads/scripts/logs 2>> /downloads/scripts/logs_errors \; &

#echo -e "Moved $file_path to $base_media$2" >> /downloads/scripts/logs

#Send an email with information about it
echo -e "Subject: Download completed from server plex \nCongratulations! \nNow available $file_name in $tag" | ssmtp diego.garciaarriaza@gmail.com

#find . -regex ".*\.\(mpg\|mpeg\|h.264\|xvid\|divx\|mkv\|mp4\|avi\)"
#find . -type f -iname *.avi -exec mv {} -t /home/user/videos/ ;
