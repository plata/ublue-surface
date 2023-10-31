#!/bin/bash
rpm-ostree install waydroid
ls -lZ /usr/lib/waydroid/waydroid.py
systemctl enable waydroid-container
