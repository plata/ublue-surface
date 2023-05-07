#!/bin/bash
sed -i 's/layer-shell/layer-shell,QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192/g' /usr/lib/sddm/sddm.conf.d/plasma-wayland.conf
