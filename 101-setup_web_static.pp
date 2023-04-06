#!/usr/bin/puppet apply
# Redone the task #0 but by using Puppet

# updating the sys
exec {'update':
  command => 'sudo /usr/bin/apt-get update',
  path    => '/usr/bin:/bin:/usr/sbin:/sbin',
}

# installing the nginx if not installed
package {'nginx':
  ensure  => 'installed',
  require => Exec['update'],
}

# creating folder for static files
exec {'create_folder':
  command => 'sudo mkdir -p /data/web_static/releases/test/ /data/web_static/shared',
  path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  require => Package['nginx'],
}

# changing owner of the folder
exec {'change_owner':
  command => 'sudo chown -R ubuntu:ubuntu /data/',
  path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  require => Exec['create_folder'],
}

# creating index.html
file {'/data/web_static/releases/test/index.html':
  ensure  => 'file',
  content => 'Hello World!',
  require => Exec['change_owner'],
}

# remove the symbolic link
exec {'remove_symlink':
  command => 'sudo rm -rf /data/web_static/current',
  path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  require => File['/data/web_static/releases/test/index.html'],
}

# creating symlink
exec {'create_symlink':
  command => 'sudo ln -sf /data/web_static/releases/test/ /data/web_static/current',
  path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  require => File['/data/web_static/releases/test/index.html'], Exec['remove_symlink'],
}

# creating the config folder
file { '/var/www':
  ensure  => 'directory',
  recurse => true,
  mode    => '0755',
  require => Package['nginx']
}

# default html
file { '/var/www/html/index.nginx-debian.html':
  ensure  => 'file',
  content => 'Hello World!',
  require => File['/var/www']
}

# default error page
file { '/var/www/error/404.html':
  ensure  => 'file',
  content => "Ceci n'est pas une page",
  require => File['/var/www']
}

# default config
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  mode    => '0644',
  content =>
"server {
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
}",
  require => Package['nginx'], File['/var/www/html/index.nginx-debian.html'], File['/var/www/error/404.html'], Exec['change_owner']
}

# enable site
exec { 'enable_site':
  command => 'sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default',
  path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  require => File['/etc/nginx/sites-available/default'],
}

# restart nginx
exec { 'restart_nginx':
  command => 'sudo service nginx restart',
  path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  require => Exec['enable_site'],
}
