#!/bin/bash
clear

if [ "$(whoami)" == "root" ] ; then
    echo -e "\n................. Start Service For Install any PHP version in your server .....................\n"
    echo ""
    echo ""
else

    echo -e "\n.....................Please before run script use sudo. .................\n"

    exit;
fi

# functiion declare check vaiable in array

function in_array {
  ARRAY=$2
  for e in ${ARRAY[*]}
  do
    if [[ "$e" == "$1" ]]
    then
      return 0
    fi
  done
  return 1
}

# functiion install php version

function installphp {
    echo -e "\n...............PHP Version $1 .................\n"
     
     sudo yum clean all
     sudo yum -y update
     sudo yum install -y yum-utils
     sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
     sudo yum install -y epel-release
     sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
     sudo yum-config-manager --disable amzn2-core
     sudo yum-config-manager --disable remi-php56
     sudo yum-config-manager --disable remi-php70
     sudo yum-config-manager --disable remi-php71
     sudo yum-config-manager --disable remi-php72
     sudo yum-config-manager --disable remi-php73
     sudo yum-config-manager --disable remi-php74
     sudo yum-config-manager --disable remi-php80
     sudo yum-config-manager --enable remi-php$1
     sudo yum -y update
     sudo yum remove "php*" -y
     sudo yum install -y php php-common php-cli
     sudo systemctl restart httpd
    echo -e ""
    echo -e "\nPHP VERSION $PHPV Installed Successfully \n"
}

# eneter php version logic

while true; do
read -p "Enter PHP version which you want install: " PHPV
my_array=(56 70 71 72 73 74 80)
if in_array "${PHPV}" "${my_array[*]}"
  then
    break
  else
    echo -e "\nPlease Enter Correct PHP Version (56 70 71 72 73 74 80)\n"
fi
done;

# check php version
case $PHPV in
     56)
          str=5.6
          ;;
     70)
          str=7.0
          ;;
     71)
          str=7.1
          ;;
     72)
          str=7.2
          ;;
     73)
          str=7.3
          ;;
     74)
          str=7.4
          ;;
      80)
          str=8.0
          ;;

     *)
          echo "Sorry, invalid input"
          ;;
esac
php -v | grep "^PHP $str" && echo -e "\n................ PHP $PHPV already installed ..............\n" || installphp "${PHPV}"


# ask question again

while true; do
    read -p "Do you wish to install any other PHP Version yes/n ? " yn
    case $yn in
        [Yy]* ) sudo sh installphp.sh /home/ec2-user/shell_script/ break;;
        [Nn]* ) exit;;
        * ) echo -e "\nPlease answer yes or no.\n";;
    esac
done