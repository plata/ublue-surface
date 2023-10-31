#!/bin/bash
rpm-ostree cliwrap install-to-root
rpm-ostree install waydroid
ls -lZ /usr/lib/waydroid/waydroid.py
systemctl enable waydroid-container
