# On server
# ===================================
sudo -i

# Install requirements
pacman -Syu samba

# Create file structure
mkdir -p /srv/samba
chmod ugo+rwx /srv/samba -R
setfacl -Rdm m::rwx /srv/samba

mkdir -p /srv/samba-system
chmod ugo+rwx /srv/samba-system -R
setfacl -Rdm m::rwx /srv/samba-system

. mount_disk.sh
chmod ugo+rwx /srv/archive -R
setfacl -Rdm m::rwx /srv/archive


# Create user for system share
# Create linux user
useradd -m smb_admin
passwd smb_admin
# Create samba user (use different password!)
smbpasswd -a smb_admin


# config
vim /etc/samba/smb.conf

[global]
   workgroup = Manjaro
   server string = Samba Server
   server role = standalone server
   log file = /var/log/samba/log.%m
   max log size = 50
   guest account = nobody
   map to guest = Bad Password
   use sendfile = yes
   min receivefile size = 16384
   aio read size = 1
   aio write size = 1
   socket options = IPTOS_LOWDELAY TCP_NODELAY IPTOS_THROUGHPUT SO_RCVBUF=131072 SO_SNDBUF=131072

[public]
   path = /srv/samba
   public = yes
   writable = yes
   printable = no
   create mask = 0664
   directory mask = 2775
   force create mode = 0664
   force directory mode = 2775

[system]
   path = /srv/samba-system
   public = no
   writable = yes
   valid users = smb_admin
   printable = no
   create mask = 0664
   directory mask = 2775
   force create mode = 0664
   force directory mode = 2775

[archive]
   path = /srv/archive
   public = yes
   writable = yes
   printable = no
   create mask = 0664
   directory mask = 2775
   force create mode = 0664
   force directory mode = 2775

# test config validity
testparm /etc/samba/smb.conf

# start
systemctl enable --now smb nmb

systemctl status smb
systemctl status nmb

# exit sudo -i
exit

# On Linux Client
# ===================================
pacman -Syu smb-client

# in file manager
smb://servername/public

# On Windows Client
# ===================================
# in file manager
\\servername




