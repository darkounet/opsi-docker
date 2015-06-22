# OPSI Dockerfile

FROM debian:wheezy

MAINTAINER Antoine GUEVARA <me@antoine-guevara.fr>


ENV DEBIAN_FRONTEND noninteractive
ENV HOSTNAME opsi.docker.lan
ENV cert_country="FR"
ENV cert_state="docker"
ENV cert_locality="docker"
ENV cert_organization="Docker"
ENV cert_unit=""
ENV cert_commonname="$HOSTNAME"
ENV cert_email=""
ENV tmp_opsiconfd_rand="/tmp/tmp_opsiconfd_rand"
ENV tmp_opsiconfd_cnf="/tmp/tmp_opsiconfd_cnf"

RUN apt-get update

RUN apt-get install -y -qq hostname apt-utils iputils-ping openssl net-tools openssh-client

RUN apt-get install -y -qq wget lsof host python-mechanize p7zip-full cabextract openbsd-inetd pigz

RUN apt-get install -y -qq samba samba-common smbclient cifs-utils samba-doc

RUN echo "deb http://download.opensuse.org/repositories/home:/uibmz:/opsi:/opsi40/Debian_7.0 ./" > /etc/apt/sources.list.d/opsi.list

RUN wget -O - http://download.opensuse.org/repositories/home:/uibmz:/opsi:/opsi40/Debian_7.0/Release.key | apt-key add -

RUN apt-get update

RUN mkdir -p /etc/opsi

RUN echo "RANDFILE = $tmp_opsiconfd_rand" >  $tmp_opsiconfd_cnf ;\
    echo "" >> $tmp_opsiconfd_cnf ;\
    echo "[ req ]" >> $tmp_opsiconfd_cnf ;\
    echo "default_bits = 1024" >> $tmp_opsiconfd_cnf ;\
    echo "encrypt_key = yes" >> $tmp_opsiconfd_cnf ;\
    echo "distinguished_name = req_dn" >> $tmp_opsiconfd_cnf ;\
    echo "x509_extensions = cert_type" >> $tmp_opsiconfd_cnf ;\
    echo "prompt = no" >> $tmp_opsiconfd_cnf ;\
    echo "" >> $tmp_opsiconfd_cnf ;\
    echo "[ req_dn ]" >> $tmp_opsiconfd_cnf ;\
    echo "C=$cert_country" >> $tmp_opsiconfd_cnf ;\
    echo "ST=$cert_state" >> $tmp_opsiconfd_cnf ;\
    echo "L=$cert_locality" >> $tmp_opsiconfd_cnf ;\
    echo "O=$cert_organization" >> $tmp_opsiconfd_cnf ;\
    if [ "$cert_unit" != "" ] ;\
    then echo "OU=$cert_unit" >> $tmp_opsiconfd_cnf  ;\
    fi ;\
    echo "CN=$cert_commonname" >> $tmp_opsiconfd_cnf  ;\
    if [ "$cert_email" != "" ] ;\
    then echo "emailAddress=$cert_email" >> $tmp_opsiconfd_cnf ;\
    fi ;\
    echo "" >> $tmp_opsiconfd_cnf ;\
    echo "[ cert_type ]" >> $tmp_opsiconfd_cnf ;\
    echo "nsCertType = server" >> $tmp_opsiconfd_cnf

RUN dd if=/dev/urandom of=$tmp_opsiconfd_rand count=1 2>/dev/null

RUN openssl req -new -x509 -days 1000 -nodes -config $tmp_opsiconfd_cnf -out /etc/opsi/opsiconfd.pem -keyout /etc/opsi/opsiconfd.pem
RUN openssl gendh -rand $tmp_opsiconfd_rand 512 >>/etc/opsi/opsiconfd.pem
RUN openssl x509 -subject -dates -fingerprint -noout -in /etc/opsi/opsiconfd.pem

RUN apt-get -y remove tftpd

RUN apt-get install -y -qq opsi-atftpd

RUN echo "127.0.0.1 $HOSTNAME" > /etc/hosts; apt-get install -y -qq opsiconfd

RUN echo "127.0.0.1 $HOSTNAME" > /etc/hosts; apt-get install -y -qq opsi-depotserver

RUN echo "127.0.0.1 $HOSTNAME" > /etc/hosts; apt-get install -y -qq opsi-configed

EXPOSE 4447 69/udp

VOLUME ["/var/lib/opsi/","/etc/opsi"]

