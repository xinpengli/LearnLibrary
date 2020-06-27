#!/bin/bash
ping -c 1 $host

echo "$war_list  $restart_tomcat $tomcat $host $branch  $JOB_NAME   $JOB_BASE_NAME  $WORKSPACE"
upload=/tmp/
###修改war名称，例：beetle  修改为 beetle.war
war_list=`echo $war_list| sed 's/,/.war,/g' | sed 's/$/.war/g' `
echo "war_list   $war_list"

if [ -z "$action_tomcat" ]
then
    action_tomcat=$tomcat
fi

function push_file {    
    cd work_build
    scp -P40001 `echo $war_list | tr ',' ' ' `  $host:$upload
    echo "`date` 开始部署$war"
    ###修改war_list参数，添加远程上传路径
    war_list=`echo $war_list| sed "s#^#$upload#g" | sed "s#,#,$upload#g" `
    echo "ssh root@$host -p40001 "sh /usr/local/geekplus/script_tools/tomcat_deploy.sh $tomcat $war_list $action_tomcat $action""
    ssh root@$host -p40001 "sh /usr/local/geekplus/script_tools/tomcat_deploy.sh $tomcat $war_list $action_tomcat $action"
}




##调用部署函数
push_file 


