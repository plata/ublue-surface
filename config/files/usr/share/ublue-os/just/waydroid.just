# vim: set ft=make :

# Quickly initialize a Waydroid image
init-waydroid:
  #!/usr/bin/env bash
  sudo waydroid init -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'

# Remove all Waydroid-related files in your user folders
reset-waydroid:
  bash -c 'sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid'
