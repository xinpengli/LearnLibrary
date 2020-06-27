#!/bin/bash
if   ping -c 3 192.168.10.2 > /dev/null
    then
        echo "192.168.10.2      app"  >>/etc/hosts
elif ping -c 3 192.168.14.2 > /dev/null
    then
        echo "192.168.14.2      app"  >>/etc/hosts
elif ping -c 3 192.168.71.102 > /dev/null
    then
        echo "192.168.71.102    app"  >>/etc/hosts
else
        echo "未找到匹配项"  >>/var/log/messages
fi
