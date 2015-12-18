#!/bin/sh

echo Creating Vault server configuration...

CERT_NAME=$1
CERTS_DIR=/ops/$2
SCRIPTS_DIR=/ops/$3
VAULT_DIR=/usr/local/etc
BASHRCPATH=~/.bashrc

cp $CERTS_DIR/$CERT_NAME.crt $VAULT_DIR/.
cp $CERTS_DIR/$CERT_NAME.key $VAULT_DIR/.

echo Adding cert to system...
cp $CERTS_DIR/$CERT_NAME.crt /usr/local/share/ca-certificates/.
update-ca-certificates

echo Adding cert env var to be referenced by -ca-cert in Vault commands...
sh -c echo -e "\n" >> $BASHRCPATH
echo "export VAULT_CA_CERT=$VAULT_DIR/$CERT_NAME.crt" | tee -a $BASHRCPATH

cp $SCRIPTS_DIR/upstart/vault.conf /etc/init/.

# http://vaultproject.io/docs/config/
cat <<EOF >/etc/vault.d/vault_config.hcl
backend "consul" {
  path = "vault"
  address = "127.0.0.1:8500"
  advertise_addr = "http://{{ node_name }}"
}
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "$VAULT_DIR/$CERT_NAME.crt"
  tls_key_file = "$VAULT_DIR/$CERT_NAME.key"
}
EOF