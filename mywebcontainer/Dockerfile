# Webserver container with CGI python script
# Using RHEL 7 base image and Apache Web server
# Version 1

# Pull the rhel image from the local repository
FROM rhel7:latest
USER root

MAINTAINER David Taylor <dataylor@redhat.com>

# Fix per https://bugzilla.redhat.com/show_bug.cgi?id=1192200 
RUN yum -y install deltarpm yum-utils --disablerepo=*-eus-* --disablerepo=*-htb-* --disablerepo=*sjis* \
    --disablerepo=*-ha-* --disablerepo=*-rt-* --disablerepo=*-lb-* --disablerepo=*-rs-* --disablerepo=*-sap-*
RUN yum-config-manager --disable *-eus-* *-htb-* *-ha-* *-rt-* *-lb-* *-rs-* *-sap-* *-sjis-* > /dev/null
RUN yum -y update 

# Install EPEL repo
# If you don't have internet access, then download this locally
# ADD epel-release-latest-7.noarch.rpm /tmp/
# RUN yum -y localinstall /tmp/epel-release-latest-7.noarch.rpm
RUN yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Needed rpms
RUN yum -y install httpd procps-ng php-pecl-mongo php mongodb

# Lose some weight
RUN yum clean all

# Add web root
ADD html /var/www/html

# pass apache the kubernetes service ip for the db-service 
# when launched in kubernetes, each pod creates a new environment variable with its host and port information
# we can access the db-service by accessing the db-service's variables
RUN echo "PassEnv MONGODB_SERVICE_SERVICE_HOST" >> /etc/httpd/conf/httpd.conf
RUN echo "PassEnv HOSTNAME" >> /etc/httpd/conf/httpd.conf

# lets populate a static file with some text
RUN echo 'The Web Server on <?php echo $_SERVER["HOSTNAME"]; ?> is jogging! The Mongo database is located at <?php echo $_SERVER["MONGODB_SERVICE_SERVICE_HOST"]; ?>' > /var/www/html/index.php
RUN echo '<?php phpinfo(); ?>'  >> /var/www/html/phpinfo.php

# fix permissions
RUN chown -R root:apache /var/www/html
RUN chmod 755 /var/www/html
RUN chmod 755 /var/www/html/js
RUN chmod 755 /var/www/html/css
RUN chmod 444 /var/www/html/*
RUN chmod 444 /var/www/html/js/*
RUN chmod 444 /var/www/html/css/*

# expose the port
EXPOSE 80

# Start the service
CMD mkdir /run/httpd ; /usr/sbin/httpd -D FOREGROUND
