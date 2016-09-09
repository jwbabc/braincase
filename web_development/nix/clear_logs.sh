echo 'Beginning backup of logs'
cd /Applications/XAMPP/xamppfiles/logs
mv access_log access_log.old
mv error_log error_log.old
echo 'Restarting server - waiting 20 seconds'
apachectl graceful
sleep 20
echo 'Compressing log files into a gz archive'
gzip access_log.old error_log.old
echo 'Logs backed up and cleared!'
