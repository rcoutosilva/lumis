#!/bin/sh
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
# save setup directory
SETUP_DIR="$PWD"
LUMIS_VER=10.4.0
WGET_USER=suportelumis
WGET_PASSWORD=VFeNwQQxZ238
#
echo "Downloading Lumis Portal ..."
mkdir -p /lumis/lumisportal
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-files/ "http://lumisportal.lumis.com.br/setup/$LUMIS_VER/setup-files/lumisportal_10.4.0.180427.zip"
echo "Unzipping Lumis Portal ..."
unzip "$SETUP_DIR"/setup-files/lumisportal_10.4.0.180427.zip -d /lumis/lumisportal
sed -i 's/LUMIS_DATA_PATH/\/lumis\/lumisportal\/lumisdata/g' /lumis/lumisportal/www/WEB-INF/web.xml
echo "Creating installedmodules diretory"
mkdir -p /lumis/lumisportal/lumisdata/data/installedmodules/lib/
#
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-scripts/ "http://lumisportal.lumis.com.br/setup/$LUMIS_VER/setup-scripts/setup-java8-jdk.sh"
. ./setup-scripts/setup-java8-jdk.sh
#
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-scripts/ "http://lumisportal.lumis.com.br/setup/$LUMIS_VER/setup-scripts/setup-apache24.sh"
. ./setup-scripts/setup-apache24.sh
#
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-scripts/ "http://lumisportal.lumis.com.br/setup/$LUMIS_VER/setup-scripts/setup-elastic563.sh"
. ./setup-scripts/setup-elastic563.sh
#
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-scripts/ "http://lumisportal.lumis.com.br/setup/$LUMIS_VER/setup-scripts/setup-mysql57.sh"
. ./setup-scripts/setup-mysql57.sh
#
echo "Set Lumis Portal database updates ..."
mysql -uroot -plumis lumisportal -e "update lum_Website set webRootPath='/lumis/htdocs/www';"
mysql -uroot -plumis lumisportal -e "update lum_WebsiteBaseURL set path = NULL"
mysql -uroot -plumis lumisportal -e "update lum_WebsiteBaseURL set port='80' where port='8080'"
mysql -uroot -plumis lumisportal -e "update lum_WebsiteBaseURL set port='443' where port='8443'"
mysql -uroot -plumis lumisportal -e "insert into lum_CfgEnvironmentConf(id, type, fileSystemImplementation,javaMelodyEnabled,bigDataRepositoryType,esClusterName,esConnectionAddresses,esBulkConcurrentRequests,esHttpConnectionAddresses,geolocationServiceEnabled,useUserGroupsSessionCache) values('000000000A00000000000A0000100000','DEVELOPMENT','lumis.portal.filesystem.impl.ClusterMirroredFileSystem',1,'ELASTICSEARCH_TRANSPORT_CLIENT','lumisportal-elastic','localhost:9300',10,'localhost:9200',1,1)"
#
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-scripts/ "http://lumisportal.lumis.com.br/setup/$LUMIS_VER/setup-scripts/setup-tomcat85.sh"
. ./setup-scripts/setup-tomcat85.sh
#
