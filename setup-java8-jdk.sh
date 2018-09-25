#!/bin/sh
echo "installing java 8"
wget --user $WGET_USER --password $WGET_PASSWORD -P "$SETUP_DIR"/setup-files/ "http://lumisportal.lumis.com.br/setup/setup-files/jdk-8u181-linux-x64.rpm"
rpm --install "$SETUP_DIR"/setup-files/jdk-8u181-linux-x64.rpm
sudo /usr/sbin/alternatives --set java /usr/java/jdk1.8.0_181-amd64/jre/bin/java
JAVA_HOME=/usr/java/jdk1.8.0_181-amd64/jre
