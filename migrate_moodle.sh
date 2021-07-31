#!/bin/bash
clear
if [ "$(whoami)" == "root" ] ; then
    echo ".................Now Start Migrate Process....................."
    echo ""
    echo ""
else
    echo "Please Script Run Using Sudo First"
    exit;
fi
while true; do
  read -p "Enter Remote  IP  Address : " IP
    if [ -z "$IP" ] 
    then
        echo ""
    else
       break
    fi
done;
read -p "Enter Remote DB Host : " DBHOST
while true; do
  read -p "Enter Remote Database User :" User
    if [ -z "$User" ] 
    then
        echo ""
    else
        break
    fi
done
while true; do
  read -sp "Enter Remote Database Password :" Pass
    if [ -z "$Pass" ] 
    then
        echo ""
    else
        echo ""
        break
    fi
done
while true; do
  read -p "Enter Remote Database Name :" Db
    if [ -z "$Db" ] 
    then
        echo ""
    else
        break
    fi
done
echo ""
echo "...............Start Database Importing ....................."
echo ""
echo ""
if [ "$DBHOST" == "" ];
    then
        sudo mysqldump --allow-keywords --opt -u sktiwari -psktiwari@35 moodle35 | ssh root@$IP "mysql -u $User -p$Pass $Db" && echo "Sucessfully Import Database in Your Remote Server" || echo "something went wrong"
    else
      sudo mysqldump --allow-keywords --opt -u sktiwari -psktiwari@35 moodle35 | sudo mysql -h $DBHOST -u lingel -p$Pass $Db && echo "Sucessfully Import Database in Your Remote Server" || echo "something went wrong"
fi

echo ""
echo ""
echo "....................Start File Importing ............................"
echo ""
echo ""
while true; do
  read -p "Enter File Path On Remote Server for moodledata : " MOODLEDATAPATH
    if [ -z "$MOODLEDATAPATH" ] 
    then
        echo ""
    else
        break
    fi
done
while true; do
  read -p "Enter File Path On Remote Server for Moodle folders to the Remote server : " MOODLEPATH
    if [ -z "$MOODLEPATH" ] 
    then
        echo ""
    else
        break
    fi
done
echo ""
echo ""
sudo rsync -av -e ssh /var/www/html/moodledata35 root@$IP:$MOODLEDATAPATH && echo "Sucessfully Transfer Moodledata in Your Remote Server" || echo "something went wrong"
echo ""
echo ""
sudo rsync -av -e  ssh --exclude '.git/*' /var/www/html/moodle35 root@$IP:$MOODLEPATH && echo "Sucessfully Transfer Moodle in Your Remote Server" || echo "something went wrong"
echo ""
echo ""
echo "..............................For Config.php...................."
echo ""
echo ""
sudo cp /var/www/html/moodle35/config.php /tmp/config.php
sudo sed -i 's/moodle35/'$Db'/g' /tmp/config.php
sudo sed -i 's/sktiwari/'$user'/g' /tmp/config.php
sudo sed -i 's/lingel@35/'$Pass'/g' /tmp/config.php
sudo sed -i 's/dev.testremote.com/165.22.210.237\/testmoodle\/moodle35/g' /tmp/config.php 
sudo chown -R www-data:www-data /tmp/config.php
sudo rsync -av -e ssh config.php root@$IP:$MOODLEPATH/moodle35
echo ""
echo ""
echo ""
echo "Job Done Now Check Remote Server URL"


