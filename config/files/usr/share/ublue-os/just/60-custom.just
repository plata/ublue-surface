# this file is a placeholder,
# making changes here is not supported
# Include some of your custom scripts here!

# Quickly initialize a Waydroid image
init-waydroid:
    sudo waydroid init -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'

# Remove all Waydroid-related files in your user folders
reset-waydroid:
    bash -c 'sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid'
