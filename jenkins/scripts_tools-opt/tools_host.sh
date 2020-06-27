#!/bin/bash
sed -i '/^wms_tools/d' /root/.jenkins/workspace/host.list.conf
a='wms_tools='
b=`cat /root/.jenkins/workspace/host.list.conf  |grep -v '^#' | grep -v  "^$" |grep -v ',' | awk -F= '{print $2}' | sort| uniq | sort -k1.2 | tr "\n" ","`
echo $a$b >> /root/.jenkins/workspace/host.list.conf
