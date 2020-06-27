#!/bin/bash
##backup
www_dir=/usr/local/geekplus/wwwroot/static/
date=`date +%F_%H-%M-%S`
app=build
bak_dir=/usr/local/geekplus/backup/www_bak/$app/$date
gz_dir=$1
mkdir -p $bak_dir &> /dev/null
mkdir -p $www_dir 

cd $www_dir
tar czf build.tar.gz build
mv build.tar.gz $bak_dir

rm  -rf build

cp $gz_dir  .

tar xf `basename $gz_dir`

rm -f build.tar.gz
##授权nginx账户
chown -R  nginx /usr/local/geekplus/wwwroot/
ls -lhtr
