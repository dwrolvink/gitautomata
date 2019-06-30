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
sudo firewall-cmd --zone=public --add-port=${MARKSERV_PORT}/tcp --permanent
sudo firewall-cmd --reload


# :: INSTALL MARKSERV ---------------------------------
# Install markserv
yarn global add markserv

# Edit template
ms_template="/usr/local/share/.config/yarn/global/node_modules/markserv/lib/templates/markdown.html"
echo -e '<article class="markdown-body">\n{{{content}}}\n</article>' > $ms_template

# :: ENABLE MARKSERV ---------------------------------
cp markserver.service-master markserver.service
sed -i "s+{{WEBSITE_NAME}}+${WEBSITE_NAME}+g" markserver.service
sed -i "s+{{WEBSITE_DIRECTORY}}+${WEBSITE_DIRECTORY}+g" markserver.service
sed -i "s+{{MARKSERV_EXE}}+$(whereis markserv)+g" markserver.service
sed -i "s+{{MARKSERV_PORT}}+${MARKSERV_PORT}+g" markserver.service
sed -i "s+{{USER}}+${USER}+g" markserver.service
sudo cp -f markserver.service /etc/systemd/system/markserver.service

sudo systemctl start markserver
sudo systemctl enable markserver
