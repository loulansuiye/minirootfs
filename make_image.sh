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

if [ -e "/.dockerenv" ]; then
	SUDO=
else
	SUDO=sudo
fi

rm -rf rootfs.*

mkdir -p tmpfs
dd if=/dev/zero of=$IMAGE bs=1M count=32
mkfs.$FSTYPE -F $IMAGE
$SUDO mount -t $FSTYPE -o loop $IMAGE ./tmpfs

$SUDO cp -r submodule/busybox/output/_install/* tmpfs/
$SUDO mkdir tmpfs/dev
$SUDO mknod tmpfs/dev/console c 5 1
$SUDO mknod tmpfs/dev/tty2 c 4 2
$SUDO mknod tmpfs/dev/tty3 c 4 3
$SUDO mknod tmpfs/dev/tty4 c 4 4
$SUDO cp -r rootfs/*  tmpfs/

$SUDO umount tmpfs
rm -rf tmpfs
