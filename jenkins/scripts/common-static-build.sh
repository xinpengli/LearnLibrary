#!/bin/bash
echo "$war_list  $restart_tomcat $tomcat $host $branch  $JOB_NAME   $JOB_BASE_NAME  $WORKSPACE"
#configBranch=vip 从哪一个配置库拉取配置文件
ping -c 3 $host
configBranch=$config_branch

branch=`echo $branch | sed 's#origin/##' `
workdir=work_build
commit=`git rev-parse --short HEAD`

if [ -n "${commit_id}"  ]
then
    echo "检测到手动输入了commit_id" ${commit_id}
    branch=commit_id
fi

scp_dir="${branch}__${commit}__`date +%F_%H-%M-%S`"

##app_dir APP目录名称
src_build=$1
app_dir=$2
job=$JOB_NAME
upload=/tmp/$job/$scp_dir

##variable.tmp用于两个不同脚本之间的变量传递
echo "scp_dir=$scp_dir" > variable.tmp
echo "file_path=$upload/${app_dir}.tar.gz" >> variable.tmp
echo "app_dir=$app_dir" >> variable.tmp


##删除之前的构建记录
rm -rf  $workdir
mkdir -p  $workdir 

##复制原文件到工作目录(构建名称与目标目录不同时，重命名，例如，build  --> mantis_build)
echo "复制到工作目录： cp -a $src_build $workdir/$app_dir"
cp -a $src_build $workdir/$app_dir
cd $workdir

##接取配置库
git init


if [ "$config_type" == "test" ]
then
    git remote add origin git@gitlab.geekplus.cc:system_test/server_config.git
elif [ "$config_type" == "dev" ]
then
   git remote add origin git@gitlab.geekplus.cc:app_config/dev_publish.git
else
    ##默认关联的配置库地址
    git remote add origin git@gitlab.geekplus.cc:system/publish.git
fi
	

##否创建这个空分支,并切换至此分支
git checkout  -b $configBranch
##同步仓库，选择哪个客户分支
git pull origin $configBranch


###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
#/usr/bin/cp -a frontend-config/$app_dir $app_dir
if [ -d frontend-config/$app_dir/ ]
then
    rsync -va  frontend-config/$app_dir/ $app_dir/
fi

echo "压缩 打包"
tar czf ${app_dir}.tar.gz $app_dir


#推送到远程主机
conf_file=version.conf


function push_file {
    ssh $host -p40001 "mkdir -p $upload"
    scp -P40001 ${app_dir}.tar.gz  $host:$upload
}

###更新 deploy 项目时的version选项列表
function remote_version {
   list=`ssh $host -p40001 "ls -lt $upload/../"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ','  | sed 's/,$//' `
   echo  $job= >> $conf_file
   sed -i "/^$job=/d" $conf_file
   echo $job=$list >> $conf_file
}


push_file
remote_version

