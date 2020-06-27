#!/bin/bash
##backup
#停止，启动，重启服务的命令 pm2 stop/start/restart /usr/local/geekplus/node_apps/vipToolsServices/app.js
source /etc/profile
date=`date +%F_%H-%M-%S`
node_dir=/usr/local/geekplus/node_apps/
bak_dir=/usr/local/geekplus/backup/node_apps/$date
gz_path=$1
mkdir -p $bak_dir &> /dev/null
mkdir -p $node_dir &> /dev/null

cd $node_dir
##备份当前文件
tar czf wms_tools.tar.gz wms_tools
mv wms_tools.tar.gz $bak_dir

#停止 pm2 stop 
pm2 stop $node_dir/wms_tools/app.js

rm  -rf wms_tools
cp $gz_path  .
tar xf `basename $gz_path`
ls -lhtr

##启动app
pm2 start $node_dir/wms_tools/app.js

