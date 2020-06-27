#!/bin/bash
###通过git仓库下载编译好的war包解压
###包含原程序备份
. /etc/profile
help='
###    参数解释   ###
## $1 要部署的tomcat app ，同时也为目录名
## $2 war包的路径,要部署多个war,每个war包路径，用逗号隔开如:/tmp/beetle.war,/tmp/geekplus-vip.war
## $3 启动，停止，重启的tomcat 默认为当前部署的app,可以关联app，用逗号隔开例如：  tomcat-wms,tomcat-rms
## $4 要对tomcat管理的操作，默认为重启，可选参数为 stop | start | restart
## 
'
if [ $# -lt 2 ]
then
    echo $help
    exit 1
fi
echo "接收到的参数 $*"
cmd_dir=`pwd`
cd `dirname $0`
shell_dir=`pwd`
basedir=/usr/local/geekplus/
app=$1
file=`echo $2|tr ',' ' '`

###先判断$4是否有参数并赋值动作
if [ -z "$4" ]
then
    action=restart
else
    action=$4
fi
#将部署的app加入参数控制列表中
if [ -z "$3" ]
then
    rs=$app
else
    echo $3 | egrep 'restart|stop|start'
    if [ $? -ne 0 ];then
        rs=`echo $3|tr ',' ' '` 
        echo $rs |grep $app 
        if [ $? -ne 0 ];then
            rs="$rs $app"
        fi
    else
        action=$3
        rs=$app
    fi
fi
echo "解析后的参数为 app: $app  file: $file rs: $rs action: $action "

##先检查文件是否存在，如果不存在则退出部署
for f in $file
do
    if [ -f $f ]
    then
        echo "$f file OK"
    else
        echo "file not exist"
    fi
done

##check args  
if [ -z "$app" ]
then
    echo "请输入要部署的tomcat app "
    exit 1
fi

function stop_app {
    echo "`date` stop $rs "
    python tomcat_manager.py stop $rs
}

function start_app {
    echo "`date` restart $rs "
    python tomcat_manager.py start $rs
}

function backup {
    echo "`date` bakcup $app "
    sh tomcat_backup.sh $app
}

function get_war {
##获取war包，参数可选为cp|wget ,cp为指定文件目录，需要运行脚本时第二个参数指定war包路径
    path=$1
    case "$path" in 
    "cp" )
        #export war=`basename ./"$file"`
        #export war_dir=`echo $war | awk -F. '{print $1}'`
        cd $cmd_dir
        echo "cp -a $file $basedir$app/webapps/"
        cp -a $file $basedir$app/webapps/
        cd -
    ;;
    "wget" )
        export war=`basename  $file`
        #export war_dir=`echo $war | awk -F. '{print $1}'`
        echo "`date` wget $file $basedir$app/webapps/"
        wget $file -qP $basedir$app/webapps/ 
        ##warname 以获取到的war包
        war_name=`echo $file | xargs basename | awk -F. '{print $1}'`
    esac
}

function check_file {
    echo $file
    ##判断是否为本地文件
    if [ -f "$file" ]
    then 
        echo "检测到本地路径：$file"
        get_war cp
    elif [ "`wget --spider -nv $file  2>&1| grep -c 200`" -eq 1  ]
    then
        echo "检测到一个url地址"
        get_war wget
    else
        echo "`date` ERROR 输入的url或文件错误，请检查输入!"
        exit 1
    fi
}



function deploy_war {
    cd $basedir$app/webapps/
    echo "`date` cmd: ls -lh `ls -lh`"
    app_list=`ls *.war `
    for i in $app_list
    do
    {
        echo "`date` INFO  开始解压 $i"
        unzip -o $i -d `echo $i | awk -F. '{print $1}'` >/dev/null
        if [ $? -ne 0 ];then
            echo "解压出错，检查文件，重新部署"
            exit 2
        fi
        rm -f $i
    }
    done
    ls -lh
    cd $shell_dir

}

function clean {
    cd $basedir$app/webapps/
    app_list=`echo $file |tr ' ' '\n' | awk -F[/.] '{print $(NF-1)}'`
    for i in $app_list
    do
        echo "`date` INFO  clean  $basedir$app/webapps/$i"
        rm -rf $basedir$app/webapps/$i
    done

    echo "`date` clean  $basedir$app/work/"
    rm -rf $basedir$app/work/* 
    echo "`date` clean  $basedir$app/temp/"
    rm -rf $basedir$app/temp/* 
    cd -
}

function sql {
    sh sql_deploy.sh $1
    result=$?
    if [ "$result"  -ne 0 ]
    then
        echo "SQL执行出错，退出程序部署，请手动处理"
        exit 1
    fi
}

###上线操作步骤、顺序执行

#check_file

stop_app

backup

clean

get_war cp

deploy_war

if [ "$action" != "stop" ]
then
    start_app
fi
