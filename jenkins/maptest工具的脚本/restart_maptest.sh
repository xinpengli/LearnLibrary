#!/bin/bash
##执行这个shell 的第一个入参赋值给变量jobname 
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
nohup java -jar /home/test-tools/maptest/$jobname.jar &
