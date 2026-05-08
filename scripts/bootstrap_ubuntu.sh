#!/bin/bash
set -e

echo Setup git
ssh-keyscan -H github.com >>~/.ssh/known_hosts
sudo apt-get update -y && sudo apt-get install -y git apt pkg-config libssl-dev jq
if [ ! -d ~/git/pgvillage ]; then
	mkdir -p ~/git && cd ~/git && git clone https://github.com/pgvillage/pgvillage && cd pgvillage && ln -s /vagrant/environments .
fi

cd

sudo apt-get install -y python3-pip libffi-dev python3-virtualenv
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
. ~/.bashrc
if ! [ -e ~/venv ]; then
	mkdir ~/venv
	virtualenv ~/venv
	. ~/venv/bin/activate
	echo . ~/venv/bin/activate >>~/.bashrc
fi

source ~/.bashrc

echo Install ansible
pip3 install --upgrade pip ansible
ansible-galaxy role install --role-file ~/git/pgvillage/requirements.yml
ansible-galaxy collection install --requirements-file ~/git/pgvillage/requirements.yml
pip3 install -r ~/venv/lib/python3*/site-packages/ansible_collections/azure/azcollection/requirements.txt

echo Setup ssh localhost
[ -f ~/.ssh/id_rsa.pub ] || ssh-keygen -q -f ~/.ssh/id_rsa -P ""
grep -q "$USER@$HOSTNAME" ~/.ssh/authorized_keys || cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
ssh-keygen -H -F localhost >/dev/null || ssh-keyscan -H localhost >>~/.ssh/known_hosts

which ansible-playbook >/dev/null || echo 'Please reload your profile to have ansible-playbook in your path (probably logout/login or `source ~/.bashrc`)'
