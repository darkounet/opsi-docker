# opsi-docker

## Build

` docker build -t opsi-docker:4.1 . `

## Run

## File backend

Start container after building the image:

```bash
docker run -itd --name docker-opsi
    -h opsi.docker.lan \
    -v /srv/docker/var/lib/opsi/:/var/lib/opsi/ \
    -v /srv/docker/etc/opsi/:/etc/opsi/ \
    -p 0.0.0.0:4447:4447 \
    -e OPSI_USER=sysadmin \
    -e OPSI_PASSWORD=linux123 \
    opsi-docker:4.1
```

For the initial setup after the first start you need to run:

```bash
docker exec -it docker-opsi /usr/local/bin/entrypoint.sh

```

You can now connect to your OPSI via https://<DOCKER_IP>:4447 using sysadmin/linux123

I created a dedicated network (vlan) for some container. Because I need the samba shares, configed, maybe bootimage.. I use the following command to start the container after building:

```bash
docker run -itd --name opsi-server \
 -h opsi.localdomain \
 --dns 192.168.1.1 \
 --dns-search localdomain \
 -v /media/dockerdata/opsi/var/lib/opsi/:/var/lib/opsi/ \
 -v /media/dockerdata/opsi/etc/opsi/:/etc/opsi/ \
 -v /media/dockerdata/opsi/var/lib/mysql/:/var/lib/mysql/ \
 -v /media/dockerdata/opsi/etc/mysql/:/etc/mysql/ \
 -e OPSI_USER=sysuser \
 -e OPSI_PASSWORD=linux123 \
 -e OPSI_BACKEND=mysql \
 -e OPSI_DB_HOST=localhost \
 -e OPSI_DB_OPSI_USER=opsi_db_user \
 -e OPSI_DB_OPSI_PASSWORD=opsi_db_123_password \
 -e OPSI_DB_ROOT_PASSWORD=root_db_123_password \
 --network SERVER \
 opsi-docker:4.1
```


## Mysql backend ( alpha ... ), NOT IN THIS IMAGE

You need to use docker-compose (example coming asap)

### Vars

  - OPSI_BACKEND: mysql
  - OPSI_DB_HOST: db
  - OPSI_DB_OPSI_USER: opsi_db_user
  - OPSI_DB_OPSI_PASSWORD: opsi_db_123_password
  - OPSI_DB_ROOT_PASSWORD: root

### Files

`/etc/opsi/backends/mysql.conf`

```python
# -*- coding: utf-8 -*-

module = 'MySQL'
config = {
"username" : "opsi",
"connectionPoolMaxOverflow" : 10,
"database" : "opsi",
"connectionPoolTimeout" : 30,
"address" : "db",
"password" : "opsi",
"databaseCharset" : "utf8",
"connectionPoolSize" : 20
}

```

`/etc/opsi/backendManager/dispatch.conf`

```python
# -*- coding: utf-8 -*-

backend_.*         : mysql, opsipxeconfd
host_.*            : mysql, opsipxeconfd
productOnClient_.* : mysql, opsipxeconfd
configState_.*     : mysql, opsipxeconfd
.*                 : mysql
```

## TODO

* Mysql Backend -> **frustrating, not in this container, maybe linking container will work**
* opsi-package-updater
* custom repositories
