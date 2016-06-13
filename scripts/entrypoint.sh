#!/bin/bash

/usr/sbin/useradd -m -s /bin/bash $OPSI_USER

echo "$OPSI_USER:$OPSI_PASSWORD" | chpasswd

echo -e "$OPSI_PASSWORD\n$OPSI_PASSWORD\n" | smbpasswd -s -a $OPSI_USER

/usr/sbin/usermod -aG opsiadmin $OPSI_USER

/usr/sbin/usermod -aG pcpatch $OPSI_USER

/usr/bin/opsi-setup --init-current-config

/usr/bin/opsi-setup --set-rights

/usr/bin/opsiconfd
