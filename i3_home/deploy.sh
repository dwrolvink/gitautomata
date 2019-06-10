#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	echo "Script has to be run as root, exiting."
	exit 1
fi

# Get script config
. config.sh
# Get helper functions
. ../_functions.sh


#############################################
printstep "[Updating system and installing applications]"
#############################################

# Update
printstep "Updating repository"
pacman -Syuu

# System apps
# ---------------------------------------------------
# Install AUR packages
pacman -S 		yay 			--noconfirm
# Misc shell functions (for sponge mostly)
pacman -S 		moreutils		--noconfirm

# Main applications
# ---------------------------------------------------
# Browsers
pacman -S 		chromium 		--noconfirm
pacman -S 		firefox 		--noconfirm
# Audio
sudo -u $USER 	yay 	spotify		
# Folder browsing	
pacman -S 		pcmanfm 		--noconfirm
# Editors
pacman -S 		code			--noconfirm
# Virtualization
pacman -S 		virtualbox		

# Theming
# ---------------------------------------------------
# Theme editor for Manjaro
pacman -S 		lxappearance 		--noconfirm

# Keybinding
# ---------------------------------------------------
# i3 already has keybinding in ~/user/.i3/config, but to use special keycombinations, we need xbindkeys
pacman -S		xbindkeys			--noconfirm

#############################################
printstep "[Installing user settings]"
#############################################

# Create directories
# ---------------------------------------------------
# Place to backup standard config files
sudo -u $USER mkdir /home/${USER}/std-conf
# Place for custom configurations
sudo -u $USER mkdir /home/${USER}/.config/custom

# Backup standard config files
# ---------------------------------------------------
cp   /home/${USER}/.i3/config		/home/${USER}/std-conf/i3-conf
cp   /home/${USER}/.Xresources		/home/${USER}/std-conf/.Xresources

# Copy files over
# ---------------------------------------------------
cp -f config/i3-config 			/home/${USER}/.i3/config			# i3 config
cp -f /etc/i3status.conf 		/home/${USER}/.i3status.conf		# Set user version of i3 status bar config
cp -f config/.xbindkeysrc		/home/${USER}/.xbindkeysrc			# xbindkeys config

if [ "$MACHINE_TYPE"=="BARE_METAL" ];
then
	cp    config/20-radeon.conf 	/etc/X11/xorg.conf.d/20-radeon.conf 	# anti tearing
fi

# Tweaking
# ---------------------------------------------------
# Remove cp safety
sudo -u $USER unalias cp

# Set Nano as standard editor
echo "VISUAL=nano; export VISUAL EDITOR=nano; export EDITOR" 	>> /home/${USER}/.profile

# Terminal design
echo "URxvt.transparent: true" 					>> /home/${USER}/.Xresources
echo "URxvt.shading: 20"						>> /home/${USER}/.Xresources
echo "URxvt*color12: #f2db32"					>> /home/${USER}/.Xresources

# Set lan: 192..." color in i3 status bar to #f2db32
cat /home/${USER}/.i3status.conf | awk '{gsub(/color_good = "#[a-zA-Z0-9]{6}"/,"color_good = \"#f2db32\"")}1' | sponge /home/${USER}/.i3status.conf


# Modules
# ---------------------------------------------------
cd modules/NetworkDrive
. NetworkDrive.sh

cd ..
cd modules/Russian
. Russian.sh

