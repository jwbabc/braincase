#!/bin/sh
DATE=$(date +%d%m%Y_%I%M%p)
DATABASE=$1
FILENAME=$1_$DATE.sql.gz
echo "dumping localhost $DATABASE db..."
mysqldump --user=user --password=password $DATABASE --quick --add-drop-table --extended-insert --force | gzip >/home/tptadmin/dumps/$FILENAME
echo 'Done.'
