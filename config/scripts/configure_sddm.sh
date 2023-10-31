#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

sed -i 's/layer-shell/layer-shell,QT_FONT_DPI=144/g' /usr/lib/sddm/sddm.conf.d/plasma-wayland.conf
