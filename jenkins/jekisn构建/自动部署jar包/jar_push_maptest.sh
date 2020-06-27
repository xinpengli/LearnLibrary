#!/bin/bash
##定义重新构建后的工作目录
client=$config_branch
configBranch=$config_branch
workdir=work_build
jarpath=/home/test-tools/maptest
branch=`echo $branch | sed 's#origin/##'`
commit=`git rev-parse --short HEAD`
if [-n "${commit_id}"]
then
echo "检测到手动输入了commit_id" ${commit_id}
branch=commit_id
fi
job=$JOB_NAME
upload=/tmp/$job/$app_build
rm -rf  $workdir
mkdir -p $workdir
cd $workdir
mkdir -p jarfile/resources
echo "拷贝build的jar到work_build下"
find ../ -name $job.jar | grep -v 'work_build' | xargs -l1 cp -t ./jarfile
cp -rf ../target/resources/lib ./jarfile/resources
git init
git remote add origin git@gitlab.geekplus.cc:system_test/server_config.git
git checkout  -b $configBranch
##同步仓库，选择哪个客户分支
git pull origin $configBranch
cp -rf jar-config/resources/*  ./jarfile/resources
##创建jafilepath -p如果有就不再创建，
ssh $host -p40001 "mkdir -p $jarpath"
scp -r -P40001 ./jarfile/*   $host:$jarpath
scp -r -P40001 /opt/jenkins_config/scripts/restart_maptest.sh  $host:$jarpath
ssh $host -p40001 "sh $jarpath/restart_maptest.sh $job"
