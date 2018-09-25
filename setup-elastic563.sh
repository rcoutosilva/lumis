#!/bin/sh
echo "Install Elasticsearch"
cd "$SETUP_DIR"/
wget -P "$SETUP_DIR"/setup-files/ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.3.rpm
rpm --install "$SETUP_DIR"/setup-files/elasticsearch-5.6.3.rpm
sed -i 's/#cluster.name: my-application/cluster.name: lumisportal-elastic/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/-Xms1g/-Xms500m/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx500m/g' /etc/elasticsearch/jvm.options
echo action.auto_create_index: \"-lumisportal-*,+*\" >> /etc/elasticsearch/elasticsearch.yml
/usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
service elasticsearch start
chkconfig elasticsearch on
