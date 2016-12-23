# Database container with simple data for a Web application
# Using RHEL 7 base image and Mongo DB database
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

# Add Mongo DB
RUN yum -y install net-tools mongodb-server

# Lose some weight
RUN yum clean all

# Configure mongod
RUN sed -i -e 's/fork = true/fork = false/g'  /etc/mongod.conf
RUN sed -i -e 's/bind_ip =/#bind_ip =/g'  /etc/mongod.conf

# Expose Mongo DB port 27017
EXPOSE 27017

# Start the service
CMD /usr/bin/mongod --quiet -f /etc/mongod.conf run
