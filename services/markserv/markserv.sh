# http://www.dwrolvink.com/?view=coding/website/install_markserv

# :: INSTAL NODEJS ------------------------------------

# Add node repo, install make tools
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_11.x | sudo -E bash -

# Install nodejs
sudo yum install -y nodejs

# Install yarn
 curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
 sudo yum install -y yarn
 
 
 # :: SET FIREWALL ------------------------------------
 
firewall-cmd --zone=public --add-port=8081/tcp --permanent
firewall-cmd --reload


# :: INSTALL MARKSERV ---------------------------------

# Install markserv
yarn global add markserv

# Edit template (manual)
vi /usr/local/share/.config/yarn/global/node_modules/markserv/lib/templates/markdown.html


# :: ENABLE MARKSERV ---------------------------------

cp -f markserver.service-master /etc/systemd/system/markserver.service
systemctl start markserver
systemctl enable markserver
