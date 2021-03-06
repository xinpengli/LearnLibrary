#!/bin/bash
##先构建war包，同步到服务器upload目录，等待下一次执行构建
#job=`echo $JOB_NAME | awk -F- '{print $1}'`
job=$JOB_NAME
#conf_file=${host}_version_conf
ping -c 1 $host

#   仿真包部署时的项目路径
fz_project=`echo  $JOB_NAME | sed 's/-push.*//'| sed 's/^/fz-/'`

echo "进入仿真部署的工作目录,并加载相关变量"
cd  ../$fz_project
conf_file=version.conf
source ./variable.tmp
echo  war_build:  $war_build
upload=/tmp/build/$job/$war_build

war_list=`echo $war_list| sed 's/,/.war,/g' | sed 's/$/.war/g' `
echo "war_list   $war_list"


function push_file {    
    cd work_build/
    ssh $host -p40001 "mkdir -p $upload"
    scp -P40001 `echo $war_list | tr ',' ' ' `  $host:$upload
}

###更新 deploy 项目时的选项列表
function remote_version {
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


###更新仿真地址包列表，存入当前部署的工作目录
function fz_dir {
    cd /root/.jenkins/workspace/fz_dir/
    client=`echo $JOB_NAME|awk -F'-' '{print $2}'`
    echo "$JOB_NAME=$WORKSPACE" >> $client
    sed -i "/^$JOB_NAME=/d" $client
    echo "$JOB_NAME=$WORKSPACE" >> $client
}

push_file 
remote_version
