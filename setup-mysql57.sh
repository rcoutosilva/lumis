#!/bin/sh
echo "Install mysql 5.7 client and server ..."
yum install mysql57 -y
yum install mysql57-server -y
sed -i '/\[mysqld\]/a character-set-server=utf8\nsql_mode=STRICT_TRANS_TABLES\nmax_allowed_packet=128M' /etc/my.cnf
service mysqld start
chkconfig mysqld on
mysqladmin -u root password lumis
#
echo "Preparar lumis configurações"
#remover as linhas 36 e depois 29 para habilitar as configurações padrão de mysql
sed -i 36d /lumis/lumisportal/lumisdata/config/lumishibernate.cfg.xml
sed -i 29d /lumis/lumisportal/lumisdata/config/lumishibernate.cfg.xml
#
echo "criando o banco de dados e tabelas do lumis portal ... "
mysql -u root -plumis -e 'create database lumisportal'
mysql -u root -plumis lumisportal < /lumis/lumisportal/setup/db_mysql.sql
#
echo "Preparar as tabelas com dados padrão do Lumis Portal"
wget -P "$SETUP_DIR"/setup-files https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.12.tar.gz
mkdir "$SETUP_DIR"/setup-files/mysqldriver
tar -zxf "$SETUP_DIR"/setup-files/mysql-connector-java-8.0.12.tar.gz -C "$SETUP_DIR"/setup-files
cp "$SETUP_DIR"/setup-files/mysql-connector-java-8.0.12/mysql-connector-java-8.0.12.jar /lumis/lumisportal/www/WEB-INF/lib/.
chmod +x /lumis/lumisportal/setup/initializeportal.sh
cd /lumis/lumisportal/setup/
/lumis/lumisportal/setup/initializeportal.sh
cd "$SETUP_DIR"/
mysql -uroot -plumis lumisportal -e "update lum_Website set webRootPath='/lumis/htdocs/www';"
mysql -uroot -plumis lumisportal -e "update lum_WebsiteBaseURL set path = NULL"
mysql -uroot -plumis lumisportal -e "update lum_WebsiteBaseURL set port='80' where port='8080'"
mysql -uroot -plumis lumisportal -e "update lum_WebsiteBaseURL set port='443' where port='8443'"
mysql -uroot -plumis lumisportal -e "insert into lum_CfgEnvironmentConf(id, type, fileSystemImplementation,javaMelodyEnabled,bigDataRepositoryType,esClusterName,esConnectionAddresses,esBulkConcurrentRequests,esHttpConnectionAddresses,geolocationServiceEnabled,useUserGroupsSessionCache) values('000000000A00000000000A0000100000','DEVELOPMENT','lumis.portal.filesystem.impl.ClusterMirroredFileSystem',1,'ELASTICSEARCH_TRANSPORT_CLIENT','lumisportal-elastic','localhost:9300',10,'localhost:9200',1,1)"
#
