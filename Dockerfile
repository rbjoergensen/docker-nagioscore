# From image
FROM ubuntu:16.04

MAINTAINER rbjoergensen <rasmus@callofthevoid.dk>

# Allow postfix to install without interaction.
RUN debconf-set-selections <<< "postfix postfix/mailname string example.com"
RUN debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

RUN apt-get update && apt-get install -y -q \
                    mailutils

RUN cat /etc/postfix/main.cf

RUN systemctl restart postfix

echo "This is the body of the email" | mail -s "This is the subject line" rasmusj@trendsales.dk

# CMD ["executable","param1","param2"]
