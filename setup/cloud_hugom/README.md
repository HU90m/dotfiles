# Nextcloud Setup

Nextcloud is kept in a container for simplicty
and to avoid making the server too messy with its dependancies
which should make maintanence easier.

## Container Configuration

Four containers are used. Two are required the database and the nextcloud app.
However, the cron and redis images are not required and can simply be removed
from `docker-compose.yml`.
Redis is a cache and cron is explained here: https://rair.dev/nextcloud-cron/ .


Their configuration is in the `docker-compose.yml` file.
The configuration requires `db_pass` and `db_rpass` which contain the root
password and the nextcloud user password of the database.
One will have to set the passwords in these files before running.

The nextcloud instance's persistent data is stored in `/var/www/cloud_hugom/`
and the database's data is stored in `/var/lib/maria_container/`.
One may have to create these directories before running the containers.

The containers are run with user and group ids of 1002, so a new user is
recommended with these ids. One can also add them selves to this user group in
order to access the nextcloud data.

```sh
useradd -u 1002 nextcloud
usermod -a -G nextcloud $user
```

To run the containers, run the following from the configuration's directory.

```sh
docker-compose up -d
```

To stop the containers:

```sh
docker-compose down
```

To see all the containers running (running or otherwise):

```sh
docker ps -a
```

The nextcloud app container is set up so that it is only accessible from the
host (127.0.0.1:8090).

## Nginx

The FMP (FastCGI Process Manager) Nextcloud image is used.
This means a reverse proxy is required.

An nginx site configuration is available here: `cloud_hugom`.
Put this in `/etc/nginx/sites-available` and create a symbolic link in
`/etc/nginx/sites-enabled` pointing to this file.

Then restart the nginx server:

```sh
sudo nginx -t && sudo nginx -s reload
```

*You should also set up HTTPS for the server!*

## Systemd Service

**The systemd service is not needed.
The containers have the 'always' restart policy,
so will automatically restart on reboot without the need of systemd,
i.e. everything below this point can be ignored**

There is a systemd service, `cloud.service`, which once enabled will
automatically start the containers after the computer boots.

This service expects the configuration files (`db_pass`, `db_rpass`, and
`docker-compose.yml`) to be in `/etc/cloud_hugom/`,
so these files should be moved to this directory before the service is enabled.
