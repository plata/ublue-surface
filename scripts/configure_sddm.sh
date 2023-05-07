#!/bin/bash
sed -i 's/layer-shell/layer-shell,QT_FONT_DPI=144/g' /usr/lib/sddm/sddm.conf.d/plasma-wayland.conf
