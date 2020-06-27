#!/bin/bash
###同步配置文件并将构建好的war包上传到git服务器
##定义重新构建后的工作目录
#client=branch
#client=langyin
branch=`echo $branch | sed 's#origin/##' `
client=$1
workdir=work_build
commit=`git rev-parse --short HEAD`
dates=`date +%F_%H-%M-%S`
war_build="build/${branch}__${commit}__${dates}"
echo "war_build=${branch}__${commit}__${dates}" > variable.tmp
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

cp -a  ../*/*/*.war .

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

###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
/usr/bin/cp -r config/* .

##重新构建war包
for app in $app_list
do
{
    echo "`date` INFO  重新构建 $app"
    jar cf $app -C  `echo $app | awk -F. '{print $1}'` . 
    cp -a $app $war_build 
}&
done
wait

##将更新后war包 push 到git仓库
#if [ "$push"  = "push" ]
#then
#    git add build --ignore-removal
#    git commit -m "`date` 重新构建于分支：${branch} "
#    git push origin $client &
#fi

##更新项目列表
sh /root/.jenkins/scripts_tools/scan_pom_project.sh
