#!/bin/bash
###同步配置文件并将构建好的war包上传到git服务器
##定义重新构建后的工作目录
ping -c 3  $host

client=$config_branch
configBranch=$config_branch
workdir=work_build
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


echo "拷贝build的jar到work_build下"

find ../ -name '*.jar' | grep -v 'work_build' | xargs -l1 cp -t .
if [ -n "$code" ]
then
	cp -a ../*/target/$code $app_dir
else
	cp -a ../*/target/*.jar $app_dir
fi

cp -a ../*/target/resources $app_dir


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


##创建这个空分支,并切换至此分支
git checkout  -b $configBranch
##同步仓库，选择哪个客户分支
git pull origin $configBranch


###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
#/usr/bin/cp -a jar-config/$app_dir  .
rsync -va  jar-config/$app_dir/ $app_dir/

echo "压缩打包"

tar zcf ${app_dir}.tar.gz $app_dir


function push_file {
    ssh $host -p40001 "mkdir -p $upload"
    scp -P40001 ${app_dir}.tar.gz   $host:$upload
}

###更新 deploy 项目时的选项列表
function remote_version {
   conf_file=version.conf
   list=`ssh $host -p40001 "ls -lt $upload/../"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ',' | sed 's/,$//' `
   echo  $job= >> $conf_file
   sed -i "/^$job=/d" $conf_file
   echo $job=$list >> $conf_file
}

###更新app_dir列表
function update_appdir {
    echo  $job= >> appdir_list.conf
    sed -i "/^$job=/d" appdir_list.conf
    echo $job=$app_dir >> appdir_list.conf
}

push_file
remote_version
