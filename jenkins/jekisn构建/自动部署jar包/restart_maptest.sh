#!/bin/bash
##执行这个shell 的第一个入参赋值给变量jobname 
## export 通过远程执行主机java命令时，加入java环境变量，否则提示没有java命令
export JAVA_HOME=/usr/local/geekplus/java/jdk1.8.0_111
export JRE_HOME=$JAVA_HOME/jre
export PATH=$PATH:$JAVA_HOME/bin
jobname=$1
pid=`ps aux |grep $jobname.jar |grep -v grep  | awk '{print $2}'`
echo $pid
##pid本身就是list 不用加大括号｛｝
for jarSer in $pid
do
kill -9 $jarSer
done
sleep 3
##当在脚本运行 jar包时，必须后台运行
echo "java -jar /home/test-tools/maptest/"$jobname".jar"
## 后台运行服务，且指定输入到 log文件，默认路径应该是/root >标准输出 如果要追加用两个大于号>>
nohup java -jar /home/test-tools/maptest/$1.jar > log.txt &
sleep 20s
echo  $1"测试工程已启动"
