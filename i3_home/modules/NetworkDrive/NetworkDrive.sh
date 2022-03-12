# Install NetworkDrive
INSTAL_NETWORK_DRIVE=1 							# <0,1> :: <no,yes>
NETWORK_DRIVE_URL='//192.168.1.1/USB_Storage'

# Main Config
USER='dorus'

# Cancel execution if module is not configured to be installed.
if [[ $INSTAL_NETWORK_DRIVE -ne 1 ]];
then
  echo "Opted out of installing a Network Drive"
  return 0
fi

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
systemctl enable mountnwd.service
systemctl start  mountnwd.service
