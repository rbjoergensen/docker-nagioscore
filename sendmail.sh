#!/bin/bash
sendgridapikey=".............................."
mailto="mail@mail.dk"
mailfrom="mail@mail.dk"
subject="subject here"
body="DefaultNagiosMailBody\n\nTest"
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
echo "mail sent from script" >> /usr/local/nagios/var/nagios.log
