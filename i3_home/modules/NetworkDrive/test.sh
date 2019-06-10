NETWORK_DRIVE_URL='//192.168.1.1/USB_Storage'
USER='dorus'

# Create new file, and fill in network url, mount location, and UID/GID
cp mountnwd.service-master mountnwd.service
sed -i "s+{{NETWORK_DRIVE_URL}}+${NETWORK_DRIVE_URL}+g" 	mountnwd.service
sed -i "s+{{MOUNT_LOCATION}}+/home/${USER}/nwd+g" 			mountnwd.service
sed -i "s+{{UID}}+$(id -u $USER)+g" 						mountnwd.service
sed -i "s+{{GID}}+$(id -g $USER)+g" 						mountnwd.service