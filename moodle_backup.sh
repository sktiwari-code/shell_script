#!/bin/bash
clear

#check user root or not

if [ "$(whoami)" == "root" ] ; then
    echo ".................Now Start Migrate Process....................."
    echo ""
    echo ""
else
    echo -e "\nPlease Script Run Using Sudo First\n"
    exit;
fi

#enter required fields

read -p "Enter Remote DB Host : " DBHOST
while true; do
  read -p "Enter Database User :" DBUSER
    if [ -z "$DBUSER" ] 
    then
        echo ""
    else
        break
    fi
done
while true; do
  read -sp "Enter Database Password :" DBPASS
    if [ -z "$DBPASS" ] 
    then
        echo ""
    else
        echo ""
        break
    fi
done
while true; do
  read -p "Enter Database Name :" DB
    if [ -z "$DB" ] 
    then
        echo ""
    else
        break
    fi
done

while true; do
  read -p "Enter Moodledata Directory Source Path :" MDSPATH
    if [ ! -d "$MDSPATH" ] 
    then
        echo -e "\nDirectory ".$MDSPATH." DOES NOT exists.\n" 
    else
        break
    fi
done

while true; do
  read -p "Enter Moodle Directory Source Path :" MSPATH
    if [ ! -d "$MSPATH" ] 
    then
        echo -e "\nDirectory ".$MSPATH." DOES NOT exists.\n" 
    else
        break
    fi
done

while true; do
  read -p "Enter Backup Path :" BKPATH
    if [ ! -d "$BKPATH" ] 
    then
        echo -e "\nDirectory ".$BKPATH." DOES NOT exists.\n" 
    else
        break
    fi
done
sudo apt -y install zip unzip
sudo mkdir /tmp/moodlebackup
TEMPPATH=/tmp/moodlebackup
echo -e "\n...............Start Database Export .....................\n"

#database back code
if [ "$DBHOST" == "" ];
    then
        sudo mysqldump --default-character-set=utf8mb4 -u $DBUSER --password=$DBPASS -C -Q -e --create-options $DB > $TEMPPATH/moodledbbk_`date +%Y%m%d`.sql && echo "Database Export Done" || exit
    else
      sudo mysqldump --default-character-set=utf8mb4 -h $DBHOST -u $DBUSER --password=$DBPASS -C -Q -e --create-options $DB > $TEMPPATH/moodledbbk_`date +%Y%m%d`.sql && echo "Database Export Done" || exit
      
fi

echo -e "\n...............Start Moodle files Backup .....................\n"

sudo cp -r /$MDSPATH /$TEMPPATH  && echo -e "\n...............Moodledata Directory Copy Done............\n" || echo -e "\nSome problem occurred\n"
sudo cp -r /$MSPATH /$TEMPPATH  && echo -e "\n...............Moodle Directory Copy Done............\n" || echo -e "\nSome problem occurr\n"

sudo zip -r /$BKPATH/moodlebk_`date +%Y%m%d`.zip  /$TEMPPATH  && echo -e "\n...............Moodle backup Done............\n" || echo -e "\nSome problem occurred\n"

sudo rm -rf /tmp/moodlebackup/

echo -e "\n ...............  See Backup File .........\n"
sudo find /$BKPATH/ -type f | grep moodlebk_`date +%Y%m%d`.zip
echo -e "\n"

