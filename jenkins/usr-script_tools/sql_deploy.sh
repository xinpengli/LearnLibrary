#!/bin/bash
###SQL上线脚本，指定SQL目录，按顺序备份数据库，执行SQL文件
###执行方式 第一个参数为执行sql的目录路径，程序会执行该路径下面所有以sql结尾的sql文件
###SQL 执行完毕后会简单判断执行结果里是否有error
user=root   
passwd=root
host=127.0.0.1
port=3306
sql_bak=/usr/local/geekplus/backup/mysql_data/sql_dump
date=`date +%F_%H-%M-%S`
mkdir -p $sql_bak
sql_dir=$1
cd $sql_dir

sql_list=`ls  $sql_dir/*.sql | sort -n`



###备份指定的数据库
function backup_db {
    mysqldump -h$host -P$port -u$user  --single-transaction  --comments --complete-insert --force -B $1 | gzip > $sql_bak/"$1"-"$date".sql.gz
    echo -e "  mysqldump database $1 done  \n"

}
###sql文件执行日志
sql_exec_log=sql_exec_log
echo > $sql_exec_log

##循环执行指定目录的SQL文件，并完成单个库的备份
for line in $sql_list
do
    db=`echo $line | awk -F[_.-] '{print $2}'`
    backup_db $db
    echo -e " execute sql file  $line  \n"
    echo "mysql -h$host -P$port -u$user  $db <$line " &>> $sql_exec_log
    mysql -h$host -P$port -u$user -p$passwd $db <$line 2>&1 | tee -a $sql_exec_log
done

err=`grep -i 'error' $sql_exec_log`
if [ -n "$err" ]
then
    echo "SQL文件执行完，但检测到有error,内容如下"
    echo $err
    exit 1
fi
