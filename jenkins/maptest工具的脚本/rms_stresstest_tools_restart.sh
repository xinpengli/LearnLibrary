#!/bin/bash


export JAVA_HOME=/usr/local/geekplus/java/jdk1.8.0_111
export JRE_HOME=$JAVA_HOME/jre

pid=`ps aux | grep athenatest | grep -v grep | grep -v retomcat | awk '{print $2}'`

sleep 1s
if [ $pid -n ]
then
    echo "pid="$pid
fi

echo ===========shutdown================
  kill -9 $pid
sleep 5s
echo ===========startup.sh==============
#/usr/local/geekplus/tomcat-rms/bin/startup.sh

##启动RMS性能测试工具
nohup java -jar /home/geektest/workspace/rms_stresstest_tools/target/athenatest.jar &
sleep 20s
if [ $pid -n ]
then
    echo "athneatest 性能测试工具启动成功"
fi
