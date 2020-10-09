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
mv /root/opsipxeconfd.conf /etc/opsi/
/usr/bin/opsi-setup --set-rights
mkdir /var/run/opsipxeconfd
chown root:opsiadmin /var/run/opsipxeconfd
if [ "$OPSI_BACKEND" == "mysql" ]; then
  echo "USE WITH CAUTION"
  # changing mysql.conf
  if [ "$OPSI_DB_HOST" == "localhost" ]; then
    echo "[ERROR] variable OPSI_DB_HOST can not be localhost"
    exit 1
  fi
  sed -i "s/u\"localhost\"/u\"$OPSI_DB_HOST\"/g" /etc/opsi/backends/mysql.conf

  if [ "$OPSI_DB_NAME" == "" ]; then
    echo "[ERROR] variable OPSI_DB_NAME must be set"
    exit 1
  fi
  sed -i "/\"database\":/s/.*/    \"database\":                  u\"$OPSI_DB_NAME\",/" /etc/opsi/backends/mysql.conf

  if [ "$OPSI_DB_OPSI_USER" == ""]; then
    echo "[ERROR] variable OPSI_DB_OPSI_USER must be set"
    exit 1
  fi
  sed -i "/\"username\":/s/.*/    \"username\":                  u\"$OPSI_DB_OPSI_USER\",/" /etc/opsi/backends/mysql.conf

  if [ "$OPSI_DB_OPSI_PASSWORD" == ""]; then
    echo "[ERROR] variable OPSI_DB_OPSI_PASSWORD not set. You should specify a connection password!"
    exit 1
  fi
  sed -i "/\"password\":/s/.*/    \"password\":                  u\"$OPSI_DB_OPSI_PASSWORD\",/" /etc/opsi/backends/mysql.conf

  sed -i "/^.\* : file/i license.* : mysql" /etc/opsi/backendManager/dispatch.conf
  sed -i "/^.\* : file/i softwareLicense.* : mysql" /etc/opsi/backendManager/dispatch.conf
  sed -i "/^.\* : file/i audit.* : mysql" /etc/opsi/backendManager/dispatch.conf
  sed -i "s/^backend_.\* : file, opsipxeconfd/backend_.* : file, mysql, opsipxeconfd/g" /etc/opsi/backendManager/dispatch.conf
  /usr/bin/opsi-setup --init-current-config
  /usr/bin/opsi-setup --update-mysql
  /usr/bin/opsi-setup --init-current-config
fi
/usr/bin/opsi-setup --set-rights

opsi-package-updater install
