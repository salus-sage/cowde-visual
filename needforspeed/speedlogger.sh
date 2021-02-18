#!/bin/bash

dirpath=/home/pi/needforspeed
logfile=$dirpath/$HOSTNAME.log

date >> $logfile
speedtest | grep -e 'Download' -e 'Upload' >> $logfile
printf "\n" >> $logfile

sshpass -p "slot3354" rsync $logfile cowdenet@pantoto.net:~/needforspeed

## copy needforspeed folder in ~
## make a hostname.log file in that folder
## add this to the "crontab -e" "0,30 * * * * bash /home/pi/needforspeed/speedlogger.sh"
for file in `ls *.log` 
do
echo "Date, Download, Upload" > $file.csv; cat $file| awk '!NF{$0=">"}1' | sed 's/$/,/' | sed 's/>,/>/g' | tr -d '\n' | tr '>' '\n'  | sed -e 's/2021,/2021,,,/g' -e 's/2020,/2020,,,/g' | sed 's/,,,Download/,Download/g' | sed -e 's/Download: //g' -e 's/Upload://g' -e 's/Mbit\/s//g' |sed 's/ ,/,/g' | sed 's/, /,/g'| sed 's/,,,\./,/g'| sed 's/,\. /,/g'| cut -d, -f1-3|tee -a $file.csv
done
