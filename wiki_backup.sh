#!/bin/bash
#
# wiki_backup.sh
#
#ref : http://zetawiki.com/wiki/%EB%AF%B8%EB%94%94%EC%96%B4%EC%9C%84%ED%82%A4_%EC%97%85%EA%B7%B8%EB%A0%88%EC%9D%B4%EB%93%9C_1.18.0_%E2%86%92_1.21.2

## To generate this file is to back it up to mediawiki file and databases.
# duplicate the wiki file
BACKUP_PATH=/var/www/html/DB_BACKUP
############################
# !! WARNING !! w folder was made with symbolic link. so always be careful to remove w folder.
w_realfolder=/usr/share/w
w_linkfolder=/var/www/html/w
############################
gnu_folder=/var/www/html/gnuboard5
today=$(date +%Y%m%d)
amonthago=$(date '+%Y%m%d' -d '1 month ago')

# remove old files
rm -r $BACKUP_PATH-$amonthago
rm -r $w_linkfolder-$amonthago # Definitely remove linked folder.
rm -r $gnu_folder-$amonthago
rm -r /var/www/html/backup-$amonthago.tar.gz

# create the new folder for backup
if [ -d $BACKUP_PATH-$today ];then
    exit 0
else
    mkdir $BACKUP_PATH-$today
fi

cd $BACKUP_PATH-$today
cp -rv $w_realfolder $w_linkfolder-$today
cp -av $gnu_folder $gnu_folder-$today

du -hs $w_realfolder
du -hs $w_linkfolder-$today
du -hs $gnu_folder
du -hs $gnu_folder-$today

# db backup.
# kpswiki has two databases. wiki database and gnuboard database 
db_name1=my_wiki
db_name2=gnudb
db_pass=password # db_pass means database password. should change your database password
mysqldump -uroot -p$db_pass --databases $db_name1 > $today-$db_name1-db.sql
mysqldump -uroot -p$db_pass --databases $db_name2 > $today-$db_name2-db.sql
ls -ah *.sql

# to compress daily files
tar -zcvf ../backup-$today.tar.gz ../w-$today ../gnuboard5-$today $today-$db_name1-db.sql $today-$db_name2-db.sql 
