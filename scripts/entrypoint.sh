#!/bin/bash
apt-get update -qq
/usr/sbin/useradd -m -s /bin/bash $OPSI_USER
echo "$OPSI_USER:$OPSI_PASSWORD" | chpasswd
echo -e "$OPSI_PASSWORD\n$OPSI_PASSWORD\n" | smbpasswd -s -a $OPSI_USER
/usr/sbin/usermod -aG opsiadmin $OPSI_USER
/usr/sbin/usermod -aG pcpatch $OPSI_USER
if [ "$OPSI_BACKEND" == "mysql" ]; then
  /usr/bin/opsi-setup --configure-mysql --unattended='{"dbAdminPass": "'${OPSI_DB_ROOT_PASSWORD}'", "dbAdminUser":"root", "database":"'${OPSI_DB}'"}'
  /usr/bin/opsi-setup --update-mysql
  /etc/init.d/opsiconfd restart
fi
/usr/bin/opsi-setup --set-rights
apt-get -qq -o DPkg::options::=--force-confmiss --reinstall install python-opsi opsiconfd opsi-depotserver opsi-utils
/etc/init.d/opsiconfd start
/usr/bin/opsi-setup --init-current-config
/usr/bin/opsi-setup --set-rights
/usr/bin/opsi-setup --auto-configure-samba
/etc/init.d/samba start
/etc/init.d/openbsd-inetd start
mkdir -p /var/lib/opsi/repository
opsi-package-updater -vv update

