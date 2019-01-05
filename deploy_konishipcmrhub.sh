#!/bin/bash
 . _functions.sh
 . _gitautomata_config.sh
 . nginx/new_site.sh
  
 # Install nginx if not yet installed
 # -----
 if [ ! -d "/etc/nginx" ]; then
    . nginx/install_nginx.sh
 fi
 
 # Create website folders/records
 # -----
 createNewSite "$MAINWEBSITE"
 
 # Get files from github
 # -----
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

