#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	echo "Script has to be run as root, exiting."
	exit 1
fi

# Get script config
. ./config.sh
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
pacman -S 		chromium 		--noconfirm --needed
pacman -S 		firefox 		--noconfirm --needed
# Audio
sudo -u $USER 	yay 	spotify		--noconfirm --needed
# Folder browsing	
pacman -S 		pcmanfm 		--noconfirm --needed
# Editors
pacman -S 		code			--noconfirm --needed
# Virtualization
if [ "$MACHINE_TYPE"=="BARE_METAL" ];
then
	pacman -S 		virtualbox		--noconfirm --needed
fi

# Theming
# ---------------------------------------------------
# Theme editor for Manjaro
pacman -S 		lxappearance 		--noconfirm --needed

# Keybinding
# ---------------------------------------------------
# i3 already has keybinding in ~/user/.i3/config, but to use special keycombinations, we need xbindkeys
pacman -S		xbindkeys			--noconfirm --needed

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
cp   /home/${USER}/.i3/config		/home/${USER}/std-conf/i3-conf
cp   /home/${USER}/.Xresources		/home/${USER}/std-conf/.Xresources

# Copy files over
# ---------------------------------------------------
cp -f config/i3-config 			/home/${USER}/.i3/config			# i3 config
cp -f /etc/i3status.conf 		/home/${USER}/.i3status.conf		# Set user version of i3 status bar config
cp -f config/.xbindkeysrc		/home/${USER}/.xbindkeysrc			# xbindkeys config
cp -f src/wallpaper.jpg			/home/${USER}/Pictures/Wallpapers/  # wallpaper

if [ "$MACHINE_TYPE"=="BARE_METAL" ];
then
	cp    config/20-radeon.conf 	/etc/X11/xorg.conf.d/20-radeon.conf 	# anti tearing
fi

# Tweaking
# ---------------------------------------------------
# Set i3 modkey
if [ "$MODKEY"=="SUPER" ];
then
	echo 'Super'
	sed -i "s+{{MODKEY}}+Mod4+g" 				/home/${USER}/.i3/config # super
else
	echo 'Alt'
	sed -i "s+{{MODKEY}}+Mod1+g" 				/home/${USER}/.i3/config # alt
fi

# Remove cp safety
# sudo -u $USER unalias cp # doesn't work!

# Set Nano as standard editor
echo "VISUAL=nano; export VISUAL EDITOR=nano; export EDITOR" 	>> /home/${USER}/.profile

# Terminal design
echo "URxvt.transparent: true" 					>> /home/${USER}/.Xresources
echo "URxvt.shading: 20"						>> /home/${USER}/.Xresources
echo "URxvt*color12: #f2db32"					>> /home/${USER}/.Xresources

# Set lan: 192..." color in i3 status bar to #f2db32
cat /home/${USER}/.i3status.conf | awk '{gsub(/color_good = "#[a-zA-Z0-9]{6}"/,"color_good = \"#f2db32\"")}1' | sponge /home/${USER}/.i3status.conf

# Set wallpaper 
sudo -u $USER nitrogen /home/${USER}/Pictures/Wallpapers

# Modules
# ---------------------------------------------------
cd modules/NetworkDrive
. ./NetworkDrive.sh

cd ..
cd Russian
. ./Russian.sh

