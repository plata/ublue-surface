#!/bin/bash
#rpm-ostree cliwrap install-to-root /
sudo wget -O /etc/yum.repos.d/linux-surface.repo \
          https://pkg.surfacelinux.com/fedora/linux-surface.repo
cd /tmp
mkdir surface-linux
cd surface-linux
wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm
rpm-ostree override replace ./*.rpm \
           --remove kernel-core \
           --remove kernel-devel-matched \
           --remove kernel-modules \
           --remove kernel-modules-extra \
           --remove libwacom \
           --remove libwacom-data \
           --install kernel-surface \
           --install iptsd \
           --install libwacom-surface \
           --install libwacom-surface-data
rpm-ostree install surface-secureboot
