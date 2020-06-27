#!/usr/bin/env python
#_*_ coding:utf-8 _*_
'''
使用方法 
./jar_manager init 用于初始化jar_list.conf配置文件    
./jar_manager [start|status|stop|restart]  [all|'jar-x'] 用于管理APP ，all参数表示为list.conf全部app,或者指定具体的app

'''
import sys
import os
import subprocess
import logging
import glob
logging.basicConfig(level=logging.INFO)

jar_dir = '/usr/local/geekplus'
#bin = 'nohup java -jar %s >/dev/null &'
bin = 'java -jar %s &>/dev/null &'
jar_app = []
##切换到脚本工作路径
scripts_dir=os.path.dirname(os.path.realpath(__file__))
os.chdir(scripts_dir)

##从jar_dir下生成jar列表配置，适用于第一次使用该脚本，jar_list.conf无内容时
def init():
    os.chdir(jar_dir)
    jar_list = [x for x in os.listdir('.') if os.path.isdir(x) and x.startswith('jar-')]
    logging.info(jar_list)
    os.chdir(scripts_dir)
    with open('jar_list.conf','w') as f:
        for i in jar_list :
            f.write('%s\n' % i)

def status(console=True):
    ##pid_dict返回正在运行的进程字典
    pid_dict = {}
    for i in jar_app:
        proc = i
        #proc =os.path.join(jar_dir, i)
        logging.debug(proc)
        logging.debug('''ps -ef |grep bin/java | grep %s | grep -v grep| awk '{print $2}' ''' % proc )
        res = subprocess.Popen('''ps -ef |grep java | grep %s | grep -v grep| awk '{print $2}' ''' % proc ,stdin=subprocess.PIPE,stdout=subprocess.PIPE,shell=True)
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
    for i in jar_app:
     if i not in run_dict.keys():
    #   print run_dict.keys()
        proc = os.path.join(jar_dir, i)
        appbin = glob.glob(r'%s/*.jar' % proc)[0]
        logging.info(appbin)
        res = subprocess.Popen( bin  % appbin ,shell=True) 
        print(bin % appbin)
        res.wait()
        logging.info('subprocess return %s' %  res.returncode)
    status()

def restart():
    stop()
    start()


if __name__ == '__main__':
    if sys.argv[1] != 'init':
        if sys.argv[2].lower() == 'all':
            if not  os.path.isfile('./jar_list.conf'):
                init()
            with open('./jar_list.conf','r') as f:
                for line in f.readlines():
                    jar_app.append(line.strip())
        else:
            jar_app = sys.argv[2:]
        
        logging.info('input app list is : %s ' % jar_app)
    
    action = {'init':init,
              'stop':stop,
              'start':start,
              'status':status,
              'restart':restart}
    if sys.argv[1] in action:
        res = action[sys.argv[1]]()

