#!/bin/bash

# Config
# ---------------------------------------------------
USER="user"
SERVER_NAME="web002"

WEBSITE_NAME="dwrolvink.com"
WEB_ROOT="/home/${USER}/www"
WEBSITE_DIRECTORY="${WEB_ROOT}/${WEBSITE_NAME}/"

MARKSERV_PORT="8081"
FRONTEND_PORT="80"

INSTALLATION_DIRECTORY=$(pwd)

# Firewall Changes
# ---------------------------------------------------
# Set SELINUX to permissive
echo "SELINUX=permissive" >> /etc/selinux/config
setenforce 0

# Open firewall
firewall-cmd --zone=public --add-port=${FRONTEND_PORT}/tcp --permanent
firewall-cmd --zone=public --add-port=${MARKSERV_PORT}/tcp --permanent
firewall-cmd --reload

# Install nginx
# ---------------------------------------------------
yum install -y nginx

mkdir /etc/nginx/sites-available/
mkdir /etc/nginx/sites-enabled/
touch /etc/nginx/sites-available/default.conf

# Create webdirectory, and load in the website
mkdir ${WEB_ROOT}
cd ${WEB_ROOT}
git clone https://github.com/dwrolvink/dwrolvink.com

# Add user nginx and own ssh user to www-data
groupadd www-data
usermod ${USER} -a -G www-data
usermod nginx -a -G www-data
sudo chown -R :www-data ${WEB_ROOT}
chmod 775 -R ${WEB_ROOT}

# Edit nginx configuration
echo "include /etc/nginx/sites-enabled/*.conf;" >> /etc/nginx/nginx.conf
echo "server_names_hash_bucket_size 64;" >> /etc/nginx/nginx.conf

# Install Frontend
cd templates
  template="siteblock.conf"; filename="${WEBSITE_NAME}.conf"
  substitute=(SERVER_NAME WEBSITE_NAME WEBSITE_DIRECTORY MARKSERV_PORT FRONTEND_PORT)
  . ../../tools/substitute.sh
  cp -f ${WEBSITE_NAME}.conf /etc/nginx/sites-available/${WEBSITE_NAME}.conf
cd $INSTALLATION_DIRECTORY

ln -s /etc/nginx/sites-available/${WEBSITE_NAME}.conf /etc/nginx/sites-enabled/${WEBSITE_NAME}.conf
rm /etc/nginx/sites-available/default.conf

# Install Markserv
# ---------------------------------------------------
cd modules/markserv
. ./deploy_markserv.sh
cd $INSTALLATION_DIRECTORY

# Reload Nginx to apply changes
# ---------------------------------------------------
systemctl restart nginx

