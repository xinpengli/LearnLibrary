#!/bin/bash
###同步配置文件并将构建好的war包上传到git服务器
##定义重新构建后的工作目录
#configBranch=配置库

branch=`echo $branch | sed 's#origin/##' `
configBranch=$1
code=$2
appdir=$3
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

mkdir -p $workdir/$appdir
file=`find ./ -name "$code" `
resources=`dirname $file`/resources
cp $file $workdir/$appdir
cp -a $resources $workdir/$appdir

cd $workdir

##创建这个分支并切换至此分支
echo "同步配置库，并重新打包"
git init

if [ "$config_type" == "test" ]
then
    git remote add origin git@gitlab.geekplus.cc:system_test/server_config.git
else
    ##默认关联的配置库地址
    git remote add origin git@gitlab.geekplus.cc:system/publish.git
fi

##创建这个空分支,并切换至此分支
git checkout  -b $configBranch
##同步仓库，选择哪个客户分支
git pull origin $configBranch

###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
/usr/bin/cp -r jar-config/* .

##打包
echo "打包 $code ==> $appdir"
tar zcf $appdir.tar.gz $appdir
