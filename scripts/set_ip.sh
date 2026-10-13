#!/bin/bash
set -e

with_nmcli() {
  which nmcli 2>/dev/null || return 1
  MYIP=${1}
  MYIFC=${2:-"enp0s9"}
  # MYGW:=${3:-"172.30.1.1"}
  echo "Configuring static IP ${MYIP} on ${MYIFC} with nmcli..."
  
  nmcli con delete static-private || true
  nmcli con add type ethernet con-name static-private ifname "${MYIFC}" ip4 ${MYIP} # gw4 "${MYGW}"
  nmcli con mod static-private connection.autoconnect yes
  nmcli con up static-private
}

with_netplan() {
  which netplan 2>/dev/null || return 1
  MYIP=${1}
  MYIFC=${2:-"enp0s9"}
  
  # Het Netplan YAML bestand aanmaken
  cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
  network:
    version: 2
    renderer: networkd
    ethernets:
      $MYIFC:
        dhcp4: no
        addresses:
          - $MYIP
EOF
  
  sudo chmod 600 /etc/netplan/01-netcfg.yaml
  sudo netplan apply
}

with_nmcli "${1}/24" || with_netplan "${1}/24"
