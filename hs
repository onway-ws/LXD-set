#!/bin/bash
. lib/part_disk
. lib/zpool_greate
. lib/host_system_inst
. lib/host_system_net
. lib/host_system_mount_vfs
. lib/host_basic_system_environment
. lib/host_grub_install
. lib/ch

PN=t1                	# zpool name
HN=t1                	# host name
WG=WG			# work group
NI=enp2s0             	# name network interface (see # cat /proc/net/dev)
TD=BIOS #[BIOS|UEFI] 	# loader type
DS1=/dev/disk/by-id/ata-WDC_WD5000AAKX-001CA0_WD-WMAYUN835784	#ID disk1
#DS2=								#ID disk2
#add Admin in new system
USERNAME=sv
PASS=1

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
host_system_net $HN $WG $NI
host_system_mount_vfs
elif [[ $1 = 3 ]]; then		# install base system in chroot 

host_basic_system_environment
host_grub_install

fi

