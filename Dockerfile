FROM debian:buster-slim

MAINTAINER Christopher KOEHLER <spam@koechr.de>

ENV DEBIAN_FRONTEND noninteractive

ENV OPSI_USER="adminuser"
ENV OPSI_PASSWORD="linux123"
ENV OPSI_BACKEND="file"
ENV OPSI_DB_HOST=""
ENV OPSI_DB_NAME="opsi"
ENV OPSI_DB_OPSI_USER="opsiadmin"
ENV OPSI_DB_OPSI_PASSWORD="linux123"

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

EXPOSE 139/tcp 445/tcp 4447/tcp 69/udp 137/udp 138/udp

ENTRYPOINT "/usr/local/bin/entrypoint.sh"

