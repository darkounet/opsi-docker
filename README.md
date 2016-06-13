# opsi-docker


## Build

``` docker build -t opsi-docker . ```

## Run

``` docker run -it -h <opsi_hostname> -p 0.0.0.0:4447:4447 opsi-docker -e OPSI_USER=opsi.username -e OPSI_PASSWORD=opsi.password ```


## TODO

* Mysql Backend
* opsi-product-updater
* custom repositories
