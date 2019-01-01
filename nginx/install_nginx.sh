#!/bin/bash
# ---------------------------
# Creating a webserver in Nginx on Manjaro linux
# ---------------------------
# Written for: Manjaro, 2018-12-23
# Written by : D.W. Rolvink
# ---------------------------
# Steps:
# - Configuration for this script
# - Install Nginx
# - Setup folders, and privileges
# - Create site config file
# ---------------------------

# Config
# ---------------------------
mainUser='dorus'

# Install nginx
# ---------------------------
# [/MANJARO]
#   sudo pacman -S nginx
# [/MANJARO]
# [UBUNTU]
    sudo apt-get install nginx
# [/UBUNTU]

# Create proper folders
# ---------------------------
# Create sites directories
# [MANJARO]
#   sudo mkdir /etc/nginx/sites-available/
#   sudo mkdir /etc/nginx/sites-enabled/
# [/MANJARO]

# Set rights
# ---------------------------
# Create www-data group, and add main user to it
# [DO ONCE]
#sudo groupadd www-data
#sudo usermod $mainUser -a -G www-data

# Give www-data rights to everything in /var/www/
#sudo chown -R :www-data /var/www/
# [DO ONCE]

# Edit nginx main file
# ---------------------------

