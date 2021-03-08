#!/bin/bash

useage()
{
	echo "[useage]: $0 <ext2/ext3/ext4>"
}

if [ ! $1 ]; then
	useage
	exit
fi

FSTYPE=$1
IMAGE=rootfs.$FSTYPE

rm -rf rootfs.*

mkdir -p tmpfs
dd if=/dev/zero of=$IMAGE bs=1M count=32
mkfs.$FSTYPE -F $IMAGE
sudo mount -t $FSTYPE -o loop $IMAGE ./tmpfs

sudo cp -r submodule/busybox/output/_install/* tmpfs/
sudo mkdir tmpfs/dev
sudo mknod tmpfs/dev/console c 5 1
sudo mknod tmpfs/dev/tty2 c 4 2
sudo mknod tmpfs/dev/tty3 c 4 3
sudo mknod tmpfs/dev/tty4 c 4 4
sudo cp -r rootfs/*  tmpfs/

sudo umount tmpfs
rm -rf tmpfs
