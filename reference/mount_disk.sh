#sudo -i

# see all disks
fdisk -l

# Make target folder to mount to
mkdir -p /srv/archive

# Mount folder
mount /dev/sde2 /srv/archive

# exit sudo
# exit


# make permanent
lsblk -f # note UUID of sde2

vim /etc/fstab
# add:
# UUID={{uuid}} /srv/archive ntfs defaults,noatime 0 0

mount -a

