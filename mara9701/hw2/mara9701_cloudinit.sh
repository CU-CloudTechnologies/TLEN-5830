#Cloud Init script

echo -e "export OS_AUTH_URL=http://192.168.1.197/identity/v3" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_PROJECT_ID=6d526fbd34d04923b4f962ecbb5a394c" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_PROJECT_NAME=\"TLEN-5830\"" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_USER_DOMAIN_NAME=\"Default\"" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "if [ -z \"\$OS_USER_DOMAIN_NAME\" ]; then unset OS_USER_DOMAIN_NAME; fi" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_PROJECT_DOMAIN_ID=\"default\"" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "if [ -z \"$OS_PROJECT_DOMAIN_ID\" ]; then unset OS_PROJECT_DOMAIN_ID; fi" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "unset OS_TENANT_ID" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "unset OS_TENANT_NAME" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_USERNAME=\"mara9701\"" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "echo \"Please enter your OpenStack Password for project \$OS_PROJECT_NAME as user \$OS_USERNAME: \"" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "read -sr OS_PASSWORD_INPUT" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_PASSWORD=\$OS_PASSWORD_INPUT" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_REGION_NAME=\"RegionOne\"" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "if [ -z \"\$OS_REGION_NAME\" ]; then unset OS_REGION_NAME; fi" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_INTERFACE=public" >> /home/centos/TLEN-5830-openrc.sh 
echo -e "export OS_IDENTITY_API_VERSION=3" >> /home/centos/TLEN-5830-openrc.sh 


#Install packages
sudo yum -y update
sudo yum -y upgrade
sudo yum -y install epel-release
sudo yum -y install python-pip
sudo pip install pip --upgrade
sudo yum -y groupinstall "Development Tools"  
yum install python27-python-devel.x86_64
sudo pip installl python-openstackclient
source TLEN-5830-openrc.sh 

