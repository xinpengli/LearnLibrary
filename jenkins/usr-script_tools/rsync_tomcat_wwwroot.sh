#!/bin/bash
#创建rsync备份目录
mkdir -p /usr/local/geekplus/backup/rsync_tomcat_bak/
#通过rsync备份app服务器上面的tomcat和wwwroot目录
rsync -azp --delete -e "ssh -p40001"  root@app:/usr/local/geekplus/tomcat-api/webapps/* /usr/local/geekplus/backup/rsync_tomcat_bak/
rsync -azp --delete -e "ssh -p40001"  root@app:/usr/local/geekplus/tomcat-rms/webapps/* /usr/local/geekplus/backup/rsync_tomcat_bak/
rsync -azp --delete -e "ssh -p40001"  root@app:/usr/local/geekplus/tomcat-wms/webapps/* /usr/local/geekplus/backup/rsync_tomcat_bak/
rsync -azp --delete -e "ssh -p40001"  root@app:/usr/local/geekplus/wwwroot/* /usr/local/geekplus/backup/rsync_tomcat_bak/
