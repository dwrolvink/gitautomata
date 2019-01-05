
. _private_info_config.sh

# Check if _private_info_config.sh has been filled in
if [ -z "$GITUSERNAME" ]; then
  echo -e "\033[0;31m Error! Fill in _private_info_config.sh before running this script! \033[0m" 1>&2
  exit 64
fi

# Main website.
# This will be the main entry point for our website, backend and frontend
MAINWEBSITE='konishi.pcmrhub.com'

# Main folder. 
# This is the webfolder, /var/www/ by default
MAINFOLDER="/var/www" 

# Dev folder
# Higala is downloaded from github, then run using npm run serve
# This creates a dist folder, which has a compiled website in it
# Higala is therefore not running directly (unless when in dev mode)
# And thus separated out from /var/www/ to avoid confusion
DEVFOLDER="/var/www/dev" 

# Frontend
FRONTENDGIT="https://github.com/konishi-project/higala.git"
FRONTEND='higala'
FRONTENDPORT=8080

# Backend
BACKENDGIT="https://github.com/konishi-project/zimmerman.git"
BACKEND='zimmerman'
BACKENDPORT=4000

TESTVAR="Config Loaded."

