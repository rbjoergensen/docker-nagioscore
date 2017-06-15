# From image
FROM ubuntu:16.04

MAINTAINER rbjoergensen <rasmus@callofthevoid.dk>

# Allow postfix to install without interaction.
RUN echo "postfix postfix/mailname string example.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

RUN apt-get update && apt-get install -y -q \
                    mailutils

RUN cat /etc/postfix/main.cf

RUN systemctl restart postfix

RUN echo "This is the body of the email" | mail -s "This is the subject line" rasmusj@trendsales.dk

# CMD ["executable","param1","param2"]
