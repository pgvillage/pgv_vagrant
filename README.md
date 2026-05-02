# pgv_vagrant

Running a demo environment of pgvillage on your laptop using vagrant

## Getting started

1. Install vagrant and virtualbox
2. (only once) [Create the vagrant box](./README-custom-box.md)
3. Set proper box in Vagrantfile (e.a. nibble/rocky-9 of nibble/suse-16), and set proper installtion script
3. Start all your vm's `vagrant up`
4. Log in to ansible host `vagrant ssh ansible` and deploy `cd ~/git/pgvillage/ && ansible-playbook -i environments/cluster1/ functional-all.yml`
5. Be amazed

## Mac m1+ users

If you are a MacOS user with m1, m2, m3, etc. that is no issue. [README-custom-box.md](./README-custom-box.md) works for amd64 and aarch,
and for EL (we based on Rocky linux) and Suse (we based on openSuse).

## DNS

we just seed our hosts into /etc/hosts
