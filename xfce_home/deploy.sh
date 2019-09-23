#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	su
fi

# Get script config
. ./config.sh
# Get helper functions
. ../_functions.sh


#############################################
printstep "[Updating system and installing applications]"
#############################################

# Update
# ---------------------------------------------------
# Manjaro pacman fix
	sudo pacman -S archlinux-keyring manjaro-keyring
	sudo pacman-key --populate archlinux manjaro
	sudo pacman-key --refresh-keys
# Update manjaro
printstep "Updating repository"
pacman -Syuu

# System apps
# ---------------------------------------------------
# Install AUR packages\
pacman -S 		yay 			--noconfirm --needed
# Misc shell functions (for sponge mostly)
pacman -S 		moreutils		--noconfirm --needed
# Check keyboard and mouse commands
pacman -S 		xev				--noconfirm --needed

# SSH
# ---------------------------------------------------
# SSH is only turned on by default for VM's
pacman -S openssh				--noconfirm --needed

if [ "$MACHINE_TYPE"=="VM" ];
then
	sudo systemctl enable sshd
	sudo systemctl start sshd
fi

# Main applications
# ---------------------------------------------------
# Browsers
#pacman -S 		chromium 		--noconfirm --needed
pacman -S 		firefox 		--noconfirm --needed
# Audio
#sudo -u $USER 	yay 	spotify		--noconfirm --needed

# Folder browsing	
#pacman -S 		pcmanfm 		--noconfirm --needed

# Editors
pacman -S 		code			--noconfirm --needed


# Keybinding
# ---------------------------------------------------
# i3 already has keybinding in ~/user/.i3/config, but to use special keycombinations, we need xbindkeys
#pacman -S		xbindkeys			--noconfirm --needed

#############################################
printstep "[Installing user settings]"
#############################################

# Create directories
# ---------------------------------------------------
# Place to backup standard config files
sudo -u $USER mkdir /home/${USER}/std-conf
# Place for custom configurations
sudo -u $USER mkdir /home/${USER}/.config/custom
# Place for Wallpapers
sudo -u $USER mkdir /home/${USER}/Pictures/Wallpapers

# Backup standard config files
# ---------------------------------------------------
cp   /home/${USER}/.Xresources		/home/${USER}/std-conf/.Xresources

# Copy files over
# ---------------------------------------------------
cp -f src/wallpaper.jpg			/home/${USER}/Pictures/Wallpapers/  # wallpaper

# Tweaking
# ---------------------------------------------------

# Remove cp safety
# sudo -u $USER unalias cp # doesn't work!

# Set Nano as standard editor
echo "VISUAL=nano; export VISUAL EDITOR=nano; export EDITOR" 	>> /home/${USER}/.profile

# Terminal design
echo "URxvt.transparent: true" 					>> /home/${USER}/.Xresources
echo "URxvt.shading: 20"						>> /home/${USER}/.Xresources
echo "URxvt*color12: #f2db32"					>> /home/${USER}/.Xresources


# Modules
# ---------------------------------------------------
cd modules/NetworkDrive
. ./NetworkDrive.sh


