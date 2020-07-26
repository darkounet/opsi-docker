# opsi-docker

## Build

` docker build -t opsi-docker:4.1 . `

## Run

## File backend

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

you need to run :

```bash
docker exec -it docker-opsi /usr/local/bin/entrypoint.sh

```

You can now connect to your OPSI via https://<DOCKER_IP>:4447 using sysadmin/linux123

## Mysql backend ( alpha ... )

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

* Mysql Backend
* opsi-package-updater
* custom repositories
