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

RUN mkdir -p /var/www/html/wordpress \
    && mkdir -p /var/www/html/phpmyadmin

#–no-check-certificateで証明書の確認を行わない（wgetでダウンロード先がHTTPSの時にエラーが出てしまうのでその回避）
#-Cで展開先を指定する。
RUN wget --no-check-certificate https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz -C /var/www/html/wordpress \
    && rm latest.tar.gz

RUN wget --no-check-certificate https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz \
    && tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz -C /var/www/html/phpmyadmin \
    && rm phpMyAdmin-5.0.2-all-languages.tar.gz
