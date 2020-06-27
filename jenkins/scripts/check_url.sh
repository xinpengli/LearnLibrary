#/bin/bash
#入参 host、appllo是否部署、artmis是否部署
if [ $# -lt 3 ]
then
    echo "至少三个参数"
    exit 1
fi
echo "接收到的参数 $*"

host=$1
artemis_need_deploy=$2
apollo_need_deploy=$3
#appllo
url1=http://$host/static/html/login.html
#artmis
url2=http://$host:8082/geekplus/

if [[ "$apollo_need_deploy" = true ]] ; then
  result1=`curl -s $url1`
  #echo $result1
  if [[ $result1 =~ "系统登录"  ]];then echo "访问 $url1 成功";else exit 1;fi
fi

if [[ "$artemis_need_deploy" = true ]] ; then
  result2=`curl -s $url2`
  #echo $result2
  if [[ $result2 =~ "合箱"  ]];then echo "访问 $url2 成功";else exit 1;fi
fi
