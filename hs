#!/bin/bash
. lib/part_disk
. lib/zpool_greate
. lib/host_system_inst
. lib/host_system_net
. lib/host_system_mount_vfs
. lib/host_basic_system_environment
. lib/host_grub_install
. lib/ch
. lib/host_boot_loader
. lib/host_system_swap
. lib/host_system_net_brige
. lib/host_LXD

#------------------------------------------------------------------------
# ZPOOL
PN=t1                	# zpool name
TD=BIOS #[BIOS|UEFI] 	# loader type
DS1=/dev/disk/by-id/ata-WDC_WD5000AAKX-001CA0_WD-WMAYUN835784	#ID disk1
#DS2=								#ID disk2
#add Admin in new system
USERNAME=sv
PASS=1

#------------------------------------------------------------------------
# NETWORK
HN=t1                	# host name
WG=WG					# work group
NI=enp2s0             	# name network interface (see # cat /proc/net/dev)

static=yes				# static interface
# for static
n_address="10.0.0.190"			#"192.168.0.44"
n_netmask="255.255.255.0"		#"255.255.255.0"
n_network="10.0.0.0"			#"192.168.0.0"
n_broadcast="10.0.0.255"		#"192.168.0.255"
n_gateway="10.0.0.254"			#"192.168.0.1"
# dns-* options are implemented by the resolvconf package, if installed
n_nameservers="8.8.8.8 8.8.4.4" #google-dns
n_search=$WG
# bridge options
n_bridge_ports=$NI

#------------------------------------------------------------------------
# MAIN

if [[ ! $1 ]]; then   	# see ID disk
echo "set DISK-ID to var DC1 -------------------------------------------"
ls /dev/disk/by-id/*
echo "set  name network interface to var NI ----------------------------"
cat /proc/net/dev


echo "./hs 1   # part disk"
echo "./hs 2   # system preparation"

exit

elif [[ $1 = 1 ]]; then		# partitions
apt-add-repository universe
apt update
apt install -y gdisk mdadm

part_disk $DS1
# part_disk $DS2

elif [[ $1 = 2 ]]; then		# set host system

# mirror
#zpool_greate $PN $DS1 $DS2

# one disk
zpool_greate $PN $DS1

host_system_inst $PN
host_system_net 				# network setup
host_system_mount_vfs
elif [[ $1 = 3 ]]; then			# install base system in chroot 

host_basic_system_environment
host_grub_install $DS1

FN=/etc/default/grub

ch $FN "GRUB_HIDDEN_TIMEOUT=0" "#GRUB_HIDDEN_TIMEOUT=0"
ch $FN "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"" "GRUB_CMDLINE_LINUX_DEFAULT=\"swapaccount=1\""
ch $FN "#GRUB_TERMINAL=console" "GRUB_TERMINAL=console"
update-grub

host_boot_loader $DS1

ls /boot/grub/*/zfs.mod
echo FOR EXIT OF CHROOT --------------------------------------------------------------------------------
echo PRESS exit

elif [[ $1 = 4 ]]; then  

echo unmount all filesystems
mount | grep -v zfs | tac | awk '/\/mnt/ {print $3}' | xargs -i{} umount -lf {}
zpool export $PN
echo reboot your system!

elif [[ $1 = 5 ]]; then   #final step

host_system_swap $PN
apt full-upgrade -y
apt install -y ubuntu-standard

#LXD
host_system_net_brige
host_LXD

fi

echo OK! $1
