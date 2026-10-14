#Website setup
1. composer install
2. php artisan key:generate
3. Config the .env
4. php artisan migrate
5. php artisan db:seed (maybe - in development)
6. php artisan storage:link
7. Config cronjob for online user chart
    1. Install crontab
    2. crontab -e
    3. * * * * * /usr/bin/php /home/gogun/newweb/artisan schedule:run >> /dev/null 2>&1
    4. wq!

Pre-requirements
1. PHP 7.4.20+
2. php_sqlsrv & php_pdo_sqlsrv module
3. php_memcached

Default admin panel<br>
Route: /admin<br>
Username/password: admin@gmail.com/password

#Install Server on Centos 7
1. Install httpd, php 7.4.20+
    - yum install httpd -y
    - yum install epel-release yum-utils -y
    - yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
    - yum-config-manager --enable remi-php74
    - yum update -y
    - yum install php
    - systemctl start httpd
    - systemctl enable httpd
2. Install mod_ssl, memcached, php-memcached, php-soap
    - yum install memcached libmemcached libmemcached-devel -y
    - systemctl start memcached
    - systemctl enable memcached
    - yum install mod_ssl -y
    - curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
    - ACCEPT_EULA=Y yum install -y msodbcsql17
    - yum install php74-php-sqlsrv -y
    - yum install php-soap php-memcached -y
3. Install git, composer, deploy website
    - yum install git -y
    - yum install composer -y
    - mkdir /home/gogun & cd /home/gogun
    - git clone git@bitbucket.org:gun2021/newweb.git
    - cd newweb
    - composer install
    - cp .env.example .env
    - php artisan key:generate
    
4. Config httpd

```
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/home/gogun/newweb/public"
    ServerName gogun.vn
    ErrorLog "/var/log/gogun/error.log"
    LogFormat "%a %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" logwithproxy
    CustomLog "/var/log/gogun/new_access.log" logwithproxy
    <Directory "/home/gogun/newweb/public">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    <IfModule mod_remoteip.c>
            RemoteIPHeader X-Forwarded-For
            RemoteIPTrustedProxy 61.14.232.89
    </IfModule>
</VirtualHost>
```

5. Install certbot to use let encrypt
    - yum install snapd
    - systemctl enable --now snapd.socket
    - ln -s /var/lib/snapd/snap /snap
    - snap install core; sudo snap refresh core
    - snap install --classic certbot
    - ln -s /snap/bin/certbot /usr/bin/certbot
    - certbot --apache

6. Install CSF for security
    - yum install wget
    - wget https://download.configserver.com/csf.tgz
    - tar -xzf csf.tgz
    - cd csf
    - sh install.sh
    - vi /etc/csf/csf.conf
        - TCP_IN = "22,80,443,1433,465"
        - TCP_OUT = "22,80,443,1433,465"
        - LF_IPSET = "1"
        - CONNLIMIT = "80;20,443;20"
        - PORTFLOOD = "80;tcp;20;300,443;tcp;20;300"
        - CC_ALLOW = "VN"
