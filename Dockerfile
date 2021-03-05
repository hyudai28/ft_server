#secelet your OS
FROM debian:buster

#install use function
RUN apt update \
    && apt install -y --no-install-recommends \
    nginx \
    php7.3-fpm \
    mariadb-server \
    php-mysql \
    vim \
    wget \
    supervisor
#–no-check-certificateで証明書の確認を行わない（wgetでダウンロード先がHTTPSの時にエラーが出てしまうのでその回避）
RUN mkdir -p /var/www/html/wordpress \
    && wget –no-check-certificate https://wordpress.org/latest.tar.gz \
    && tar -xvzf latest.tar.gz /var/www/html/wordpress \
    && rm latest.tar.gz \
#    && mkdir -p /var/www/html/phpmyadmin \
#    && wget –no-check-certificate https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz \
#    && tar -xvzf phpMyAdmin-5.0.2-all-languages.tar.gz /var/www/html/phpmyadmin \
#    && rm phpMyAdmin-5.0.2-all-languages.tar.gz \
