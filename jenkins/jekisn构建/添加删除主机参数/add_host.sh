#!/bin/bash
ping $host_name -w1 -c1 2> /dev/null |grep 'data'
if [ "$?" -eq 0 ]
then
	echo "主机名已经存在，请检查 /etc/hosts"
	exit 1
fi

echo "添加主机到/etc/hosts"
echo "$IP      $host_name" >> /etc/hosts 


echo "添加主机到/etc/ansible/hosts"
echo "$IP   ansible_ssh_user=root       ansible_ssh_pass=$password      ansible_ssh_port=$port" >> /etc/ansible/hosts

echo "
- hosts: $IP
  roles:
      - { role: ssh_key}
"> /etc/ansible/sshkey.yml
ansible-playbook /etc/ansible/sshkey.yml

##不换行输出 -n
echo -n "$host_name," >> /opt/jenkins_config/host_list.conf


sed -i ':a;N;$!ba;s/\n//g' /opt/jenkins_config/host_list.conf
