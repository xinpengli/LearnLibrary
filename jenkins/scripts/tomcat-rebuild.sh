#!/bin/bash
###同步配置文件并将构建好的war包上传到git服务器
##定义重新构建后的工作目录
#configBranch=配置库

branch=`echo $branch | sed 's#origin/##' `
configBranch=$1
workdir=work_build
commit=`git rev-parse --short HEAD`
dates=`date +%F_%H-%M-%S`
if [ -n "${commit_id}"  ] 
then
    echo "检测到手动输入了commit_id" ${commit_id}
    branch=commit_id
fi

war_build="build/${branch}__${commit}__${dates}"

echo "war_build=${branch}__${commit}__${dates}" > variable.tmp


rm -rf  $workdir

mkdir $workdir
cd $workdir

find ../ -name '*.war' | grep -v 'work_build' | xargs -l1 cp -t .
##解压war包
app_list=`ls *.war`
echo "`date` INFO 找到的war包 $app_list "
for app in $app_list
do
{
    echo "rm  -rf  `echo $app | awk -F. '{print $1}'` "
    rm  -rf  `echo $app | awk -F. '{print $1}'` 
    echo "`date` INFO  开始解压 $app "
    unzip -o $app -d `echo $app | awk -F. '{print $1}'` >/dev/null
    rm -f $app
}&
done
wait


##否创建这个分支并切换至此分支
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


mkdir -p $war_build

###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
/usr/bin/cp -r config/* .

##重新构建war包
for app in $app_list
do
{
    echo "`date` INFO  重新构建 $app"
    jar cf $app -C  `echo $app | awk -F. '{print $1}'` . 
}&
done
wait

