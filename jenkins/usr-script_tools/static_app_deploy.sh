#!/bin/bash
##backup
source /etc/profile

date=`date +%F_%H-%M-%S`
gz_path=$1
app_name=`basename $gz_path |  awk -F. '{print $1}'`
bak_dir=/usr/local/geekplus/backup/$app_name/$date
app_dir=/usr/local/geekplus/wwwroot/static/
mkdir -p $bak_dir &> /dev/null
mkdir -p $app_dir &> /dev/null

cd $app_dir
##备份当前文件
tar czf ${app_name}.tar.gz ${app_name}
mv ${app_name}.tar.gz $bak_dir

echo "删除旧的app文件目录"
rm  -rf $app_name
cp $gz_path  .
tar xf ${app_name}.tar.gz
rm -f ${app_name}.tar.gz
#检验
chown -R nginx $app_dir
ls -lhtr


