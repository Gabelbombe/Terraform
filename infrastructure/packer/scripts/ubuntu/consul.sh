#!/usr/bin/env bash
set -e

cd /tmp

echo Fetching Consul...
curl -L $1 > consul.zip

echo Installing Consul...
unzip consul.zip
mv consul /usr/local/bin/.
chmod 0755 /usr/local/bin/consul
chown root:root /usr/local/bin/consul

echo Configuring Consul...
mkdir -p /etc/consul.d
chmod -R 777 /etc/consul.d
mkdir -p /opt/consul
chmod -R 777 /opt/consul

curl -L $2 > ui.zip
unzip ui.zip
mv dist /opt/consul/ui