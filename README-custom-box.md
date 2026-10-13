# using virtualbox on MacOs with aarch64

## Installation

Is easy. Just install:

1. install virtualbox
2. install vagrant

## Rocky Box

We use `bento/rockylinux-9`, and use procedures below to install guest tools.

So you can use this to create a new box with all you need:

1. Go to a new folder `cd $(mktemp -d)`
2. Run `vagrant init bento/rockylinux-9` ; this will create a new vagrant vm from the latest bento/rockylinux-9 box
3. Run `vagrant up` to enter the box
4. Run `vagrant ssh` to enter the box
5. In the box enter the following commands:
   ```bash
   sudo dnf update -y
   sudo dnf install epel-release -y
   sudo dnf install dkms gcc make kernel-devel bzip2 binutils patch libgomp glibc-headers glibc-devel -y
   ```
6. Run `vagrant halt` to stop the vm
7. In VirtualBox (gui) go to the VM, settings, storage and click the cdrom with the +, select VBoxGuestAdditions.iso, click Choose and click OK.
8. Start the vm again `vagrant up`
9. Run `vagrant ssh` to enter the vm again
10. Mount the cdrom `sudo mount /dev/cdrom /mnt/`
11. Run the installer `cd /mnt/ && sudo ./VBoxLinuxAdditions-arm64.run`
12. (optionally) add your modifications to motd `sudo vim /etc/motd`
13. Clean history `history -cw`
14. Best is to again start the vm, as virtual box will finish initialization of the guest additions. `vagrant halt && vagrant up`
15. Stop the vm again `vagrant halt`
16. Package the box `vagrant package --output "nibble-rocky-9.box"`
17. Add the box to the local registry `vagrant box add nibble-rocky-9.box --name nibble/rocky-9`

## Suse Box

**NOTE** That the PostgreSQL community does not have a aarch64 version of PostgreSQL for Suse

We use bento/opensuse-leap016-0, and use procedures below to install guest tools and change from network manager to wicked (as vagrant cannot use NM).

1. Go to a new folder `cd $(mktemp -d)`
2. Run `vagrant init bento/opensuse-leap-16.0` ; this will create a new vagrant vm from the latest bento/opensuse-leap-16.0 box
3. Run `vagrant up` to start the box and run `vagrant ssh` to enter the box.
4. In the box, run `sudo zypper update -y` to update the box.
5. Exit and halt the box: `vagrant halt`
6. In VirtualBox (gui) go to the VM, settings, storage and click the cdrom with the +, select VBoxGuestAdditions.iso, click Choose and click OK.
7. Start the box with `vagrant up` (it will probably finish updating packages) and login to the box with `vagrant ssh`
   The box will automtically VirtulBox Additions...
9. In the box: install required pckagesd and setup avahi so that dhcp works:
   ```bash
   sudo zypper install -y gcc make dkms kernel-default-devel patch binutils avahi
   sudo systemctl enable --now avahi-daemon
   ```
10. Grant sudo permissions to root:
    ```
    sudo bash -c 'echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
    ```
11. (optionally) add your modifications to motd `sudo vim /etc/motd`
12. Clean history `history -c && sleep 1 && history -w`
13. Stop the vm again `vagrant halt`
14. Package the box `vagrant package --output "nibble-suse-16.box"`
15. Add the box to the local registry `vagrant box add nibble-suse-16.box --name nibble/suse-16`

## Ubuntu Box

We use `cloud-image/ubuntu-26.04`,  box version `20260421.0.0`, and use procedures below to install guest tools.

1. Go to a new folder `cd $(mktemp -d)`
2. Run `vagrant init cloud-image/ubuntu-26.04 --box-version 20260421.0.0` ; this will create a new vagrant vm from the latest ubuntu-26.04 box
3. Run `vagrant up` to enter the box
4. Run `vagrant ssh` to enter the box
5. In the box enter the following commands:
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```
6. Run `vagrant halt` to stop the vm
7. In VirtualBox (gui) go to the VM, settings, storage and click the cdrom with the +, select VBoxGuestAdditions.iso, click Choose and click OK.
8. Start the vm again `vagrant up`
9. Run `vagrant ssh` to enter the vm again
10. Mount the cdrom `sudo mount /dev/cdrom /mnt/`
11. Run the installer `cd /mnt/ && sudo ./VBoxLinuxAdditions-arm64.run`
12. (optionally) add your modifications to motd `sudo vim /etc/motd`
13. Clean history `history -c && history -w`
14. Best is to again start the vm, as virtual box will finish initialization of the guest additions. `vagrant reload`
15. Stop the vm again `vagrant halt`
16. Package the box `vagrant package --output "nibble-ubuntu.box"`
17. Add the box to the local registry `vagrant box add nibble-ubuntu.box --name nibble/ubuntu-26.04`

