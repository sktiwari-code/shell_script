#!/bin/bash
clear

if [ "$(whoami)" == "root" ] ; then
    echo -e "\n................. Start Service For Install Apache2.4.48 in your server .....................\n"
    echo ""
    echo ""
else

    echo -e "\n.....................Please before run script use sudo. .................\n"

    exit;
fi

# functiion install apache version

function installapache {
    echo -e "\n...............Apache2.4.48 Installing.................\n"
     
     sudo yum clean all
     sudo yum -y update
     sudo yum-config-manager --enable amzn2-core
     sudo yum install -y httpd
     sudo yum-config-manager --disable amzn2-core
     sudo yum -y update
     sudo systemctl restart httpd
    echo -e ""
    echo -e "\nPHP VERSION Apache2.4.48 Installed Successfully \n"
}

# function validate
function validateapache {
    echo ""
    while true; do
    read -p "Do you wish to install Apache2.4.48 yes/no ? " yn
    case $yn in
        [Yy]* )  installapache break;;
        [Nn]* ) exit;;
        * ) echo -e "\nPlease answer yes or no.\n";;
    esac
    done
}

httpd -v | grep "Apache/2.4.48" && echo -e "\n................ Apache2.4.48 installed ..............\n" || validateapache


