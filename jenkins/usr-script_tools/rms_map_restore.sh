#bin/sh
##直接覆盖地图map.xml文件

#cp /usr/local/geekplus/stressTest/maps_files/$1 /usr/local/geekplus/tomcat-rms/webapps/athena/WEB-INF/classes/config/system/map.xml

scp /usr/local/geekplus/stressTest/maps_files/maps/$1 root@$2:/usr/local/geekplus/tomcat-rms/webapps/athena/WEB-INF/classes/config/system/map.xml

echo "3.41上 $1 文件更换为map.xml 到 $2 主机成功"
