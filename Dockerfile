FROM wrix/nagiosbase:latest

MAINTAINER rbjoergensen <rasmusbojorgensen@gmail.com>

#################################
# Environment Variables
#################################

ENV MAIL_APIKEY=default
ENV DEFAULT_MAILTO=default
ENV DEFAULT_MAILFROM=default
ENV CONTACT_SMS=default
ENV CONTACT_MAIL=default

#################################
# Nagios Config Files
#################################

RUN rm -rf /usr/local/nagios/etc/nagios.cfg && \
    rm -rf /usr/local/nagios/etc/resource.cfg && \
    rm -rf /usr/local/nagios/etc/cgi.cfg && \
    rm -rf /usr/local/nagios/etc/objects/commands.cfg && \
    rm -rf /usr/local/nagios/etc/objects/timeperiods.cfg && \
	  rm -rf /usr/local/nagios/etc/objects/contacts.cfg

COPY config/nagios.cfg          /usr/local/nagios/etc/nagios.cfg
COPY config/resource.cfg        /usr/local/nagios/etc/resource.cfg
COPY config/cgi.cfg             /usr/local/nagios/etc/cgi.cfg
COPY config/commands.cfg        /usr/local/nagios/etc/objects/commands.cfg
COPY config/contacts.cfg        /usr/local/nagios/etc/objects/contacts.cfg
COPY config/nrpe_commands.cfg   /usr/local/nagios/etc/objects/nrpe_commands.cfg
COPY config/timeperiods.cfg     /usr/local/nagios/etc/objects/timeperiods.cfg

#################################
# Nagios Plugins
#################################

COPY plugins/check_nrpe         /usr/local/nagios/libexec/check_nrpe

RUN chmod 777                   /usr/local/nagios/libexec/check_nrpe

#################################
# Host Config Files
#################################

RUN rm -rf                      /usr/local/nagios/etc/objects/localhost.cfg

COPY config/localhost.cfg       /usr/local/nagios/etc/objects/localhost.cfg
COPY hostconfig/                /usr/local/nagios/etc/servers

#################################
# Mail script using Sendgrid
#################################

ADD scripts/sendmail.sh         /utilities/sendmail.sh
RUN chmod 777                   /utilities/sendmail.sh
RUN chmod +x                    /utilities/sendmail.sh

#################################
# Final configuration
#################################

EXPOSE 80

#RUN cat /usr/local/nagios/var/nagios.log

ENTRYPOINT echo $MAIL_APIKEY >> /utilities/MAIL_APIKEY && \
           echo $DEFAULT_MAILTO >> /utilities/MAILTO && \
           echo $DEFAULT_MAILFROM >> /utilities/MAILFROM && \
           sed -i 's/nagiosadminmail_default/'$CONTACT_MAIL'/g' /usr/local/nagios/etc/objects/contacts.cfg && \
           sed -i 's/nagiosadminsms_default/'$CONTACT_SMS'/g' /usr/local/nagios/etc/objects/contacts.cfg && \
           cat /usr/local/nagios/etc/objects/contacts.cfg && \
           service apache2 restart && \
           service nagios restart && \
		       cat /usr/local/nagios/etc/htpasswd.users && \
		       tail -f /usr/local/nagios/var/nagios.log
