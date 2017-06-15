# From image
FROM ubuntu:16.04

MAINTAINER rbjoergensen <rasmus@callofthevoid.dk>

# Allow postfix to install without interaction.
RUN echo "postfix postfix/mailname string example.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

RUN apt-get update && apt-get install -y -q \
					apt-utils \
                    mailutils \
					libsasl2-modules

RUN cat /etc/postfix/main.cf

RUN sed '/relayhost =/d' ./infile && \
	echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf && \
	echo "smtp_sasl_password_maps = static:yourSendGridUsername:yourSendGridPassword" >> /etc/postfix/main.cf && \
	echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf && \
	echo "smtp_tls_security_level = encrypt" >> /etc/postfix/main.cf && \
	echo "header_size_limit = 4096000" >> /etc/postfix/main.cf && \
	echo "relayhost = [smtp.sendgrid.net]:587" >> /etc/postfix/main.cf && \
	cat /etc/postfix/main.cf

RUN service postfix restart

RUN echo "This is the body of the email" | mail -s "This is the subject line" rasmusj@trendsales.dk

EXPOSE 80 25 587

# CMD ["executable","param1","param2"]

#RUN cat /etc/mail/access