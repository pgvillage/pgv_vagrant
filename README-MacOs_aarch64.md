# using virtualbox on MacOs with aarch64

## Installation

Is easy. Just install:

1. install virtualbox
2. install vagrant

## Box

There is no good box for VirtualBox/EL9/aarch64.
Best I could find is bento/rockylinux-9, but it has no guest tools.
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
13. Clean history `history -d`
14. Best is to again start the vm, as virtual box will finish initialization of the guest additions. `vagrant halt && vagrant up`
15. Stop the vm again `vagrant halt`
16. Package the box `vagrant package --output "nibble-rocky-9.box"`
17. Add the box to the local registry `vagrant box add nibble-rocky-9.box --name nibble/rocky-9`
