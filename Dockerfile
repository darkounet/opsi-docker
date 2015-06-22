# OPSI Dockerfile

FROM debian:wheezy

MAINTAINER Antoine GUEVARA <me@antoine-guevara.fr>


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y wget lsof host python-mechanize p7zip-full cabextract openbsd-inetd pigz

RUN apt-get install -y samba samba-common smbclient cifs-utils samba-doc


