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

grep -q ansible.local || echo '172.30.1.10 ansible ansible.local
172.30.1.20 minio.local minio
172.30.1.31 db-1.local db-1
172.30.1.32 db-2.local db-2
172.30.1.33 db-3.local db-3' >>/etc/hosts
