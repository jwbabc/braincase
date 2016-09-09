#!/bin/sh
FILENAME=$1
DATABASE=$2
echo "Restoring localhost db from local file $FILENAME..."
gunzip < /home/tptadmin/dumps/$FILENAME | mysql --user=user --password=password $DATABASE
echo 'Done.'
