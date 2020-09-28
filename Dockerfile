FROM debian:buster-slim

MAINTAINER Christopher KOEHLER <spam@koechr.de>

ENV DEBIAN_FRONTEND noninteractive

ENV OPSI_USER="$OPSI_USER"
ENV OPSI_PASSWORD="$OPSI_PASSWORD"
#ENV OPSI_BACKEND="$OPSI_BACKEND"
#ENV OPSI_DB_NAME="$OPSI_DB_NAME"
#ENV OPSI_DB_OPSI_USER="$OPSI_DB_OPSI_USER"
#ENV OPSI_DB_OPSI_PASSWORD="$OPSI_DB_OPSI_PASSWORD"
#ENV OPSI_DB_ROOT_PASSWORD="$OPSI_DB_ROOT_PASSWORD"

RUN apt update -qq \
 && apt install -y -qq hostname apt-utils iputils-ping openssl net-tools openssh-client vim \
 && apt install -y -qq wget lsof host python-mechanize p7zip-full cabextract openbsd-inetd pigz cpio \
 && apt install -y -qq samba samba-common smbclient cifs-utils \
 && apt install -y -qq curl

# add mysql user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# RUN groupadd -r mysql && useradd -r -g mysql mysql
# RUN apt-get update -qq && apt-get install -y -qq gnupg dirmngr debconf \
#  && apt update -qq \
#  && { \
#    echo debconf debconf/frontend select Noninteractive; \
#    echo mysql-server mysql-server/root_password password "S3cureR00tPass"; \
#    echo mysql-server mysql-server/root_password_again password "S3cureR00tPass"; \
#  } | debconf-set-selections \
#  && apt install -y -qq mysql-server mysql-client mysql-common \
#  && chown -R mysql:mysql /var/lib/mysql \
#  && usermod -d /var/lib/mysql mysql \
#  && sleep 10

RUN echo "deb http://download.opensuse.org/repositories/home:/uibmz:/opsi:/4.1:/stable/Debian_10/ /" > /etc/apt/sources.list.d/opsi.list \
 && wget -O - http://download.opensuse.org/repositories/home:/uibmz:/opsi:/4.1:/stable/Debian_10/Release.key | apt-key add - \
 && apt update -qq \
 && apt purge -y tftpd

# Only needed when a tftp line is present in the inetd configuration
RUN update-inetd --remove tftp \
 && rm -rf /tftpboot
RUN apt install -y -qq debconf \
 && echo "opsi-tftpd-hpa tftpd-hpa/directory string /tftpboot" | debconf-set-selections
RUN apt install -y -qq opsi-tftpd-hpa opsi-server opsi-windows-support \
 && apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#VOLUME ["/var/lib/opsi/", "/etc/opsi/", "/etc/mysql", "/var/lib/mysql"]
VOLUME ["/var/lib/opsi/", "/etc/opsi/"]

COPY ./scripts/setup.sh /usr/local/bin/
COPY ./scripts/entrypoint.sh /usr/local/bin/

EXPOSE 139/tcp 445/tcp 4447/tcp 69/udp 137/udp 138/udp 69/udp 22/tcp

ENTRYPOINT "/usr/local/bin/entrypoint.sh"

