# Cron task for www.nextavenue.org
*/15 * * * * /usr/bin/wget -qO - t 1 http://www.nextavenue.org/cron.php 2>&1 >>/dev/null