#!/usr/bin/env python
#_*_ coding:utf-8 _*_
'''
使用方法 
./tomcat_manager init 用于初始化tomcat_list.conf配置文件    
./tomcat_manager [start|status|stop|restart]  [all|'tomcat-x'] 用于管理APP ，all参数表示为tomcat_list.conf全部app,或者指定具体的app

'''
import sys
import os
import subprocess
import logging
logging.basicConfig(level=logging.INFO)

tomcat_dir = '/usr/local/geekplus'
bin = 'bin/startup.sh'
tomcat_app = []
##切换到脚本工作路径
scripts_dir=os.path.dirname(os.path.realpath(__file__))
os.chdir(scripts_dir)

##从tomcat_dir下生成tomcat列表配置，适用于第一次使用该脚本，tomcat_list.conf无内容时
def init():
    os.chdir(tomcat_dir)
    tomcat_list = [x for x in os.listdir('.') if os.path.isdir(x) and x.startswith('tomcat-')]
    logging.info(tomcat_list)
    os.chdir(scripts_dir)
    with open('tomcat_list.conf','w') as f:
        for i in tomcat_list :
            f.write('%s\n' % i)

def status(console=True):
    ##pid_dict返回正在运行的进程字典
    pid_dict = {}
    for i in tomcat_app:
        proc = i
        #proc =os.path.join(tomcat_dir, i)
        logging.debug(proc)
        logging.debug('''ps -ef |grep bin/java | grep %s | grep -v grep| awk '{print $2}' ''' % proc )
        res = subprocess.Popen('''ps -ef |grep bin/java | grep %s | grep -v grep| awk '{print $2}' ''' % proc ,stdin=subprocess.PIPE,stdout=subprocess.PIPE,shell=True)
        pid = res.stdout.read()

        if pid:
            pid_dict[i] = int(pid.strip())
        else:
            if console:
                print('%s   not running!!!' % i)
    if console:
        for k,v in pid_dict.items():
            print('%s(pid %d)  is running...' % (k,v))
    return pid_dict

def stop():
    pid_dict = status(True)
    for k,v in pid_dict.items():
        res = subprocess.Popen('''kill -9 %d ''' % v ,shell=True)
        print('kill %s(%d) done ' % (k,v))

def start():
    run_dict = status(False)
    for i in tomcat_app:
     if i not in run_dict.keys():
    #   print run_dict.keys()
        proc = os.path.join(os.path.join(tomcat_dir, i), bin)
        logging.info(proc)
        res = subprocess.Popen('sh %s' % proc ,shell=True) 
        res.wait()
        logging.info('subprocess return %s' %  res.returncode)
    status()

def restart():
    stop()
    start()


if __name__ == '__main__':
    if sys.argv[1] != 'init':
        if sys.argv[2].lower() == 'all':
            if not  os.path.isfile('./tomcat_list.conf'):
                init()
            with open('./tomcat_list.conf','r') as f:
                for line in f.readlines():
                    tomcat_app.append(line.strip())
        else:
            tomcat_app = sys.argv[2:]
        
        logging.info('input app list is : %s ' % tomcat_app)
    
    action = {'init':init,
              'stop':stop,
              'start':start,
              'status':status,
              'restart':restart}
    if sys.argv[1] in action:
        res = action[sys.argv[1]]()

