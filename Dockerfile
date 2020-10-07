FROM debian:buster-slim

MAINTAINER Christopher KOEHLER <spam@koechr.de>

ENV DEBIAN_FRONTEND noninteractive

ENV OPSI_USER="$OPSI_USER"
ENV OPSI_PASSWORD="$OPSI_PASSWORD"
ENV OPSI_BACKEND="$OPSI_BACKEND"
ENV OPSI_DB_HOST="$OPSI_DB_HOST"
ENV OPSI_DB_NAME="$OPSI_DB_NAME"
ENV OPSI_DB_OPSI_USER="$OPSI_DB_OPSI_USER"
ENV OPSI_DB_OPSI_PASSWORD="$OPSI_DB_OPSI_PASSWORD"

RUN apt update -qq \
 && apt install -y -qq hostname apt-utils iputils-ping openssl net-tools openssh-client vim \
 && apt install -y -qq wget lsof host python-mechanize p7zip-full cabextract openbsd-inetd pigz cpio \
 && apt install -y -qq samba samba-common smbclient cifs-utils \
 && apt install -y -qq curl

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

VOLUME ["/var/lib/opsi/", "/etc/opsi/"]

COPY ./scripts/setup.sh /usr/local/bin/
COPY ./scripts/entrypoint.sh /usr/local/bin/
COPY ./scripts/opsipxeconfd.conf /root/
#COPY ./scripts/backends/mysql.conf /etc/opsi/backends/

EXPOSE 139/tcp 445/tcp 4447/tcp 69/udp 137/udp 138/udp 22/tcp

ENTRYPOINT "/usr/local/bin/entrypoint.sh"

