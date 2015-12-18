#!/usr/bin/env bash
set -e

cd /tmp

echo Fetching Vault...
curl -L $1 > vault.zip

echo Installing Vault...
unzip vault.zip
mv vault /usr/local/bin/.
chmod 0755 /usr/local/bin/vault
chown root:root /usr/local/bin/vault

echo Configuring Vault...
mkdir -p /etc/vault.d
chmod -R 777 /etc/vault.d