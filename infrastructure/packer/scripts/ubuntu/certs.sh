#!/bin/sh

echo Adding cert to system...
CERT_NAME=$1
CERTS_DIR=/ops/$2

cp $CERTS_DIR/$CERT_NAME /usr/local/share/ca-certificates/.
update-ca-certificates