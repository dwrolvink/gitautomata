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
 # Remove possible old folders
 rm -rf $MAINFOLDER/$FRONTEND
 rm -rf $MAINFOLDER/$BACKEND
 
 # Clone 
 cd $MAINFOLDER
 git clone https://github.com/konishi-project/zimmerman.git
 git clone https://github.com/konishi-project/higala.git

