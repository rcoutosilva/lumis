#!/bin/sh
echo "Installing apache 2.4 ..."
yum -y install httpd24
mkdir -p /lumis/htdocs/www
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-files/ "http://lumisportal.lumis.com.br/setup/$LUMIS_VER/setup-files/lumisportal_httpd.conf"
cp "$SETUP_DIR"/setup-files/lumisportal_httpd.conf /etc/httpd/conf.d/.
chkconfig httpd on
service httpd start
echo "copiar os arquivos estaticos para www"
cp -r /lumis/lumisportal/www/lumis /lumis/htdocs/www/.
cp -r /lumis/lumisportal/www/lumis-theme /lumis/htdocs/www/.
find /lumis/htdocs/www/ -name "*.jsp" -type f -delete
#
