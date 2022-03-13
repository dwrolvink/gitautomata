# On the server
# ===================================================================

# Create the data structure
sudo -i
mkdir -p /data/share01          # data share 
mkdir -p /srv/nfs/share01       # export point

mkdir -p /data/share02          # data share 
mkdir -p /srv/nfs/share02       # export point

# Set folder permissions
chmod ugo+rwx /data/share01
chmod ugo+rwx /data/share02

# Set default acl for files that are created in this folder
setfacl -Rdm m::rwx /data/share01
setfacl -Rdm m::rwx /data/share02

# mount data share to export point 
vim /etc/fstab                  

# /data/share01 /srv/nfs/share01 none bind 0 0
# /data/share02 /srv/nfs/share02 none bind 0 0

mount -a

# <test>
echo "hi" > /data/share01/test.txt
cat /srv/nfs/share01/test.txt

echo "hi2" > /data/share02/test.txt
cat /srv/nfs/share02/test.txt


# whitelist network
vim /etc/exports

# /srv/nfs            192.168.178.0/24(rw,sync,crossmnt,fsid=0)
# /srv/nfs/share01    192.168.178.0/24(rw,sync)
# /srv/nfs/share02    192.168.178.0/24(rw,sync)

# check current settings
exportfs -v

# update settings
exportfs -arv

# start service
systemctl enable --now nfs-server.service

# or reload
systemctl restart nfs-server.service

# exit sudo -i
exit

# On the client
# ===================================================================
systemctl enable --now nfs-client.target
systemctl status nfs-client.target

# Test if mounts are published
showmount -e 192.168.178.136

sudo -i
vim /etc/systemd/system/data-share01.mount

# [Unit]
# Description=Share01
# After=network.target

# [Mount]
# What=192.168.178.136:/share01
# Where=/data/share01
# Type=nfs
# Options=_netdev,auto

# [Install]
# WantedBy=multi-user.target

vim /etc/systemd/system/data-share02.mount

# [Unit]
# Description=Share02
# After=network.target

# [Mount]
# What=192.168.178.136:/share02
# Where=/data/share02
# Type=nfs
# Options=_netdev,auto

# [Install]
# WantedBy=multi-user.target


# systemctl daemon-reload
systemctl enable --now data-share01.mount
systemctl status data-share01.mount
systemctl stop data-share01.mount

systemctl enable --now data-share02.mount
systemctl status data-share02.mount
systemctl stop data-share02.mount

# Automount
# ------------------------------------------------------------------
# Automount units are optional; but, when they exist, corresponding mount units must also exist. 
# The former are meant to add functionalities to existing instances of the latter.

# A typical use case for automount units is mounting file systems (e.g. on remote or removable or encrypted media) 
# that are not required during the boot process and may slow it down, or that may be unavailable at boot, 
# but that you still like having managed by systemd.

# Make sure the mount service is not in started mode, or enabling the automount will fail due to the share already being mounted

vim /etc/systemd/system/data-share01.automount

# [Unit]
# Description=Automount network drive general
# ConditionPathExists=/data/share01

# [Automount]
# Where=/data/share01
# TimeoutIdleSec=10

# [Install]
# WantedBy=multi-user.target


vim /etc/systemd/system/data-share02.automount

# [Unit]
# Description=Automount network drive general
# ConditionPathExists=/data/share02

# [Automount]
# Where=/data/share02
# TimeoutIdleSec=10

# [Install]
# WantedBy=multi-user.target


systemctl enable --now data-share01.automount
systemctl enable --now data-share02.automount


# exit sudo -i 
exit

# For some reason, we can't paste in /data/share01 without symlinking to home
ln -s /data/share01 $HOME/share01
ln -s /data/share02 $HOME/share02


# Test setup
# =================================================================
# - Write from client to existing file 
# - Read update at server side
# - Create new file from client 
# - Paste in folder