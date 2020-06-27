#!/bin/bash
###使用xtrabackup对mysql数据库进行热备
basedir=/usr/local/geekplus/backup/mysql_data
basedir_test=/usr/local/geekplus/backup/mysql_data/test
mkdir -p $basedir/{day,week,month}

host=127.0.0.1
tohost=172.16.3.47
port=3306
user=backup
passwd=PKZRX2q#ziFk
bak_dir=`date +%F_%H-%M-%S`
tar_file=$1.tar.bz2

cd $basedir/day/
mkdir -p $1

innobackupex --host=$host --user=$user  --password=$passwd  --port=$port --no-timestamp $1
if [ $? != 0 ]
then
    echo "`date ` 备份失败，请检查备份脚本"
    rm -rf $1
    exit 1
fi
#innobackupex --host=$host --user=$user  --password=$passwd  --port=$port --stream=tar   /tmp | gzip ->/tmp/t1.tgz
##压缩备份文件
echo "`date` 使用bzip2进行压缩，如果报错，请检查bzip2软件是否安装"
tar cjf $tar_file $1
rm -rf $1
##每日份备份文件,保留30天
find $basedir/day/  -mtime +15 | xargs rm -rf

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

##备份完成后，上传备份文件到指定的库部分服务器上

scp -r $tar_file root@$tohost:$basedir_test
echo "上传备份文件"$tar_file"到库备份服务"
