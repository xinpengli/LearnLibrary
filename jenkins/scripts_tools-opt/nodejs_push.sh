#!/bin/bash
echo "$war_list  $restart_tomcat $tomcat $host $branch  $JOB_NAME   $JOB_BASE_NAME  $WORKSPACE"
###同步配置文件并将构建好的上传到git服务器
##定义重新构建后的工作目录
#client=langyin 从哪一个配置库拉取配置文件
ping -c 1 $host

client=$1
branch=`echo $branch | sed 's#origin/##' `
workdir=work_build
commit=`git rev-parse --short HEAD`

if [ -n "${commit_id}"  ]
then
    echo "检测到手动输入了commit_id" ${commit_id}
    branch=commit_id
fi

scp_dir="node_apps/${branch}__${commit}__`date +%F_%H-%M-%S`"
app_dir=wms_tools
##variable.tmp用于两个不同脚本之间的变量传递


##删除之前的构建记录
rm -rf  $workdir

mkdir -p  $workdir/$app_dir
##复制原文件到工作目录
rsync -a * --exclude work_build $workdir/$app_dir

cd $workdir
echo "scp_dir=$scp_dir" > variable.tmp
git init
git remote add origin http://gitlab.geekplus.cc/system/publish.git


##检查本地是否创建这个分支,否就创建,并切换至此分支
git checkout  -b $client

##同步仓库，选择哪个客户分支
git pull origin $client

#mkdir -p $scp_dir

###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
/usr/bin/cp -a node-app-config/* .

tar czf ${app_dir}.tar.gz $app_dir
#cp -a ${app_dir}.tar.gz $scp_dir


#推送到远程主机
job=$JOB_NAME
#conf_file=${host}_version_conf
conf_file=version.conf
source ./variable.tmp

upload=/tmp/$job/$scp_dir

function push_file {
    ssh $host -p40001 "mkdir -p $upload"
    scp -P40001 ${app_dir}.tar.gz  $host:$upload
}

###更新 deploy 项目时的version选项列表
function remote_version {
   list=`ssh $host -p40001 "ls -lt $upload/../"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ','  | sed 's/,$//'`
   cd /root/.jenkins/workspace
   echo  $job= >> $conf_file
   sed -i "/^$job=/d" $conf_file
   echo $job=$list >> $conf_file
}


push_file
#remote_version

