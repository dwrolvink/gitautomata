# http://www.dwrolvink.com/?view=coding/website/install_markserv

# :: INSTAL NODEJS ------------------------------------
# Add node repo, install make tools
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_11.x | sudo -E bash -

# Install nodejs
sudo yum install -y nodejs

# Install yarn
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install -y yarn
 
 
 # :: SET FIREWALL ------------------------------------
sudo firewall-cmd --zone=public --add-port=${SERVICE_PORT}/tcp --permanent
sudo firewall-cmd --reload


# :: INSTALL MARKSERV ---------------------------------
# Install markserv
yarn global add markserv

# Edit template (manual)
vi /home/${USER}/.yarn/bin/markserv/lib/templates/markdown.html


# :: ENABLE MARKSERV ---------------------------------
cp markserver.service-master markserver.service
sed -i "s+{{WEBSITE_NAME}}+${WEBSITE_NAME}+g" markserver.service
sed -i "s+{{WEBSITE_DIRECTORY}}+${WEBSITE_DIRECTORY}+g" markserver.service
sed -i "s+{{MARKSERV_PORT}}+${SERVICE_PORT}+g" markserver.service
sed -i "s+{{USER}}+${USER}+g" markserver.service
sudo cp -f markserver.service /etc/systemd/system/markserver.service

sudo systemctl start markserver
sudo systemctl enable markserver
