#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

wget https://pkg.surfacelinux.com/fedora/linux-surface.repo -P /etc/yum.repos.d
wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm -O /tmp/surface-kernel.rpm
rpm-ostree cliwrap install-to-root
rpm-ostree override replace /tmp/surface-kernel.rpm \
           --remove kernel-core \
           --remove kernel-modules \
           --remove kernel-modules-extra \
           --remove libwacom \
           --remove libwacom-data \
           --install kernel-surface \
           --install iptsd \
           --install libwacom-surface \
           --install libwacom-surface-data
