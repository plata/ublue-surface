#!/bin/bash

sudo wget -O /etc/yum.repos.d/linux-surface.repo \
          https://pkg.surfacelinux.com/fedora/linux-surface.repo
rpm-ostree cliwrap install-to-root / && \
rpm-ostree override replace https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm
rpm-ostree install surface-secureboot
