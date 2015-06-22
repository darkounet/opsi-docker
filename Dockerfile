# OPSI Dockerfile

FROM debian:wheezy

MAINTAINER Antoine GUEVARA <me@antoine-guevara.fr>


ENV DEBIAN_FRONTEND noninteractive

ENV HOSTNAME opsi.docker.lan


RUN apt-get update

RUN apt-get install -y wget lsof host python-mechanize p7zip-full cabextract openbsd-inetd pigz

RUN apt-get install -y samba samba-common smbclient cifs-utils samba-doc

RUN echo "deb http://download.opensuse.org/repositories/home:/uibmz:/opsi:/opsi40/Debian_7.0 ./" > /etc/apt/sources.list.d/opsi.list

RUN wget -O - http://download.opensuse.org/repositories/home:/uibmz:/opsi:/opsi40/Debian_7.0/Release.key | apt-key add -

RUN apt-get update

RUN apt-get -y remove tftpd

RUN apt-get install -y opsi-atftpd

RUN apt-get install -y opsi-depotserver

RUN apt-get install -y opsi-configed

