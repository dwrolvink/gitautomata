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
 
 sudo apt-get install python3-pip
 sudo -H pip3 install virtualenv
 sudo apt install nodejs
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
 
 printstep "STOP... HAMMERTIME!" $ERRORMSG 1
 printstep "Open a new SSH window, and do the following:" $NOTIFMSG 1
 printstep "- Set SQLALCHEMY_DATABASE_URI='sqlite:///${BACKENDFOLDER}/konishi.db' in ${BACKENDFOLDER}/config.py" $NOTIFMSG 1
 printstep "- Set SERVER_NAME in the same file to whatever you please." $NOTIFMSG 1
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
 
 # Create Nginx site block
 server {
	listen 80;
    listen [::]:80;
	server_name backend.konishi.club;

	location / {
		proxy_pass http://127.0.0.1:4000$request_uri;
		proxy_set_header Host $host;
	}
}

    # Configure site file
    SITE="\
    server {                              \n\
      listen 80;                          \n\
      listen [::]:80;                     \n\
      server_name backend.konishi.club;   \n\
      
      
      location / {                                        \n\
        proxy_pass http://127.0.0.1:4000$request_uri;     \n\
        proxy_set_header Host $host;                      \n\
      }                                   \n\
    }                                     \n\
    "
       
    # Write site configuration to sites-available
    echo -e $SITE | sudo tee -a  /etc/nginx/sites-available/backend > /dev/null
    
    # Create symbolic link to sites-enabled. 
    # Note: this link must be done with full pathnames
    sudo ln -s /etc/nginx/sites-available/backend /etc/nginx/sites-enabled/backend    
 
 ##############################################
 #                 SETUP HIGALA               #
 ##############################################
 printstep "Setting up higala"

 cd ${DEVFOLDER}/${FRONTEND}
 printstep "STOP... HAMMERTIME!" $ERRORMSG 1
 printstep "Open a new SSH window, and do the following:" $NOTIFMSG 1
 printstep "- Set config.backendURL in ${DEVFOLDER}/${FRONTEND}/src/config.js to the URL your backend will is available on (SERVER_NAME from earlier)." $NOTIFMSG 1
 read -rsp $'Press any key to continue when you\'re done...\n' -n1 key

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
echo "Run nginx, and run freshpull.sh to start serving Konishi."
echo ""

