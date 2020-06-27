#/bin/bash
. /etc/profile

##判断当前服务器是否为生产
ip addr |grep '192.168.10'
if [ "$?" -eq 0 ]
then
    echo "生产服务器，禁止使用本脚本还原数据库，如需要还原请手动操作"
    exit 100
fi

echo "$host "
restore_file=/tmp
backup_base=/usr/local/geekplus/backup/mysql_data
dir_name=$1
mysql_back_file=$2
base_name=`echo $mysql_back_file | awk -F. '{print $1}'`
echo "$base_name"
user=root
passwd=root

##下载数据库备份文件
cd $restore_file
wget -q http://172.16.19.14/mysql_bak/$dir_name/$mysql_back_file

###解压包
tar jxf "$mysql_back_file" 

innobackupex --apply-log $restore_file/$base_name

##清除原数据
systemctl stop mysqld
rm -rf /tmp/mysql
/usr/bin/mv /usr/local/geekplus/data/mysql /tmp
rm -rf /usr/local/geekplus/data/mysql

####日志追加，并还原
innobackupex --defaults-file=/etc/my.cnf  --copy-back $restore_file/$base_name

cd /usr/local/geekplus/data

chown -R mysql:mysql mysql

sed -i '/skip-grant-tables/d' /etc/my.cnf
sed -i '/mysqld/a skip-grant-tables' /etc/my.cnf
systemctl restart mysqld

mysql -e "update mysql.user set authentication_string=password('root') where user='root';"
mysql -e "update mysql.user set host='%' where host like '192%';"

#sed -i '/skip-grant-tables/d' /etc/my.cnf

systemctl restart mysqld

mysql_upgrade -uroot -p$passwd

systemctl restart mysqld

###清除临时存放目录
rm -rf /tmp/$mysql_back_file
rm -rf /tmp/$base_name



