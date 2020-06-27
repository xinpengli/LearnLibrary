#!/bin/bash
###使用xtrabackup对mysql数据库进行热备
basedir=/usr/local/geekplus/backup/mysql_data
mkdir -p $basedir/{day,week,month}

host=127.0.0.1
port=3306
user=backup
passwd=PKZRX2q#ziFk
bak_dir=`date +%F_%H-%M-%S`
tar_file=${bak_dir}.tar.bz2

cd $basedir/day/
mkdir -p $bak_dir

innobackupex --host=$host --user=$user  --password=$passwd  --port=$port --no-timestamp $bak_dir
if [ $? != 0 ]
then
    echo "`date ` 备份失败，请检查备份脚本"
    rm -rf $bak_dir
    exit 1
fi
#innobackupex --host=$host --user=$user  --password=$passwd  --port=$port --stream=tar   /tmp | gzip ->/tmp/t1.tgz
##压缩备份文件
echo "`date` 使用bzip2进行压缩，如果报错，请检查bzip2软件是否安装"
tar cjf $tar_file $bak_dir
rm -rf $bak_dir
##每日份备份文件,保留30天
find $basedir/day/  -mtime +30 | xargs rm -rf

##每周星期一CP一份备份文件,保留90天
if [ `date +%w` -eq 1 ]
then
    find $basedir/week/  -mtime +90 | xargs rm -rf
    cp -a $tar_file $basedir/week/
fi


##每月1日CP一份备份文件,保留360天
if [ `date +%d` -eq 1 ]
then
    find $basedir/month/  -mtime +360 | xargs rm -rf
    cp -a $tar_file $basedir/month/
fi
