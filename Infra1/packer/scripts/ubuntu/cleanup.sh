#!/bin/sh

echo Cleanup...
apt-get -y autoremove
apt-get -y clean

# Remove temporary files
rm -rf /tmp/*

# Remove ops directory
rm -rf /ops