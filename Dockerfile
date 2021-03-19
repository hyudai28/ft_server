FROM debian:buster

#install use function
RUN set -ex; \
    apt update \
    && apt install -y --no-install-recommends \
    nginx \
    php7.3-fpm \
    php7.3 \
    php-cgi \
    php-common \
    php-pear \
    php-mbstring \
    php-zip \
    php-net-socket \
    php-gd \
    php-xml-util \
    php-gettext \
    php-mysql \
    php-bcmath \
    mariadb-server \
    mariadb-client \
    php-mysql \
    vim \
    wget \
    openssl \
    supervisor

ENV DB_NAME=userdb \
    DB_USER=user \
    DB_PASS=password \
    DB_HOST=localhost

RUN set -ex; \
        service mysql start; \
            mysql -e "CREATE DATABASE $DB_NAME;"; \
            mysql -e "CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASS';"; \
            mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"; \
            mysql -e "FLUSH PRIVILEGES;"

#RUN set -ex; \
#    mkdir -p /var/www/html/wordpress 
#    && mkdir -p /var/www/html/phpmyadmin

#–no-check-certificateで証明書の確認を行わない（wgetでダウンロード先がHTTPSの時にエラーが出てしまうのでその回避）
#-Cで展開先を指定する。
RUN set -ex; \
    wget --no-check-certificate https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz -C /var/www/html \
    && rm latest.tar.gz \
    && chown -R www-data:www-data /var/www/html/wordpress

RUN set -ex; \
    wget --no-check-certificate https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz \
    && tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz -C /var/www/html \
    && rm phpMyAdmin-5.0.2-all-languages.tar.gz \
    && cd /var/www/html \
    && mv phpMyAdmin-5.0.2-all-languages phpmyadmin \
    && cd \
    && cd ..

#entrykitのインストール
RUN set -ex; \
    wget --no-check-certificate -O entrykit.tgz https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz \
    && tar -xvzf entrykit.tgz -C /bin\
    && rm entrykit.tgz \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

#COPY src/default.tmpl /etc/nginx/sites-available/
COPY src/default.tmpl /etc/nginx/sites-available/
#COPY src/service_start.sh /tmp
COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#ssl
RUN mkdir /etc/nginx/ssl \
    && openssl genrsa -out server.key 2048 \
    && openssl req -new -key server.key -out server.csr \
        -subj '/C=JP/ST=Tokyo/L=Tokyo/O=42tokyo/OU=Web/CN=hyudai' \
    && openssl x509 -in server.csr -days 3650 -req -signkey server.key > server.crt \
    && mv server.key server.crt server.csr /etc/nginx/ssl


#EXPOSE 80 443


#CMD tail -f /dev/null
#ENTRYPOINT ["render", "/etc/nginx/sites-available/default", "--", "bash", "/tmp/service_start.sh"]
ENTRYPOINT ["render", "/etc/nginx/sites-available/default", "--",  "/usr/bin/supervisord"]
#CMD /tmp/service_start.sh

EXPOSE 80 443
