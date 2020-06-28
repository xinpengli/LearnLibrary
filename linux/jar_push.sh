#!/bin/bash
###同步配置文件并将构建好的war包上传到git服务器
##定义重新构建后的工作目录
ping -c 3  $host

client=$config_branch
configBranch=$config_branch
workdir=work_build
jarpath=/home/test-tools/maptest
branch=`echo $branch | sed 's#origin/##' `
commit=`git rev-parse --short HEAD`

if [ -n "${commit_id}"  ]
then
    echo "检测到手动输入了commit_id" ${commit_id}
    branch=commit_id
fi

dates=`date +%F_%H-%M-%S`
app_dir=$jar_dir
app_build="${branch}__${commit}__${dates}"
job=$JOB_NAME
upload=/tmp/$job/$app_build
echo "app_build=${app_build}" > variable.tmp
echo "app_dir=${app_dir}" >> variable.tmp
echo "upload=${upload}" >> variable.tmp


rm -rf  $workdir
mkdir -p $workdir
cd $workdir

mkdir -p jarfile


echo "拷贝build的jar到work_build下"

find ../ -name '*.jar' | grep -v 'work_build' | xargs -l1 cp -t ./jarfile

cp -rf ../*/target/resources ./jarfile
git init
git remote add origin git@gitlab.geekplus.cc:system_test/server_config.git

git checkout  -b $configBranch
##同步仓库，选择哪个客户分支
git pull origin $configBranch
cp -rf server_config/jar-config/resources/  ./jarfile/resources

##创建jafilepath -p如果有就不再创建，
ssh $host -p40001 "mkdir -p $jarpath"
scp -rf -P40001 jarfile   $host:$jarpath
