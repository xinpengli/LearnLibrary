#!/bin/bash
ping -c 1 $host

upload=/tmp/
war_list=`echo $war_list| sed 's/,/.war,/g' | sed 's/$/.war/g' `
echo "war_list   $war_list"

action_tomcat=$tomcat

function push_file {    
    cd work_build
    scp -P40001 `echo $war_list | tr ',' ' ' `  $host:$upload
    scp -P40001 -r /opt/liquibase-3.6.2 $host:/opt/liquibase-3.6.2
    echo "`date` 开始部署$war"
    ###修改war_list参数，添加远程上传路径
    war_list=`echo $war_list| sed "s#^#$upload#g" | sed "s#,#,$upload#g" `
    liquibase_list=`echo $war_list | tr ',' ' ' `
    echo "先执行数据库升级"
    for i in $liquibase_list
    do 
       ssh root@$host -p40001 "source /etc/profile; cd /opt/liquibase-3.6.2/; ./liquibase --classpath=$i --dbconfig=_online update"
    done
    echo "ssh root@$host -p40001 "sh /usr/local/geekplus/script_tools/tomcat_deploy.sh $tomcat $war_list $action_tomcat $action""
    ssh root@$host -p40001 "sh /usr/local/geekplus/script_tools/tomcat_deploy.sh $tomcat $war_list $action_tomcat $action"
}




##调用部署函数
push_file 


