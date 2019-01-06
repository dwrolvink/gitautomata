#!/bin/bash

 . ../_functions.sh
 . config.sh
 
 . ../nginx/nginx.sh
 . ../nginx/new_site.sh 
 
 # Check if config is loaded
if [ -z "$TESTVAR" ]
then
      printstep "Config file not loaded" $ERRORMSG
      exit 1     
else
      printstep "$TESTVAR"
fi
  
 ##############################################
 #               SET UP FOLDERS               #
 ##############################################  
 # Create main folder (/var/www/) if is doesn't
 if [ ! -d "$MAINFOLDER" ]; then
   mkdir $MAINFOLDER
 fi 
 
  # Create dev folder (/var/www/dev/) if it existn't
 if [ ! -d "$DEVFOLDER" ]; then
   mkdir $DEVFOLDER
 fi 
 
 # Create config backup directories
 mkdir $GITAUTOMATA/$BACKEND
 mkdir $GITAUTOMATA/$FRONTEND
  
 ##############################################
 #            INSTALL REQUIREMENTS            #
 ##############################################
 printstep "Installing requirements"
 
 sudo apt-get update
 sudo apt-get install python3-pip --yes
 pip install virtualenv
 sudo apt-get install sqlite --yes
 
 ##############################################
 #         INSTALL & CONFIGURE NGINX          #
 ##############################################
 printstep "Installing Nginx..."
 
 # Install nginx if not yet installed
 if [ ! -d "/etc/nginx" ]; then
    InstallNginx $MAINUSER
 else
   printstep "Nginx has already been installed, skipping" $NOTIFMSG
 fi
 
 # Create website folders & records
 printstep "Creating nginx website $MAINWEBSITE"
 createNewSite "$MAINWEBSITE"
 
 ##############################################
 #     GET BACKEND & FRONTEND FROM GITHUB     #
 ##############################################
 printstep "Getting backend and frontend from github"
 
 # Remove old folders if they exist
 rm -rf $BACKENDFOLDER
 rm -rf $FRONTENDFOLDER
 
 # Get data from github
 cd $BACKENDPARENT
 git clone https://github.com/konishi-project/zimmerman.git
 
 cd $FRONTENDPARENT
 git clone https://github.com/konishi-project/higala.git
 
 ##############################################
 #               SETUP ZIMMERMAN              #
 ##############################################
 printstep "Setting up zimmerman"
 cd $BACKENDFOLDER
 
 printstep "STOP... HAMMERTIME!" $ERRORMSG
 printstep "Open a new SSH window, and do the following:" $NOTIFMSG
 printstep "- Set SQLALCHEMY_DATABASE_URI='sqlite:////${BACKENDFOLDER}/konishi.db' in /${BACKENDFOLDER}/config.py" $NOTIFMSG
 read -rsp $'Press any key to continue when you\'re done...\n' -n1 key

 # Copy config.py over to a backup folder, so it will be restored after doing 'git reset' in freshpull.sh
 cp $BACKENDFOLDER/config.py $GITAUTOMATA/$BACKEND/config.py
 
 # Copy db installation script over so it can find app.py
 cp $GITAUTOMATA/zimmerman_installdb.py $BACKENDFOLDER/zimmerman_installdb.py 
  
 # Create venv, and install venv requirements
 virtualenv konishienv
 source konishienv/bin/activate
 pip3 install -r requirements.txt
 
 # Create database
 python3 $BACKENDFOLDER/zimmerman_installdb.py
 
 ##############################################
 #                 SETUP HIGALA               #
 ##############################################

