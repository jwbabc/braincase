# Synchronizes files from staging to App1L - /var/www/html/
rsync -avz --exclude-from 'sync_exclude_list.txt' --delete /var/www/html/* sync-user@syncip:/var/www/html/
# Synchronizes files from staging to App2L - /var/www/html/
rsync -avz --exclude-from 'sync_exclude_list.txt' --delete /var/www/html/* sync-user@syncip:/var/www/html/
# Synchronizes files from staging to App3L - /var/www/html/
rsync -avz --exclude-from 'sync_exclude_list.txt' --delete /var/www/html/* sync-user@syncip:/var/www/html/
