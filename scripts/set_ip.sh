#!/bin/bash
set -e

MYIP=${1}
echo "Configuring static IP ${MYIP} on enp0s9..."

nmcli con delete static-private || true
nmcli con add type ethernet con-name static-private ifname enp0s9 ip4 ${MYIP}/24 gw4 172.30.1.1
nmcli con mod static-private connection.autoconnect yes
nmcli con up static-private
