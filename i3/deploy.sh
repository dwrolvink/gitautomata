#!/bin/sh

if [ "$(id -u)" != "0" ]; then
	echo "Script has to be run as root, exiting."
	exit 1
fi

printstep(){
        BLUE='\033[0;34m'
        REEE='\033[0;31m'
        NC='\033[0m' # No Color

        ERROR=1

        if [[ $2 -eq $ERROR ]];
        then
              echo -e "${REEE} ${1} ${NC}"
        else
              echo -e "${BLUE} ${1} ${NC}"
        fi
}


#############################################
printstep "[Updating system and installing applications]"
#############################################

# Update
printstep "Updating repository"
pacman -Syuu


# System apps
pacman -S yay 				--noconfirm
pacman -S moreutils			--noconfirm

# Network drive functionality
pacman -S smbclient 			--noconfirm
pacman -S manjaro-settings-samba 	--noconfirm

# Main applications
pacman -S chromium 			--noconfirm
pacman -S pcmanfm 			--noconfirm

# Theming
pacman -S lxappearance 			--noconfirm

# For current projects (might remove again later)
pacman -S sfml				--noconfirm


#############################################
printstep "[Installing user settings]"
#############################################

# Create directories
sudo -u dorus mkdir /home/dorus/nwd
sudo -u dorus mkdir /home/dorus/std-conf

# Backup standard config files
cp   /home/dorus/.i3/config		/home/dorus/std-conf/i3-conf
cp   /home/dorus/.Xresources		/home/dorus/std-conf/.Xresources

# Copy files over
cp -f config/i3-config 		/home/dorus/.i3/config			# i3 config
cp    config/mountnwd.service 	/etc/systemd/system/mountnwd.service	# Mount network drive
cp    config/20-radeon.conf 	/etc/X11/xorg.conf.d/20-radeon.conf 	# anti tearing
cp  -f  /etc/i3status.conf 	~/.i3status.conf


# Tweaking
# Terminal settings
unalias cp
echo "VISUAL=nano; export VISUAL EDITOR=nano; export EDITOR" 	>> /home/dorus/.profile

# Terminal design
echo "URxvt.transparent: true" 					>> /home/dorus/.Xresources
echo "URxvt.shading: 20"					>> /home/dorus/.Xresources
echo "URxvt*color12: #f2db32"					>> /home/dorus/.Xresources

# Set lan: 192..." color in i3 status bar to #f2db32
cat /home/dorus/.i3status.conf | awk '{gsub(/color_good = "#[a-zA-Z0-9]{6}"/,"color_good = \"#f2db32\"")}1' | sponge /home/dorus/.i3status.conf



# Mount network drive
cp -f mountnwd.service /etc/systemd/system/mountnwd.service
systemctl enable /etc/systemd/system/mountnwd.service

#############################################

prinstep "Run 'unalias cp' as yourself, and then reboot to finish installation." 0

