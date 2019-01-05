# NOTE! BEFORE YOU BEGIN! 
# - Create /var/www yourself

# Main folder
# This is you. You need sudo privileges
MAINUSER='dorus'

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

# Installation location of Gitautomata
GITAUTOMATA="$MAINFOLDER/gitautomata"

# Default branch.
# For 'git reset --hard [branch name]' you need to input a branch name, it doesn't work without it.
# Git reset is useful for completely resetting all the files in git, while preserving the files that are in .gitignore.
# For example, 'rm -rf /var/www/zimmerman; git clone [url];' would reset the code, but it would also remove the database.
DEFAULTBRANCH="origin/dev"

# Frontend
FRONTENDGIT="https://github.com/konishi-project/higala.git"
FRONTEND='higala'
FRONTENDFOLDER="$DEVFOLDER/$FRONTEND"
FRONTENDPORT=8080

# Backend
BACKENDGIT="https://github.com/konishi-project/zimmerman.git"
BACKEND='zimmerman'
BACKENDFOLDER="$MAINFOLDER/$BACKEND"
BACKENDPORT=4000

# Test if this config is loaded properly in other scripts using this string
TESTVAR="Config Loaded."

