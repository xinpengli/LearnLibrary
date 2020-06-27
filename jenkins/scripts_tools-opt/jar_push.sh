#!/bin/bash
###同步配置文件并将构建好的war包上传到git服务器
##定义重新构建后的工作目录
#client=branch
#client=langyin
ping -c 3 $host

branch=`echo $branch | sed 's#origin/##' `
client=$1
workdir=work_build
commit=`git rev-parse --short HEAD`

if [ -n "${commit_id}"  ]
then
    echo "检测到手动输入了commit_id" ${commit_id}
    branch=commit_id
fi

dates=`date +%F_%H-%M-%S`
app_build="${branch}__${commit}__${dates}"
echo "app_build=${app_build}" > variable.tmp
echo "app_dir=${app_dir}" >> variable.tmp


rm -rf  $workdir
mkdir -p $workdir/${app_dir}
cd $workdir
git init
git remote add origin http://gitlab.geekplus.cc/system/publish.git



echo "拷贝target目录下的构建包和resources到工作目录下"
cp -a ../*/target/*.jar $app_dir
cp -a ../*/target/resources $app_dir



echo '##检查本地是否创建这个分支,否就创建,并切换至此分支'
git checkout  -b $client   

##同步仓库，选择哪个客户分支
git pull origin $client


###覆盖配置文件
echo "`date` INFO 覆盖配置文件"
/usr/bin/cp -a jar-config/$app_dir  .

echo "压缩打包"

tar zcf ${app_dir}.tar.gz $app_dir

#sh /root/.jenkins/scripts_tools/scan_pom_project.sh
#推送到远程主机
job=$JOB_NAME
#conf_file=${host}_version_conf
#cd ..
conf_file=version.conf
#source ./variable.tmp
#echo  app_build:  $app_build
upload=/tmp/$job/$app_build

function push_file {
    ssh $host -p40001 "mkdir -p $upload"
    scp -P40001 ${app_dir}.tar.gz   $host:$upload
}

###更新 deploy 项目时的选项列表
function remote_version {
   list=`ssh $host -p40001 "ls -lt $upload/../"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ',' | sed 's/,$//' `
   cd /root/.jenkins/workspace
   echo  $job= >> $conf_file
   sed -i "/^$job=/d" $conf_file
   echo $job=$list >> $conf_file
}

###更新app_dir列表
function update_appdir {
    cd /root/.jenkins/workspace
    echo  $job= >> appdir_list.conf
    sed -i "/^$job=/d" appdir_list.conf
    echo $job=$app_dir >> appdir_list.conf
}

push_file
remote_version
#update_appdir
