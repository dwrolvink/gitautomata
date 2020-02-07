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
	sudo pacman -S archlinux-keyring manjaro-keyring --noconfirm
	sudo pacman-key --populate archlinux manjaro     
	sudo pacman-key --refresh-keys                   
# Update manjaro
printstep "Updating repository"
pacman -Syuu

# System apps
# ---------------------------------------------------
# Install AUR packages\
pacman -S 		yay 			--noconfirm --needed
# Misc shell functions
pacman -S 		moreutils		--noconfirm --needed
pacman -S		xclip			--noconfirm --needed
# Check keyboard and mouse commands
pacman -S 		xev			--noconfirm --needed
# Utilities
pacman -S		flameshot		--noconfirm --needed # screenshots
pacman -S		redshift		--noconfirm --needed # f.lux for linux

vv# SSH
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

# Folder browsing	
pacman -S 		pcmanfm 		--noconfirm --needed

# Editors
pacman -S 		code			--noconfirm --needed


if [ "$MACHINE_TYPE"=="BARE_METAL" ];
then
	sudo -u $USER 	yay 	spotify		--noconfirm --needed
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
# Redshift custom config
sudo -u $USER mkdir /home/${USER}/.config/redshift

# Backup standard config files
# ---------------------------------------------------
cp   /home/${USER}/.i3/config		/home/${USER}/std-conf/i3-conf
cp   /home/${USER}/.Xresources		/home/${USER}/std-conf/.Xresources

# Copy files over
# ---------------------------------------------------
cp -f config/i3-config 			/home/${USER}/.i3/config		# i3 config
cp -f config/.vimrc 			/home/${USER}/.vimrc		
cp -f /etc/i3status.conf 		/home/${USER}/.i3status.conf		# Set user version of i3 status bar config
cp -f config/.xbindkeysrc		/home/${USER}/.xbindkeysrc		# xbindkeys config
cp -f config/redshift.conf		/home/${USER}/.config/redshift/redshift.conf
cp -f src/wallpaper.jpg			/home/${USER}/Pictures/Wallpapers/  	# wallpaper

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
unalias cp 

# Set Nano as standard editor
echo "VISUAL=nano; export VISUAL EDITOR=nano; export EDITOR" 	>> /home/${USER}/.profile

# Terminal design
echo "URxvt.transparent: true" 					>> /home/${USER}/.Xresources
echo "URxvt.shading: 20"					>> /home/${USER}/.Xresources
echo "URxvt*color12: #f2db32"					>> /home/${USER}/.Xresources

# Append to .xinitrc
echo "sxhkd -f 100 &"						>> /home/${USER}/.xinitrc

# Set lan: 192..." color in i3 status bar to #f2db32
cat /home/${USER}/.i3status.conf | awk '{gsub(/color_good = "#[a-zA-Z0-9]{6}"/,"color_good = \"#f2db32\"")}1' | sponge /home/${USER}/.i3status.conf


# Modules
# ---------------------------------------------------
cd modules/NetworkDrive
. ./NetworkDrive.sh


# ---------------------------------------------------

# Restart i3
sudo -u $USER i3 restart

# Set wallpaper 
sudo -u $USER nitrogen /home/${USER}/Pictures/Wallpapers
