#!/bin/bash
echo "$war_list  $restart_tomcat $tomcat $host $branch  $JOB_NAME   $JOB_BASE_NAME  $WORKSPACE"
upload=/tmp/
git ls-remote -h  -t git@gitlab.geekplus.cc:system/publish.git  | awk -F'/' 'BEGIN {print "branch="} {print $NF}' | tr '\n' ',' > /root/.jenkins/workspace/config_branch.conf
###同步配置文件并将构建好的上传到git服务器
##定义重新构建后的工作目录
#client=branch
#client=langyin
branch=`echo $branch | sed 's#origin/##' `
client=$1
workdir=work_build
commit=`git rev-parse --short HEAD`
if [ -n "${commit_id}"  ]
then
    echo "检测到手动输入了commit_id" ${commit_id}
    branch=commit_id
fi

war_build="frontend-build/${branch}__${commit}__`date +%F_%H-%M-%S`"
##variable.tmp用于两个不同脚本之间的变量传递
echo "war_build=$war_build" > variable.tmp
push=$2


rm -rf  $workdir

if [ -d $workdir ]
then
    cd  $workdir
else
    mkdir $workdir
    cd $workdir
    git init
    git remote add origin http://gitlab.geekplus.cc/system/publish.git
fi


##检查本地是否创建这个分支,否就创建,并切换至此分支
echo '##检查本地是否创建这个分支,否就创建,并切换至此分支'
#git branch | grep $client
if [ `git branch | grep $client | wc -l ` -eq 0 ]
then
    git checkout  -b $client
else
    git checkout   $client
fi



##同步仓库，选择哪个客户分支
git pull origin $client

mkdir -p $war_build

rm -rf build

cp -a ../build .



###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
/usr/bin/cp -a frontend-config/* .
echo "删除serverIP.txt文件"
rm -f frontend-config/build/common/serverIp.txt
rm -f build/common/serverIp.txt

tar czf build.tar.gz build
cp -a build.tar.gz $war_build


ping -c 1 $host

#推送到远程主机
job=$JOB_NAME
#conf_file=${host}_version_conf
cd ..
conf_file=version.conf
source ./variable.tmp
echo  war_build:  $war_build
upload=/tmp/frontend-build/$job/$war_build
function push_file {
    cd work_build/$war_build
    ssh $host -p40001 "mkdir -p $upload"
    scp -P40001 build.tar.gz  $host:$upload
}

###更新 deploy 项目时的选项列表
function remote_version {
   list=`ssh $host -p40001 "ls -lt $upload/../"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ',' | sed 's/,$//' `
   cd /root/.jenkins/workspace
   echo  $job= >> $conf_file
   sed -i "/^$job=/d" $conf_file
   #echo -n $job= >> $conf_file
   echo $job=$list >> $conf_file
   #echo >> $conf_file

}


push_file
remote_version

