# How backup works ?

Jenkins plugin Periodic Backup Manager create backup into jenkins server with tar.gz
After it , cronjob automate run script , script checking into directory where stored tar.gz
If have backup.tar.gz , script automaticly push to s3 and delete after pushing.
All steps are automatically you can only monitoring for stability


### For backup you need to AWS account S3 bucket and Linux Server where Jenkins.

# Linux steps.
1. sudo su
2. cd ~/
3. git clone https://github.com/vndark/jenkins-backup-s3.git
4. mkdir permanent && mkdir tmp
5. If have mount disk example ` mount sdb1 /jenkinsbackup
   and create permanent and tmp dir in jenkinsbackup
6. Open jenkins-backup-s3.sh via nano or vim , and edit path to directory
   
# AWS S3 steps.
1. Go to S3 and create bucket example ` backup-jenkins or jenkins-backup.
2. Copy bucket url and paste into jenkins-backup-s3.sh on the line where s3 cp url
3. You can enable versioning and configure lifecycle rule for replace backup file and save old versions.

# Jenkins steps.
1. Go to manage plugins
2. Install plugin "Periodic Backup Manager"
3. Go to settings Jenkins scroll down open Periodic Backup Manager
4. Set cron time when start jenkins backuping
5. set tmp path example ` /root/tmp
6. Mark the fullbackup button
7. Storage Strategy - tar.gz
8. Backup Location example ` /root/permanent  and press ENABLE THIS LOCATION.

# Cron job steps.
1. crontab -e with nano or vim
2. You can generate time on website > https://crontab.guru
3. Your job in cron , set time after Periodic Backup Manager Backup example `  * * * * * /root/jenkins-backup-s3.sh
