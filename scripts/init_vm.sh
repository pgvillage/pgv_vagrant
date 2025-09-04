#!/bin/bash
rm -rf /etc/ssh/ssh_host_*
/usr/bin/ssh-keygen -A
mkdir -p /vagrant/.ssh ~vagrant/.ssh
chown vagrant: ~vagrant/.ssh
chmod 0700 ~vagrant/.ssh
[ -f /vagrant/.ssh/id_rsa ] || ssh-keygen -f /vagrant/.ssh/id_rsa -N ''
[ -f ~vagrant/.ssh/id_rsa ] || cp /vagrant/.ssh/id_rsa* ~vagrant/.ssh/
cat /vagrant/.ssh/id_rsa.pub >>~vagrant/.ssh/authorized_keys
chmod 0600 ~vagrant/.ssh/*
chown vagrant: ~vagrant/.ssh/*
