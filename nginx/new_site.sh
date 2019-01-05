createNewSite()
{
    website=${1}
    webfolder=${2}
    
    # Check if website already exists
    if [ -d "$webfolder/$website" ] || [ -f /etc/nginx/sites-available/${website} ] ; then
        echo -e "\033[0;31m Website $website seems to already exist, skipping site creation. \033[0m"
        exit 0
    fi
    
    # Create website directory
    mkdir /var/www/$website

    # Configure site file
    SITE="\
    server {                              \n\
      listen 80 default_server;           \n\
      listen [::]:80 default_server;      \n\
      root /var/www/${website};           \n\
      index index.html;                   \n\
      server_name ${website};             \n\
      location / {                        \n\
        try_files $uri $uri/ =404;        \n\
      }                                   \n\
    }                                     \n\
    "
    # Write site configuration to sites-available
    echo -e $SITE | sudo tee -a  /etc/nginx/sites-available/${website} > /dev/null

    # Create symbolic link to sites-enabled. 
    # Note: this link must be done with full pathnames
    sudo ln -s /etc/nginx/sites-available/${website} /etc/nginx/sites-enabled/${website}
}

# CreateNewSite konishi.pcmrhub.com
