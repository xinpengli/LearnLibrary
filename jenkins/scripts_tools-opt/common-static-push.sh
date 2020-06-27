#!/bin/bash
appName=$1
echo " appNmae: $appName $war_list  $restart_tomcat $tomcat $host $branch  $JOB_NAME   $JOB_BASE_NAME  $WORKSPACE"

job=$JOB_NAME

ping -c 1 $host

#   仿真包部署时的项目路径
fz_project=`echo  $JOB_NAME | sed 's/-push.*//'| sed 's/^/fz-/'`

echo "进入仿真部署的工作目录,并加载相关变量"
cd  ../$fz_project
##variable.tmp用于两个不同脚本之间的变量传递
. ./variable.tmp

upload=/tmp/$job/$scp_dir

function push_file {
    cd work_build
    ssh $host -p40001 "mkdir -p $upload"
    scp -P40001 rms_build.tar.gz  $host:$upload
}

###更新 deploy 项目时的选项列表
function remote_version {
   conf_file=version.conf
   list=`ssh $host -p40001 "ls -lt $upload/../"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ',' | sed 's/,$//'`
   cd /root/.jenkins/workspace
   echo  $job= >> $conf_file
   echo  ${job}-master= >> $conf_file
   sed -i "/^$job=/d" $conf_file
   sed -i "/^${job}-master=/d" $conf_file
   #echo -n $job= >> $conf_file
   echo $job=$list >> $conf_file
   echo ${job}-master=`echo $list | awk -F, '{print $1}'`  >> $conf_file
   #echo >> $conf_file
}


push_file
remote_version

