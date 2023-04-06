#!/usr/bin/puppet apply
# Redone the task #0 but by using Puppet
exec { '/usr/bin/env apt-get -y update' : }
-> exec { '/usr/bin/env apt-get -y install nginx' : }
-> exec { '/usr/bin/env mkdir -p /data/web_static/releases/test/' : }
-> exec { '/usr/bin/env mkdir -p /data/web_static/shared/' : }
-> exec { '/usr/bin/env chown -R ubuntu:ubuntu /data/' : }
-> exec { '/usr/bin/env sed -i "/listen \[::\]:80 default_server/ a\\\trewrite ^/redirect_me https://google.com permanent;" /etc/nginx/sites-available/default' : }
-> exec { '/usr/bin/env sed -i "/listen \[::\]:80 default_server/ a\\\tadd_header X-Served-By \"\$HOSTNAME\";" \
/etc/nginx/sites-available/default' : }
-> exec { '/usr/bin/env sed -i "/redirect_me/ a\\\terror_page 404 /404.html;" /etc/nginx/sites-available/default' : }
-> exec { '/usr/bin/env mkdir -p /var/www/error/' : }
-> exec { '/usr/bin/env # echo "Ceci n\'est pas une page" > /var/www/error/404.html' : }
-> exec { '/usr/bin/env echo "Hello World!" > /data/web_static/releases/test/index.html' : }
-> exec { '/usr/bin/env ln -sf /data/web_static/releases/test/ /data/web_static/current' : }
-> exec { '/usr/bin/env sed -i "/^\tlocation \/ {$/ i\\\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\
\n\t\tautoindex off;\n}" /etc/nginx/sites-available/default' : }
-> exec { '/usr/bin/env service nginx start' : }

