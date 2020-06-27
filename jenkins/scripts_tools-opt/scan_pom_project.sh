#!/bin/bash
##扫描/root/.jenkins/workspace目录下每一个项目的pom文件，最后生成project war包列表
cd /root/.jenkins/workspace
projects=`ls   |grep -v 'conf$' | grep -v '\.sh$'|grep  -v '\@' |grep -v 'deploy$'`

rm project.list.conf
for pro in $projects
do
    echo -n ${pro}= >> project.list.conf
    ls  $pro/*/target/*.war 2>/dev/null | awk -F'[./]' '{print $(NF-1)}' | tr '\n' ',' | tr '\n' ',' | sed 's/,$//'  >> project.list.conf
    echo -n ',' >> project.list.conf
    ls  $pro/*/*/target/*.war 2>/dev/null | awk -F'[./]' '{print $(NF-1)}' | tr '\n' ',' | tr '\n' ',' | sed 's/,$//'  >> project.list.conf
    echo >> project.list.conf
done	
sed  -i '/=,$/d' project.list.conf
