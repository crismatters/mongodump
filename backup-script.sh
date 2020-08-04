#!/bin/sh

#=====================================================================
# Set the following variables as per your requirement
#=====================================================================
# Backup directory
BACKUPS_DIR="/home/crismatters/backups/"
# MongoDB Database
MONGO_DATABASE="coedevops"
# MongoDB URI connection string format
MONGODB_URI=$MONGODB_URI
# Days to keep the backup
DAYSTORETAINBACKUP="5"
#=====================================================================
# Output colors & Backup configs
#=====================================================================
RED=`tput setaf 1`
GREEN=`tput setaf 2`
BLUE=`tput setaf 4`
NC=`tput sgr0`
TIMESTAMP=`date +%F-%H_%M`
BACKUP_NAME="$MONGO_DATABASE-$TIMESTAMP"

chars="/-\|"
echo "$BLUE Performing backup of $MONGO_DATABASE $NC"
x=1
while [ $x -le 2 ]
do
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.5
    echo -en "$BLUE --------------------------------------------" "${chars:$i:1}" "\r" "$NC"
  done
  x=$(( $x + 1 ))
done

# Create backup directory
if ! mkdir -p $BACKUPS_DIR; then
  echo "$RED Can't create backup directory in $BACKUPS_DIR. Go and fix it! $NC" 1>&2
  exit 1;
fi;
# Create dump using backup name
mongodump --uri=$MONGODB_URI -o=$BACKUPS_DIR/$BACKUP_NAME
# Compress backup
tar -zcvf $BACKUPS_DIR/$BACKUP_NAME.tgz $BACKUP_NAME
# Delete uncompressed backup
rm -rf $BACKUPS_DIR/$BACKUP_NAME
# Delete backups older than retention period
find $BACKUPS_DIR -type f -mtime +$DAYSTORETAINBACKUP -exec rm {} +
echo "$GREEN -------------------------------------------- $NC"
echo "$GREEN Database backup complete! $NC"
