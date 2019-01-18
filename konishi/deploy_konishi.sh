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

# Check if website already exists
if [ -d "$BACKENDFOLDER" ]; then
  printstep "Tay was a threat to them, because they couldn't control her." $ERRORMSG
  printstep "There seems to be already a website installed on this machine." $NOTIFMSG
  printstep "Running this script will delete all data. Run freshpull.sh to only update the code."
  read -r -p "Do you want to continue? y/N" response
  
  if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      exit 1
  fi
fi
  
 ##############################################
 #          SET UP USERS AND GROUPS           #
 ##############################################  
 if grep -q ssl-cert /etc/group;
 then
 	printstep "ssl-cert already exists, skipping group creation" $NOTIFMSG
 else
	# Create group that will get permissions on /etc/ssl/private
	sudo groupadd ssl-cert 

	# Add root and www-data to ssl-cert group
	sudo usermod -a -G ssl-cert www-data
	sudo usermod -a -G ssl-cert root
	
	# Set group of /etc/ssl/private to ssl-cert
	sudo chgrp ssl-cert /etc/ssl/private

	# Change permissions on /etc/ssl/private
	# 640: owner=read+write, group=read, public=none
	sudo chmod 640 /etc/ssl/private
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
 
 # Add node.js ppa to Ubuntu so node and npm will be the latest version
 curl -sL https://deb.nodesource.com/setup_11.x | sudo bash -
 
 sudo apt-get install python3-pip --yes
 yes | sudo -H pip3 install virtualenv
 sudo apt-get install nodejs --yes
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

 if [ -d "$MAINFOLDER/$MAINWEBSITE" ] || [ -f /etc/nginx/sites-available/$MAINWEBSITE ] ; then
    printstep "Website $website seems to already exist, skipping site creation." $NOTIFMSG
 else
    createNewSite "$MAINWEBSITE" "$MAINFOLDER"
 fi
 
 
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

 # Copy config.py over to a backup folder, so it will be restored after doing 'git reset' in freshpull.sh
 cp $BACKENDFOLDER/config.py $GITAUTOMATA/$BACKEND/config.py
 
 # Copy db installation script over so it can find app.py
 cp $GITAUTOMATA/src/zimmerman_installdb.py $BACKENDFOLDER/zimmerman_installdb.py 
  
 # VENV
 # =================================================
 # Create venv, enter venv
 virtualenv konishienv
 source konishienv/bin/activate
 
 # Install venv requirements
 pip3 install -r requirements.txt
 
 # Create database
 python3 $BACKENDFOLDER/zimmerman_installdb.py
 
 # Exit venv
 deactivate
 # =================================================
 
 # Create Nginx site block
    # Configure site file
    SITE="\
    server {                              \n\
      listen 80;                          \n\
      listen [::]:80;                     \n\
      server_name backend.konishi.club;   \n\
      
      
      location / {                                        \n\
        proxy_pass http://localhost:4000$;                \n\
        proxy_set_header Host $host;                      \n\
      }                                   \n\
    }                                     \n\
    "
       		
    # Write site configuration to sites-available
    echo -e $SITE | sudo tee -a  /etc/nginx/sites-available/backend > /dev/null
    
    # Create symbolic link to sites-enabled. 
    # Note: this link must be done with full pathnames
    sudo ln -s /etc/nginx/sites-available/backend /etc/nginx/sites-enabled/backend    
    
    # Add user for Zimmerman
	sudo adduser --disabled-password --gecos "" backend    
	
	# Set user and group of /var/www/zimmerman to ubuntu:backend (ubuntu being the ssl user)
	sudo chown -R ubuntu:backend /var/www/zimmerman
	
	# RESTRICTIVE PERMISSIONS 
	# ==================================================================
	# Default: public can do nothing, backend can do everything
	sudo chmod -R 770 /var/www/zimmerman

	# Set folder and contents to 777: public is allowed to upload files
	sudo chmod -R 777 /var/www/zimmerman/static/postimages

	# Set folder itself to r+e: public cannot change folder itself
	sudo chmod    775 /var/www/zimmerman/static/postimages

	# Compiled python file stash, the app should be able to do anything here
	sudo chmod -R 770 /var/www/zimmerman/__pycache__

	# Be able to read and execute app data as backend, but not edit it
	sudo chmod -R 750 /var/www/zimmerman/konishienv
	sudo chmod    750 /var/www/zimmerman/*.py

	# App should be able to modify, read, and execute the database, of course
	sudo chmod    770 /var/www/zimmerman/*.db	
	# =====================================================================
	
	# Install service
	sudo cp $GITAUTOMATA/src/backend.service /etc/systemd/system/backend.service
	sudo systemctl enable backend
	sudo systemctl start backend
	
 
 ##############################################
 #                 SETUP HIGALA               #
 ##############################################
 printstep "Setting up higala"

 cd ${DEVFOLDER}/${FRONTEND}

 # Copy config.py over to a backup folder, so it will be restored after doing 'git reset' in freshpull.sh
 mkdir $GITAUTOMATA/$FRONTEND/src
 cp $FRONTENDFOLDER/src/config.js $GITAUTOMATA/$FRONTEND/src/config.js
 
 # Install npm
 npm install 

echo -e "\n\n------------------"
echo "Script is finished"
echo "------------------"
echo "Summary of notifications generated by this script:"
echo -e "$printstepLOG"
echo ""
echo "Run freshpull.sh to start serving Konishi."
echo "Consult https://github.com/konishi-project/konishi/ for how to finish configuring SSL"
echo ""

