#!/bin/bash
. lib/part_disk
. lib/zpool_create
. lib/host_system_inst

PN=t1                # zpool name
HN=t1                # host name
TD=BIOS #[BIOS|UEFI] # loader type
DS1=/dev/disk/by-id/ata-WDC_WD5000AAKX-001CA0_WD-WMAYUN835784    #ID disk1
#DS2=								#ID disk2

if [[ $1 = 1 ]]; then   	# see ID disk
apt-add-repository universe
apt update
apt install -y gdisk mdadm
ls /dev/disk/by-id/*
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


fi

