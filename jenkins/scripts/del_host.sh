#!/bin/bash
echo "从/etc/hosts删除主机"
sed -i /$host_name/d /etc/hosts 


echo "删除主机 /etc/ansible/hosts"

sed -i /$host_name/d /etc/ansible/hosts


sed -i s/$host_name,//  /opt/jenkins_config/host_list.conf


sed -i ':a;N;$!ba;s/\n//g' /opt/jenkins_config/host_list.conf
