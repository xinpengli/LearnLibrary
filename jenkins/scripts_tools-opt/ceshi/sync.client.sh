
#!/bin/bash
job=$JOB_NAME
upload=/usr/local/geekplus/backup/mysql_data

conf_file=version.conf

###更新 deploy 项目时的选项列表
function remote_version {
   list=`ssh root@192.168.32.84 "ls -lt $upload/acca/../"  |  sed '1d' |awk '{print $NF}' | head | tr '\n' ',' | tr '\n' ',' `
   cd /root/.jenkins/workspace
   echo  $job= >> $conf_file
   sed -i "/^$job=/d" $conf_file
   #echo -n $job= >> $conf_file
   echo $job=$list >> $conf_file
   #echo >> $conf_file
}


###更新仿真地址包列表，存入当前部署的工作目录
function fz_dir {
    cd /root/.jenkins/workspace/mysql_restore/
    client=`echo $JOB_NAME|awk -F'-' '{print $2}'`
    echo "$JOB_NAME=$WORKSPACE" >> $client
    sed -i "/^$JOB_NAME=/d" $client
    echo "$JOB_NAME=$WORKSPACE" >> $client
}

#push_file
remote_version
