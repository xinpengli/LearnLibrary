#!/bin/bash
###备份mysql-binlog日志文件，并压缩存放至/usr/local/geekplus/backup/mysql-binlog/
backupDir=/usr/local/geekplus/backup/mysql-binlog/
echo "备份目录 $backupDir"
mkdir -p $backupDir
cd /usr/local/geekplus/data/mysql/
logList=`find ./mysql-bin.* -mtime +3 ! -name '*.tgz'`
for file in $logList
do
    date=`ls -l --full-time $file | awk '{print $6"-"$7}' |tr '-' '_' |awk -F'.' '{print $1}' |tr ':' '_'`
    filename=$file"-"$date".tbz2"
    echo "开始压缩备份 $file  "
    tar -jcf $backupDir$filename $file 
done
