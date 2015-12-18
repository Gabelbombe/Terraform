#!/bin/sh

echo Creating Consul client configuration...

cp /ops/$1/upstart/consul.conf /etc/init/.

cat <<EOF >/etc/consul.d/config.json
{
  "log_level": "INFO",
  "data_dir": "/opt/consul/data",
  "ui_dir": "/opt/consul/ui",
  "client_addr": "0.0.0.0",
  "bind_addr": "0.0.0.0",
  "skip_leave_on_interrupt": true,
  "atlas_join": true,
  "atlas_infrastructure": "{{ atlas_username }}/{{ atlas_environment }}",
  "atlas_token": "{{ atlas_token }}",
  "datacenter": "{{ datacenter }}",
  "node_name": "{{ node_name }}",
  "service": {"name": "{{ service }}", "tags": ["{{ service }}", "client"]}
}
EOF