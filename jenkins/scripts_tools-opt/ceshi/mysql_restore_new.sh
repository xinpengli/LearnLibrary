#/bin/bash
echo "$host "
restore_file=/tmp/1
backup_base=/usr/local/geekplus/backup/mysql_data
dir_name=$1
mysql_back_file=$2
base_name=`echo $mysql_back_file | awk -F. '{print $1}'`
echo "$base_name"
###查看目录是否存在

if [ ! -d "$restore_file" ];then
        mkdir -p $restore_file/2
fi
###备份文件拷贝
    scp -r root@172.16.19.13:$backup_base/$dir_name/$mysql_back_file $restore_file/
###解压包
  cd $restore_file
  tar jxf "$mysql_back_file" -C /tmp/1/2
###清除tar包
rm -rf $restore_file/$mysql_back_file

####日志追加，并还原

systemctl stop mysqld

innobackupex --apply-log $restore_file/2/$base_name

rm -rf /usr/local/geekplus/data/*

innobackupex --defaults-file=/etc/my.cnf --user=root --copy-back $restore_file/2/$base_name

cd /usr/local/geekplus/data

chown -R mysql mysql/

systemctl start mysqld

mysql_upgrade -uroot -proot

systemctl restart mysqld

###清除临时存放目录
rm -rf /tmp/1
