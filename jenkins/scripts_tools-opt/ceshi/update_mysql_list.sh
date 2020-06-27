#!/bin/bash


echo '' >/root/.jenkins/scripts_tools/ceshi/version.conf

for api in  {langyin,beipei-2,beipei-3,cixing,foshan,lianhuajingxuan,vip10,bps,warehouse,lianhua,guoyao,fisher,acca,shunfeng,bosideng26,feiyada-5,feiyada-7,juanpi,kunshan,suning,youzheng,rongsheng};do

list=`ssh -p40001 root@172.16.19.14 "ls -lt /usr/local/geekplus/backup/mysql_data/$api"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ','`
echo "$api=$list " >> /root/.jenkins/scripts_tools/ceshi/version.conf

done
