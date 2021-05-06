#!/bin/bash

# 0 7 * * * /root/jenkins-backup-s3.sh - FOR CRONTAB JOB

#SCRIPT backup and PUSH TO AWS S3

#Set backup time and Country
backup_time=$(TZ=":USA/Central" date "+%Y-%m-%d**%H:%M:%S")
path_backup="/root/jenkins_backup/permanent"

cd $path_backup
for var in $( find $path_backup -ctime  -3 \( -name "*.tar.gz" -o  -name "backup_*.tar.gz" \)  -print ); do aws s3 cp $var s3://url-to-s3/backup_latest.tar.gz ;done
#Log to file backup success or not
if [[ -f $var ]]; then
	echo "Success backup to S3  | USA-Central  - $backup_time" >> $path_backup/backup_logs.log
 elif [[ ! -f $var ]]; then
 	echo "Failed backup files are not exists in directory | USA-Central - $backup_time" >> $path_backup/backup_errors.log
fi
#Clean after pushing zip to s3
cd $path_backup
for tar in $( find $path_backup -ctime  -3 \( -name "*.tar.gz" -o  -name "backup_*.tar.gz" \)  -print ); do rm $tar ;done
if [[ ! -f $tar ]]; then
	echo "After backup tar.gz files are deleted  | USA-Central - $backup_time" >> $path_backup/backup_logs.log
fi

exit 0
