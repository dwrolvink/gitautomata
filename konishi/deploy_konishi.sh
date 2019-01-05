#!/bin/bash
 . _functions.sh
 . _gitautomata_config.sh
 . nginx/new_site.sh
  
 # Install nginx if not yet installed
 # -----
 printstep "Installing Nginx..."
 
 if [ ! -d "/etc/nginx" ]; then
    . nginx/install_nginx.sh
 else
   printstep "Nginx has already been installed, skipping" $NOTIFMSG
 fi
 
 # Create website folders/records
 # -----
 printstep "Creating nginx website $MAINWEBSITE"
 createNewSite "$MAINWEBSITE"
 
 # Get files from github
 # -----
 printstep "Getting backend and frontend from github"
 if [ ! -d "$DEVFOLDER" ]; then
   mkdir $DEVFOLDER
 fi
 
 # Remove possible old folders
 rm -rf $MAINFOLDER/$BACKEND
 rm -rf $DEVFOLDER/$FRONTEND 
 
 # Clone 
 cd $MAINFOLDER
 git clone https://github.com/konishi-project/zimmerman.git
 cd $DEVFOLDER
 git clone https://github.com/konishi-project/higala.git

