#!/bin/bash
##backup
source /etc/profile


gz_path=$1
app=$2
date=`date +%F_%H-%M-%S`
app_dir=/usr/local/geekplus/$app
bak_dir=/usr/local/geekplus/backup/$app/$date
mkdir -p $bak_dir &> /dev/null
mkdir -p $app_dir &> /dev/null

if [ ! -f $gz_path ]
then
    echo "ERROR  包不存在,退出部署程序！！！"
    exit 1
fi
    

cd /usr/local/geekplus/
##备份当前文件
tar czf ${app}.tar.gz ${app}
mv ${app}.tar.gz $bak_dir

/usr/local/geekplus/script_tools/jar_manager.py  stop $app
cp $gz_path  .
tar xf `basename $gz_path` 

#删除app文件目录
rm  -rf ${app}.tar.gz
#检验
ls -lhtr

/usr/local/geekplus/script_tools/jar_manager.py start $app


