#!/bin/bash

# You can setup script for cronjob command -> crontab -e | after changing and saving -> service cron reload
# 0 7 * * * /root/jenkins-backup-s3.sh

#SCRIPT backup and PUSH TO AWS S3

#Set backup time and Country
backup_time=$(TZ=":USA/Central" date "+%Y-%m-%d**%H:%M:%S") # Or you can setup your time zone
path_backup="/root/jenkins_backup/permanent" # For example I backup my jenkins to /root/
s3bcuketurl="s3://examplebucket/bucket/filename.tar.gz" # Rememmber !!! set file name example` backupjenkins.tar.gz

cd $path_backup

for var in $( find $path_backup -ctime  -3 \( -name "*.tar.gz" -o  -name "backup_*.tar.gz" \)  -print ); do aws s3 cp $var $s3bcuketurl ;done
# Log to file backup success or not
if [[ -f $var ]]; then
	echo "Success backup to S3  | Time  - $backup_time" >> $path_backup/backup_logs.log
 elif [[ ! -f $var ]]; then
 	echo "Failed backup files are not exists in directory | Time- $backup_time" >> $path_backup/backup_errors.log
fi

# Clean after pushing zip to s3
cd $path_backup
for tar in $( find $path_backup -ctime  -3 \( -name "*.tar.gz" -o  -name "backup_*.tar.gz" \)  -print ); do rm $tar ;done
if [[ ! -f $tar ]]; then
	echo "After backup tar.gz files are deleted  | TIme - $backup_time" >> $path_backup/backup_logs.log
fi

exit 0
