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

InstallNginx()
{
    # Constants
    MANJARO=0
    UBUNTU=1

    # Config
    # ---------------------------
    mainUser=${1}
    setWWWData=0
    distro=$UBUNTU

    # Install nginx
    # ---------------------------
    if [[ $distro -eq $MANJARO ]];
    then
        sudo pacman -S nginx
        sudo mkdir /etc/nginx/sites-available/
        sudo mkdir /etc/nginx/sites-enabled/

    elif [[ $distro -eq $UBUNTU ]];
    then
        sudo apt-get install nginx --yes
    fi

    # Set rights
    # ---------------------------
    # Create www-data group, and add main user to it
    if [[ $setWWWData -eq 1 ]];
    then
        sudo groupadd www-data
        sudo usermod $mainUser -a -G www-data

        # Give www-data rights to everything in /var/www/
        sudo chown -R :www-data /var/www/
    fi

    # Empty default site
    # ---------------------------
    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/_default_factory
    sudo echo "" >> /etc/nginx/sites-available/default
}
