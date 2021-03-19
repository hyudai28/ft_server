service mysql start
#stopを挟むとイケるらしい、、、要審議
#service php7.3-fpm stop
service php7.3-fpm start
service nginx start

tail -f /dev/null

