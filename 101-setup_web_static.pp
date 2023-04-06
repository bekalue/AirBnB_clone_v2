#!/usr/bin/puppet apply
# Redone the task #0 but by using Puppet

$file = "<!DOCTYPE html>
<html lang=\"en\">
	<head>
		<meta charset=\"UTF-8\">
		<title>AirBnB clone - Web static</title>
	</head>
	<body>
		<h1>AirBnB clone - Web static</h1>
	</body>
</html>"

$config = "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By \$HOSTNAME;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    error_page 404 /404.html;
    location = /404.html {
        root /var/www/error/;
        internal;
    }

    location /hbnb_static/ {
        alias /data/web_static/current/;
        index index.html;
    }

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
}
"

exec { 'apt-get update':
  path => '/usr/bin/:/usr/local/bin/:/bin/'
}

-> package { 'nginx':
  ensure   => 'present',
  provider => 'apt'
}

-> file { '/data':
  ensure  => 'directory'
}

-> file { '/data/web_static':
  ensure => 'directory'
}

-> file { '/data/web_static/releases':
  ensure => 'directory'
}

-> file { '/data/web_static/releases/test':
  ensure => 'directory'
}

-> file { '/data/web_static/shared':
  ensure => 'directory'
}

-> file { '/data/web_static/releases/test/index.html':
  ensure  => 'present',
  content => "this webpage is found in data/web_static/releases/test/index.htm \n"
}

-> file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test'
}

-> exec { 'chown -R ubuntu:ubuntu /data/':
  path => '/usr/bin/:/usr/local/bin/:/bin/'
}

file { '/var/www':
  ensure => 'directory'
}

-> file { '/var/www/html':
  ensure => 'directory'
}

-> file { '/var/www/html/index.html':
  ensure  => 'present',
  content => $file
}

-> file { '/var/www/error':
  ensure => 'directory'
}

-> file { '/var/www/error/404.html':
  ensure  => 'present',
  content => "Ceci n'est pas une page\n"
}

-> file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $config
}

-> exec { 'nginx restart':
  path => '/etc/init.d/'
}

