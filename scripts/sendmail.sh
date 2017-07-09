#!/bin/bash
sendgridapikey=`cat /utilities/MAIL_APIKEY`
mailto=`cat /utilities/MAILTO`
mailfrom=`cat /utilities/MAILFROM`
subject="Default Subject"
body="Default\nBody"
while getopts a:t:f:s:b: option
do
case "${option}"
in
a) sendgridapikey=${OPTARG};;
t) mailto=${OPTARG};;
f) mailfrom=${OPTARG};;
s) subject=${OPTARG};;
b) body=${OPTARG};;
esac
done
curl -X POST "https://api.sendgrid.com/v3/mail/send" -H "Authorization: Bearer $sendgridapikey" -H "Content-Type: application/json" -d \
'{"personalizations":[{"to":[{"email":"'"$mailto"'"}],"subject":"'"$subject"'"}],"from":{"email":"'"$mailfrom"'","name": "Nagios"},"content":[{"type":"text/plain","value":"'"$body"'"}]}'
echo "Sendmail script activated and mail has been sent to $mailto" >> /usr/local/nagios/var/nagios.log
