USER="user"
WEB_ROOT="/home/$(USER)/www/"
WEBSITE_DIRECTORY="$(WEB_ROOT)/dwrolvink/"

# Install nginx
# ---------------------------------------------------
yum install -y nginx

mkdir /etc/nginx/sites-available/
mkdir /etc/nginx/sites-enabled/
touch /etc/nginx/sites-available/default.conf

# Create webdirectory, and set ownership to www-data
mkdir $(WEB_ROOT)
mkdir $(WEBSITE_DIRECTORY)
chmod 775 -R $(WEB_ROOT)

# Add user nginx and own ssh user to www-data
groupadd www-data
usermod $(USER) -a -G www-data
usermod nginx -a -G www-data
sudo chown -R :www-data $(WEB_ROOT)

# Install Markserv
# ---------------------------------------------------
cd modules/markserv
. ./deploy_markserv.sh
