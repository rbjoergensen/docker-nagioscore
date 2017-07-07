FROM ubuntu:16.04

MAINTAINER rbjoergensen <rasmusbojorgensen@gmail.com>

#################################
# Updates and installs
#################################

RUN apt-get -y update && \
    mkdir /utilities && \
	  apt-get -y install curl iputils-ping

#################################
# Nagios and Apache
#################################

RUN apt-get install -y wget build-essential apache2 php apache2-mod-php7.0 php-gd libgd-dev unzip && \
    useradd nagios && \
	  groupadd nagcmd && \
	  usermod -a -G nagcmd nagios && \
	  usermod -a -G nagios,nagcmd www-data

# Download and extract the Nagios core

RUN	cd ~ && \
	  wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.0.tar.gz && \
	  tar -xzf nagios*.tar.gz && \
	  cd nagios-4.2.0 && \

	  ./configure --with-nagios-group=nagios --with-command-group=nagcmd && \
	  make all && \
	  make install && \
	  make install-commandmode && \
	  make install-init && \
	  make install-config && \
	  /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf && \
	  cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/ && \
	  chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

RUN	cd ~
RUN	wget https://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz
RUN	tar -xzf nagios-plugins*.tar.gz
RUN	cd nagios-plugins-2.1.2/ && \
	  ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl && \
	  make && \
	  make install

RUN a2enmod rewrite
RUN a2enmod cgi
RUN htpasswd -c -b /usr/local/nagios/etc/htpasswd.users nagiosadmin password
RUN ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

#################################
# Environment Variables
#################################

ENV MAIL_APIKEY=default
ENV MAILTO=default
ENV MAILFROM=default

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

ENTRYPOINT service apache2 restart && \
		       service nagios start && \
		       bash && \
           echo $MAIL_APIKEY >> /utilities/MAIL_APIKEY && \
           echo $MAILTO >> /utilities/MAILTO && \
           echo $MAILFROM >> /utilities/MAILFROM && \
		       cat /usr/local/nagios/etc/htpasswd.users && \
		       tail -f /usr/local/nagios/var/nagios.log
