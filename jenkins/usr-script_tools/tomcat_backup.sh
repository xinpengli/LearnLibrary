#!/bin/bash
##备份tomcat 应用程序包，并压缩存放
date=`date +%F_%H-%M-%S`
app=$1
bak_dir=/usr/local/geekplus/backup/tomcat_bak/$app/$date
mkdir -p $bak_dir &> /dev/null
basedir=/usr/local/geekplus/

##备份webapps 目录下的程序，所以webapps目录下不要放任务其他无关文件
cp -r $basedir$app/webapps/* $bak_dir &> /dev/null
cp $basedir$app/conf/server.xml $bak_dir
cp $basedir$app/bin/catalina.sh $bak_dir

cd $bak_dir/../
tar zcf "$date".tar.gz  $date
rm -rf $date
