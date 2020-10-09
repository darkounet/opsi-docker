# opsi-docker <!-- omit in toc -->

- [1 Build](#1-build)
- [2 Run](#2-run)
  - [2.1 File backend](#21-file-backend)
  - [2.2 MySQL backend](#22-mysql-backend)
  - [2.3 Completing setup](#23-completing-setup)
- [3 Running commands inside the container](#3-running-commands-inside-the-container)
- [4 Additional information](#4-additional-information)
- [5 Variables](#5-variables)
- [6 Ports](#6-ports)

## 1 Build

` docker build -t opsi-docker:4.1 . `

## 2 Run

### 2.1 File backend

Start container after building the image (edit the following lines to match your environment!):

```bash
docker run -itd --name opsi-server \
 -h opsi.example.com \
 -v /media/dockerdata/opsi/var/lib/opsi/:/var/lib/opsi/ \
 -v /media/dockerdata/opsi/etc/opsi/:/etc/opsi/ \
 -e OPSI_USER=adminuser \
 -e OPSI_PASSWORD=linux123 \
 -e OPSI_BACKEND=file \
 -p 4447:4447 \
 opsi-docker:4.1

```

### 2.2 MySQL backend

---
**NOTE**
This image does not contain a MySQL server. So you have to setup another container or mysql-server and need access to the IP and port (TCP/3306).
---<!-- omit in toc -->

You need an existing and accessible mysql or mariadb server which meets the given recommendations for opsi. I used the mysql docker container and got some errors during setup. So watch the running setup (2.3) carefully.
You also need an existing mysql user with permission on the database.

```sql
CREATE USER 'opsiadmin'@'%' IDENTIFIED BY 'opsi_db_passw0rd';
GRANT ALL PRIVILEGES ON opsi.* TO 'opsiadmin'@'%';
FLUSH PRIVILEGES;
```

If you got and verfied all needed info start the container, e.g.:

```bash
docker run -itd --name opsi-server \
 -h opsi.example.com \
 -v /media/dockerdata/opsi/var/lib/opsi/:/var/lib/opsi/ \
 -v /media/dockerdata/opsi/etc/opsi/:/etc/opsi/ \
 -e OPSI_USER=adminuser \
 -e OPSI_PASSWORD=linux123 \
 -e OPSI_BACKEND=mysql \
 -e OPSI_DB_HOST=192.168.1.83 \
 -e OPSI_DB_NAME=opsi \
 -e OPSI_DB_OPSI_USER=opsiadmin \
 -e OPSI_DB_OPSI_PASSWORD=opsi_db_passw0rd \
 -p 4447:4447 \
 opsi-docker:4.1
```

### 2.3 Completing setup

For the initial setup after the first start of your container (in detattched mode) you need to run (in the first 30 seconds after the container started):

```bash
docker attach opsi-server
```

It will ask you if you want to initally want to setup the opsi server.

```bash
Do you want to run the setup-script to start using this container? (y/N)
```

---
**NOTE**
For this setup the container needs internet connection.
---<!-- omit in toc -->

After the setup finished (opsi-package-updater has installed some packages) and no breaking errors occured you can detach from the container. Normally [CTRL] + P   [CTRL] + Q

You can now connect to your OPSI via https://<DOCKER_IP>:4447 using given credentials.

## 3 Running commands inside the container

For some reasons you want to run some commands inside the container, e.g. `opsi-package-updater`.
You can do this in the running container by using the `docker exec` command. \
Like `docker exec -it opsi-server opsi-package-updater -v update`

## 4 Additional information

1. **This container does not use the build in dhcp-server**
2. If you want to use more than just the opsi-configed you need to expose more ports from the container. You can do this by using the `-p` option
3. Because you may have some of these ports on your host system already in use I recommend using a dedicated network for this container. I created a dedicated network (vlan) for some container. In this case you don't have to publish a port because the whole container is published. So be careful where you expose your server. I used the following command to start the container after building: 
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
 -e OPSI_DB_NAME=opsi \
 -e OPSI_DB_OPSI_USER=opsiadmin \
 -e OPSI_DB_OPSI_PASSWORD=opsi_db_passw0rd \
 --network DMZ \
 --ip 192.168.1.85 \
 opsi-docker:4.1
```

## 5 Variables

- OPSI_USER: adminuser
- OPSI_PASSWORD: linux123
- OPSI_BACKEND: file or mysql
- OPSI_DB_HOST: *IP-Address*
- OPSI_DB_NAME: *Database name*
- OPSI_DB_OPSI_USER: *Database User*
- OPSI_DB_OPSI_PASSWORD: *Password for database user*

## 6 Ports

1. SMB \
`-p 137:137` \
`-p 138:138` \
`-p 139:139` \
`-p 445:445`
2. tftp server (pxe boot) \
`-p 69:69`