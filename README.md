# phpMyAdmin Autoconfig Docker Image
Based on the official [phpMyAdmin Docker Image](https://hub.docker.com/r/phpmyadmin/phpmyadmin/) and the great [docker-gen](https://github.com/jwilder/docker-gen) tool from Jason Wilder this tool automatically updates the phpMyAdmin configuration when new MySQL containers are started.

This image is meant for development environments and not for production/public servers as it allows passwordless logins to databases!

## Starting the image
This image needs the Docker socket to be mounted, in most cases this can be achieved by adding it as a volume with `-v /var/run/docker.sock:/tmp/docker.sock:ro`. A full example:

```
docker run -p 8080:80 -d -v /var/run/docker.sock:/tmp/docker.sock:ro elzekool/pma-autoconfig
```

## Connecting and configuring a MySQL container
The full list of environment variables is:

* ``PMA_USER`` - Username that is used to connect, defaults to `root`.
* ``PMA_PASS`` - Password that is used to connect, defaults to the value of `MYSQL_ROOT_PASSWORD`.
* ``PMA_VERBOSE`` - Verbose name of connection.
* ``PMA_ONLYDB`` - Visible databases (multiple are possible by separating them with `|`.

An example to start a MySQL container that will be added to the serverlist:

```
docker run -e MYSQL_ROOT_PASSWORD=toor --name testdatabase mysql
```

