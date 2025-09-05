# pgv_vagrant

Running a demo environment of pgvillage on your laptop using vagrant

## Getting started

1. Install vagrant and virtualbox
2. Use the correct box in Vagrantfile
3. Start all your vm's `vagrant up`
4. Log in to ansible host `vagrant ssh ansible` and deploy `cd git/pgvillage/ && ansible-playbook -i environments/cluster1/ functional-all.yml`
5. Be amazed

## Mac m1+ users

If you are a MacOS user with m1, m2, m3, etc. please refer to [README-MacOs_aarch64.md](./README-MacOs_aarch64.md)

## DNS

we just seed our hosts into /etc/hosts
