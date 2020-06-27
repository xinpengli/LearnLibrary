#!/bin/bash
##先构建war包，同步到服务器upload目录，等待下一次执行构建
#ping -c 1 $host

conf_file=version.conf
#source ./variable.tmp
#echo  war_build:  $war_build
upload=/usr/local/geekplus/backup/mysql_data
dir_name=$1
mysql_back_file=$2
job=$dir_name

echo '' >$conf_file

###更新 mysql_back_file 备份文件时的选项列表
function remote_version {
   list=`ssh -p40001 root@172.16.19.14 "ls -lt $upload/$dir_name"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ',' `
   cd /root/.jenkins/scripts_tools/ceshi
#   echo  $list= >> $conf_file
#   sed -i "/^$job=/d" $conf_file
#   echo -n $job= >> $conf_file
   echo $job=$list >> $conf_file
#  ls $job=$list >> $conf_file
#   echo >> $conf_file
}

remote_version
