#!/bin/bash
apt-get update -qq
apt upgrade -y -q
apt install -o DPkg::options::=--force-confmiss --reinstall -y opsi-server opsiconfd python-opsi opsi-utils opsi-tftpd-hpa opsi-linux-bootimage opsi-windows-support
apt install -o DPkg::options::=--force-confmiss --reinstall -y opsi-tftpd-hpa
sed -i '/^audit.* :/d' /etc/opsi/backendManager/dispatch.conf
sed -i '/^softwareLicense.* :/d' /etc/opsi/backendManager/dispatch.conf
sed -i '/^license.* :/d' /etc/opsi/backendManager/dispatch.conf
sed -i '/^[^#]/s/mysql, //g' /etc/opsi/backendManager/dispatch.conf
/usr/bin/opsi-setup --init-current-config
/usr/bin/opsi-setup --update-file
/usr/bin/opsi-setup --auto-configure-samba
/usr/bin/opsi-setup --patch-sudoers-file
/usr/bin/opsi-setup --set-rights
if [ "$OPSI_BACKEND" == "mysql" ]; then
  echo "CURRENTLY NOT WORKING"
#  apt purge -y mysql-server mysql-common
#  apt update -qq
#  debconf-set-selections <<< "mysql-server mysql-server/root_password password $OPSI_DB_ROOT_PASSWORD"
#  debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $OPSI_DB_ROOT_PASSWORD"
#  chown -R mysql:mysql /var/lib/mysql
#  apt install -y -qq --reinstall mysql-server mysql-client mysql-common
#  mysqld --initialize
#  service mysql stop

# chown -R mysql:mysql /var/lib/mysql
#  mysqld_safe --skip-grant-tables &
#  sleep 5
#  mysql -u root -e "UPDATE mysql.user SET authentication_string=PASSWORD(\"$OPSI_DB_ROOT_PASSWORD\") WHERE user='root';"
#  mysqladmin shutdown
#  service mysql start
#  sleep 5
#  mysql -u root -p$OPSI_DB_ROOT_PASSWORD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY \"$OPSI_DB_ROOT_PASSWORD\";"
#  mysql -u root -p$OPSI_DB_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
#  sed '/^\[mysqld\]/a sql_mode=NO_ENGINE_SUBSTITUTION' /etc/mysql/mysql.conf.d/mysqld.cnf
#  service mysql restart
#  mkdir -p /etc/opsi/backends
#  touch /etc/opsi/backends/mysql.conf
#  /usr/bin/opsi-setup --init-current-config
#  /usr/bin/opsi-setup --configure-mysql --unattended='{"dbAdminPass": "'$OPSI_DB_ROOT_PASSWORD'", "dbAdminUser":"root", "database":"'$OPSI_DB_NAME'"}'
#  /usr/bin/opsi-setup --init-current-config
#  /usr/bin/opsi-setup --update-mysql
#  /usr/bin/opsi-setup --init-current-config
#  /etc/init.d/opsiconfd restart
fi
#/usr/bin/opsi-setup --set-rights

#/etc/init.d/opsiconfd start
#/usr/bin/opsi-setup --init-current-config
#/usr/bin/opsi-setup --set-rights
#/usr/bin/opsi-setup --auto-configure-samba
#/etc/init.d/samba start
#/etc/init.d/openbsd-inetd start
#mkdir -p /var/lib/opsi/repository
#opsi-package-updater -vv install

