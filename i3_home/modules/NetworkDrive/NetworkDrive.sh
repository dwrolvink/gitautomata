# Network drive functionality
pacman -S 		smbclient 				--noconfirm
pacman -S 		manjaro-settings-samba 	--noconfirm

# Location of the Network drive to be mounted
sudo -u $USER mkdir /home/${USER}/nwd

# Create new file, and fill in network url, mount location, and UID/GID
cp mountnwd.service-master mountnwd.service
sed -i "s+{{NETWORK_DRIVE_URL}}+${NETWORK_DRIVE_URL}+g" 	mountnwd.service
sed -i "s+{{MOUNT_LOCATION}}+/home/${USER}/nwd+g" 			mountnwd.service
sed -i "s+{{UID}}+$(id -u $USER)+g" 						mountnwd.service
sed -i "s+{{GID}}+$(id -g $USER)+g" 						mountnwd.service

# Copy config files over
cp -f   mountnwd.service 	/etc/systemd/system/mountnwd.service

# Mount network drive
systemctl enable /etc/systemd/system/mountnwd.service