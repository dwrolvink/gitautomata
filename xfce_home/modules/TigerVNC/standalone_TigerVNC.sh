#!/bin/sh
USER='dorus'

# Install TigerVNC 
pacman -S tigervnc --noconfirm

# Fill in template
cp tigervnc.service-master tigervnc.service
sed -i "s+{{USER}}+${USER}+g" tigervnc.service

# Copy service file over
cp -f tigervnc.service /etc/systemd/system/tigervnc.service

# Enable TigerVNC
systemctl enable tigervnc.service
systemctl start tigervnc.service
