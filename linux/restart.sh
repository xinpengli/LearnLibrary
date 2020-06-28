#!/bin/bash
branch=`echo $branch | sed 's#origin/##' `
pid=`ps aux |grep $branch.jar |grep -v grep  | awk '{print $2}'`
echo $pid

for jarSer in($pid)
do
kill -9 $jarSer
done
sleep 3
jar -jar /home/test-tools/maptest/$branch.jar