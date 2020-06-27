#!/bin/bash
##backup
source /etc/profile

date=`date +%F_%H-%M-%S`
app_dir=/usr/local/geekplus/wwwroot/static/
bak_dir=/usr/local/geekplus/backup/wms_tools_build/$date
gz_path=$1
mkdir -p $bak_dir &> /dev/null
mkdir -p $app_dir &> /dev/null

cd $app_dir
##备份当前文件
tar czf wms_tools_build.tar.gz wms_tools_build
mv wms_tools_build.tar.gz $bak_dir

#删除app文件目录
rm  -rf wms_tools_build
cp $gz_path  .
tar xf `basename $gz_path`
#检验
rm -f wms_tools_build.tar.gz
chown -R nginx:nginx $app_dir
ls -lhtr


