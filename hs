#!/bin/bash
. lib/part_disk
. lib/zpool_create
. lib/host_system_inst
. lib/host_system_net
. lib/host_system_mount_vfs

PN=t1                	# zpool name
HN=t1                	# host name
WG=WG			# work group
NI=enp2s0             	# name network interface (see # cat /proc/net/dev)
TD=BIOS #[BIOS|UEFI] 	# loader type
DS1=/dev/disk/by-id/ata-WDC_WD5000AAKX-001CA0_WD-WMAYUN835784	#ID disk1
#DS2=								#ID disk2

if [[ $1 = 1 ]]; then   	# see ID disk
apt-add-repository universe
apt update
apt install -y gdisk mdadm
echo "set DISK-ID to var DC1 -------------------------------------------"
ls /dev/disk/by-id/*
echo "set  name network interface to var NI ----------------------------"
cat /proc/net/dev
exit

elif [[ $1 = 2 ]]; then		# partitions

part_disk $M1
ls /dev/disk/by-id/*

elif [[ $1 = 3 ]]; then		# set host system

# mirror
#zpool_greate $PN $DS1 $DS2

# one disk
zpool_greate $PN $DS1

host_system_inst $PN
host_system_net $HN $WG $NI
host_system_mount_vfs
fi

