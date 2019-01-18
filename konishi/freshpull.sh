
#!/bin/bash

# Load Config
# --------------------------------
. ../_functions.sh
. config.sh

if [ -z "$TESTVAR" ]
then
      printstep "Config file not loaded" $ERRORMSG
      exit 1     
else
      printstep $TESTVAR
fi

# Stop zimmerman and higala
# --------------------------------
printstep "Stopping Zimmerman"
# fuser -k ${BACKENDPORT}/tcp  #old method
sudo systemctl stop backend
printstep "Done"

# Get most recent code from github
# --------------------------------
printstep "Getting most recent code from default branch"
cd $MAINFOLDER/${BACKEND}
git fetch --all
git reset --hard $DEFAULTBRANCH

cd $DEVFOLDER/${FRONTEND}
git fetch --all
git reset --hard $DEFAULTBRANCH
printstep "Done"

# Copy config files back
# --------------------------------
printstep "Copying config files back (need to separate config still)"
cp -a $MAINFOLDER/gitautomata/konishi/${BACKEND}/. $MAINFOLDER/${BACKEND}/
cp -a $MAINFOLDER/gitautomata/konishi/${FRONTEND}/. $DEVFOLDER/${FRONTEND}/


#Start zimmerman
# --------------------------------
printstep "Starting Zimmerman..."
# OLD METHOD ------------
#cd $MAINFOLDER/${BACKEND}
#source konishienv/bin/activate
#python3 app.py &
# ----------------------+
sudo systemctl start backend
sleep 2s
if ! systemctl is-active --quiet backend;
then
      printstep "Could not start Zimmerman" $ERRORMSG
      sudo systemctl status backend

# Start higala
# --------------------------------
printstep "Compiling Higala..."
cd ${DEVFOLDER}/${FRONTEND}
npm audit fix
npm run build --fix

printstep "Copying dist files over..."
cp -rf ${DEVFOLDER}/${FRONTEND}/dist/* ${MAINFOLDER}/${MAINWEBSITE}/


