# How I set up the server

## site location

The static content for the site all sits in `/var/www/hugom/`.
Currently three directories here `error/`, `main/` and `notes/`,
which hold the error pages, the main site and the static tiddly wiki notes
respectively.


## nginx configuration

The `hugom` file contains the configuration for the site.
Copy the file to `/etc/nginx/sites-available`
and enable using the following command.
Do also remove any other links within `/etc/nginx/sites-enabled`,
such as `default` if it is present.

```sh
ln -s /etc/nginx/site-available/hugom /etc/nginx/sites-enabled.
```

To test a new configuration and then load it:

```sh
nginx -t && nginx -s reload
```

### Basic Authentication

The hugom site uses basic authentication for some paths
which it expects to find in `/etc/nginx/.htpasswd-hugo_notebook`.
To add a username, 'hugo' in this case,
pass word pair to this file run the following.
Use the `-c` flag when creating a new file.

```sh
htpasswd /etc/nginx/.htpasswd-hugom_notebook hugo
```

If htpasswd isn't installed it can be installed with the following.

```sh
sudo apt install apache2-utils
```

### Rate limiting

Added the following lines to `/etc/nginx/nginx.conf`
above the virtual host configs in the `http` context.
The [docs](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html)
and [blog](https://www.nginx.com/blog/rate-limiting-nginx/)
explain this well.

```
##
# Rate limiting zone
##
limit_req_zone $binary_remote_addr zone=ten:2m rate=10r/s;
```

### Set up SSL/TLS

```sh
# install certbot
sudo apt install certbot python-certbot-nginx
# setup certificates
sudo certbot --nginx
# enable timer which checks certificates twice daily and renews when needed
# timer and service installed with certbot
sudo systemctl enable certbot.timer
```

Follow the prompts and it will set everything up.
I recommend auto directing http to https.
It's almost too easy;
I should probably donate to the electronic frontier foundation.


## tiddly wiki

To get the tiddly wiki to work,
had to specify the url path in a configuration tiddler
called `$config_tiddlyweb_host.tid`.
In which, I put:

```
title: $:/config/tiddlyweb/host

$protocol$//$host$/notebook/
```

This is changed from notebook to notes when the static site is built.


## Securing the raspberry pi (i.e. make hacking more inconvenient)

### Disable password login to ssh.

[This](https://www.raspberrypi.org/documentation/remote-access/ssh/passwordless.md#copy-your-public-key-to-your-raspberry-pi)
is a useful guide on copying ssh keys to a remote server.
(Also prohibit root ssh login
and even lock the root password `passwd -l root`.)

### Port scan

From another computer, I ran:

```sh
nmap hms-headless
```

You only want 80 and 443 open for the website and 22 for ssh.
I had a nfs and rpcbind port open,
which I disabled with the following.
It is also good to check the tiddlywiki can only be accessed from localhost.

```sh
systemctl disable nfs-server
systemctl disable rpcbind.service
systemctl disable rpcbind.socket
```

### Install a firewall

Using ufw as used in [the official guide](https://www.raspberrypi.org/documentation/configuration/security.md).

```sh
sudo apt install ufw

# default action is to drop a connection
sudo ufw default deny

# allow ssh and website ports
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443

# rate limit ssh connections
sudo ufw limit ssh

# enable the firewall
sudo ufw enable
```

### Brute force mitigation

Fail2ban can be used to ban ip addresses which are suspicious, like is done
[here](https://www.digitalocean.com/community/tutorials/how-to-protect-an-nginx-server-with-fail2ban-on-ubuntu-14-04).

I have key only ssh login and ufw is rate limiting ssh,
as well as nginx rate limiting for the server.
