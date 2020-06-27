#bin/sh

ssh-keygen -t rsa -P ''

scp ~/.ssh/id_rsa.pub root@172.16.3.6:/root/.ssh/$1.pub;


#cat id_rsa_$db_from.pub >> ~/.ssh/authorized_keys;


