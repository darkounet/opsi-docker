# opsi-docker

## Build

` docker build -t opsi-docker:4.1 . `

## Run

## File backend

Start container after building the image:

```bash
COMING SOON
```

For the initial setup after the first start you need to run:

```bash
COMING SOON

```

You can now connect to your OPSI via https://<DOCKER_IP>:4447 using given credentials

I created a dedicated network (vlan) for some container. Because I need the samba shares, configed, maybe bootimage.. I use the following command to start the container after building:

```bash
docker run -itd --name opsi-server \
 -h opsi.example.com \
 --dns 192.168.1.1 \
 --dns-search localdomain \
 -v /media/dockerdata/opsi/var/lib/opsi/:/var/lib/opsi/ \
 -v /media/dockerdata/opsi/etc/opsi/:/etc/opsi/ \
 -e OPSI_USER=adminuser \
 -e OPSI_PASSWORD=linux123 \
 -e OPSI_BACKEND=mysql \
 -e OPSI_DB_HOST=192.168.1.83 \
 -e OPSI_DB_OPSI_USER=opsiadmin \
 -e OPSI_DB_OPSI_PASSWORD=my_db_p4ss \
 --network DMZ \
 --ip 192.168.1.85 \
 opsi-docker:4.1

docker attach opsi-server (within 60 seconds for first initial setup)
CTRL-p CTRL-q (to dettach)
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
