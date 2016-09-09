#!/bin/sh
DATE=$(date +%d%m%Y_%I%M%p)
SITENAME=$1
FILENAME=$1_$DATE
echo "dumping localhost $SITENAME to tar.gz..."
tar -cvzpf $FILENAME.tar.gz /Applications/XAMPP/htdocs/$SITENAME
mv $FILENAME.tar.gz /Users/jback/Desktop/$FILENAME.tar.gz
echo 'Done.'
