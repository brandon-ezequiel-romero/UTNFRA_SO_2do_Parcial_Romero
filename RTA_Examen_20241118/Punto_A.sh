#!/bin/bash

echo "Particionando disco /dev/sdc"
echo

sudo fdisk /dev/sdc << EOF
n
p
1

+1.5G
n
p
2

+400M
t
1
8e
t
2
8e
w
EOF
echo
echo "Particionando disco /dev/sde"
echo

sudo fdisk /dev/sde << EOF
n
p


+512M
w
EOF
echo

sudo wipefs -a /dev/sdc1
sudo wipefs -a /dev/sdc2
sudo wipefs -a /dev/sde1

sudo pvcreate /dev/sdc1 /dev/sdc2 /dev/sde1

sudo vgcreate vg_datos /dev/sdc1 /dev/sdc2
sudo vgcreate vg_temp /dev/sde1

sudo lvcreate -L 400M vg_datos -n lv_docker
sudo lvcreate -L 1.49G vg_datos -n lv_workareas
sudo lvcreate -L 508M vg_temp -n lv_swap

sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkfs.ext4 /dev/mapper/vg_temp-lv_swap

sudo mkswap /dev/mapper/vg_temp-lv_swap
sudo mkdir /work
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work

sudo swapon /dev/mapper/vg_temp-lv_swap

echo "/dev/mapper/vg_datos-lv_docker/ /var/lib/docker/ ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas/ /work/ ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_temp-lv_swap/ none swap sw 0 0" | sudo tee -a /etc/fstab
