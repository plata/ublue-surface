#!/bin/bash
cd /tmp
curl -o convergentwindows-v1.0.tar.gz https://invent.kde.org/plata/convergentwindows/-/archive/v1.0/convergentwindows-v1.0.tar.gz
tar -xf convergentwindows-v1.0.tar.gz
mv convergentwindows-v1.0 /usr/share/kwin/scripts/convergentwindows
