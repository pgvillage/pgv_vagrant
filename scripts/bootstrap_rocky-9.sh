#!/bin/bash
set -e

echo Setup git
ssh-keyscan -H github.com >>~/.ssh/known_hosts
sudo dnf install -y git pkg-config openssl-devel
if [ ! -d ~/git/pgvillage ]; then
	mkdir -p ~/git && cd ~/git && git clone https://github.com/pgvillage/pgvillage && cd pgvillage && ln -s /vagrant/environments .
fi

echo Install rust
if ! rustup update; then
	cd "$(mktemp -d)"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >sh.rustup.rs
	bash ./sh.rustup.rs -y
	export PATH=$HOME/.cargo/bin:$PATH
fi

cd

echo Install python3
# For more info, see https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
sudo dnf install -y python3-pip libffi-devel
pip3 install virtualenv
. ~/.bashrc
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
if ! [ -e ~/venv ]; then
	mkdir ~/venv
	virtualenv ~/venv
	. ~/venv/bin/activate
	echo . ~/venv/bin/activate >>~/.bashrc
fi

echo Install ansible
pip3 install --upgrade pip ansible #--upgrade cryptography packaging netaddr msgraph-sdk

echo Install chainsmith
pip3 install --upgrade chainsmith

echo Setup ssh localhost
[ -f ~/.ssh/id_rsa.pub ] || ssh-keygen -q -f ~/.ssh/id_rsa -P ""
grep -q "$USER@$HOSTNAME" ~/.ssh/authorized_keys || cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
ssh-keygen -H -F localhost >/dev/null || ssh-keyscan -H localhost >>~/.ssh/known_hosts

which ansible-playbook >/dev/null || echo 'Please reload your profile to have ansible-playbook in your path (probably logout/login or `source ~/.profile`)'
