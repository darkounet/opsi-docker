# opsi-docker


## Build

` docker build -t opsi-docker . `

## Run

` docker run -it -h <opsi_hostname> -p 0.0.0.0:4447:4447 opsi-docker -e OPSI_USER=opsi.username -e OPSI_PASSWORD=opsi.password `

` docker exec -it opsi /usr/local/bin/entrypoint.sh`

## Mysql ( alpha ... )

### Vars

       OPSI_BACKEND: mysql
       OPSI_DB_HOST: db
       OPSI_DB_OPSI_USER: opsi_db_user
       OPSI_DB_OPSI_PASSWORD: opsi_db_123_password
       OPSI_DB_ROOT_PASSWORD: root


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



`/etc/opsi/backenManager/dispatch.conf`

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
* opsi-product-updater
* custom repositories
