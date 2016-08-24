#!/bin/bash
. lib/part_disk

TD=BIOS #[BIOS|UEFI] # loader type
M1=/dev/disk/by-id/ata-WDC_WD5000AAKX-001CA0_WD-WMAYUN835784

if [[ $1 = 1 ]]; then
apt-add-repository universe
apt-get update
apt-get install -y debootstrap gdisk zfs-initramfs mdadm
ls /dev/disk/by-id/*

return 0
elif [[ $1 = 2 ]]; then

part_disk $M1
ls /dev/disk/by-id/*
fi
