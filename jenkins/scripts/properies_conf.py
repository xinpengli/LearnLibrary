# -*- coding: utf-8 -*-
# @Time    : 2018/12/10 11:55
# @Author  : weikai
# @File    : Properties.py
# @Software: PyCharm
import os
import platform
import traceback
import sys


class Properties(object):
    def __init__(self, fileName):
        self.fileName = fileName
        self.properties = {}

    def getProperties(self):
        try:
            pro_file = open(self.fileName, mode='r')
            # pro_file = open(self.fileName, mode='r', encoding='utf8', errors='ignore')
            for line in pro_file.readlines():
                line = line.strip().replace('\n', '')
                if line.find("#") != -1:
                    line = line[0:line.find('#')]
                if line.find('=') > 0:
                    strs = line.split('=')
                    strs[1] = line[len(strs[0]) + 1:]
                    self.properties[strs[0]] = strs[1]
        except Exception as e:
            print(traceback.format_exc())
            print(e)

        else:
            pro_file.close()
        return self.properties


def compareFile(originFile, newFile):
    """
    文件比较返回差别
    :param originFile:
    :param newFile:
    :return: origin 缺少的配置/None
    """
    origin = Properties(originFile)
    new = Properties(newFile)
    originDict = origin.getProperties()
    newDict = new.getProperties()
    return compareItem(originDict, newDict)


def compareItem(origin, new):
    """字典比较
    :param origin:git上配置文件字典
    :param new:代码分支的配置文件字典
    :return: origin 缺少的配置/None
    """
    if origin is None or new is None:
        return None
    if len(origin) == 0 or len(new) == 0:
        return None
    results = {}
    for key in new:
        if key not in origin:
            results[key] = new[key]
    if len(results) > 0:
        return results
    return None


def changeFile(originFile, newFile):
    """追加到git下载的配置文件
    :param originFile:
    :param newFile:
    :return:
    """
    result = compareFile(originFile, newFile)
    if result:
        print('append {},{}'.format(originFile, newFile))
        # 获取文件名
        fileName = newFile.split(os.sep)[-1]
        onlineName = fileName.replace('.properties', '') + '_online.properties'
        simulationName = fileName.replace('.properties', '') + '_simulation.properties'
        # 获取路径
        path = originFile.replace(fileName, '')
        pathOnline = os.path.join(path, onlineName)
        pathSimulation = os.path.join(path, simulationName)

        for key in result:
            try:
                if (platform.system() == "Windows"):
                    os.system("""echo {} >> {}""".format('\n' + key + '=' + result[key], originFile))
                    if os.path.exists(pathOnline):
                        os.system("""echo {} >> {}""".format('\n' + key + '=' + result[key], pathOnline))
                    if os.path.exists(pathSimulation):
                        os.system("""echo {} >> {}""".format('\n' + key + '=' + result[key], pathSimulation))
                else:
                    os.system("""echo -e '{}' >> {}""".format('\n' + key + '=' + result[key], originFile))
                    if os.path.exists(pathOnline):
                        os.system("""echo -e '{}' >> {}""".format('\n' + key + '=' + result[key], pathOnline))
                    if os.path.exists(pathSimulation):
                        os.system("""echo -e '{}' >> {}""".format('\n' + key + '=' + result[key], pathSimulation))
            except Exception as e:
                print(traceback.format_exc())


def main(workPath, host=None):
    """
    :param workPath:work_build路径
    :return:
    """
    # 拼接路径
    middlePath = os.path.join('WEB-INF', 'classes', 'config', 'system')
    mq_middle_path = os.path.join('WEB-INF', 'classes', 'config', 'data')
    confPath = os.path.join(workPath, 'config')
    # 文件夹
    fileList = []
    try:
        fileList = os.listdir(confPath)
    except OSError as e:
        print(traceback.format_exc())
        print(e)
    # config 配置文件
    for name in fileList:
        propPath = os.path.join(confPath, name, middlePath)
        replace_rocketmq(os.path.join(confPath, name, mq_middle_path), host)
        propList = []
        try:
            if os.path.exists(propPath):
                propList = os.listdir(propPath)
        except OSError as e:
            print(traceback.format_exc())
            print(e)
        for prop in propList:
            if prop.endswith('.properties') and not prop.startswith(
                    '.') and 'simulation' not in prop and 'online' not in prop and 'beifen' not in prop:
                originFile = os.path.join(propPath, prop)
                newFile = os.path.join(workPath, name, middlePath)
                if os.path.exists(os.path.join(newFile, prop)):
                    changeFile(originFile, os.path.join(newFile, prop))


def replace_rocketmq(rocketmq_config_path, host):
    if os.path.exists(rocketmq_config_path):
        fileList = os.listdir(rocketmq_config_path)
        for file in fileList:
            if '.properties' in file and ('rocketmq' in file or 'rocketmq_simulation' in file) and 'online' not in file:
                if host:
                    host = host.replace('.', '_')
                    cmd = "sed -i '/^consumer.group=/consumer.group=consumer_artemis_{}' {}".format(host, os.path.join(
                        rocketmq_config_path, file))
                    print(cmd)
                    os.system(cmd)


if __name__ == '__main__':
    # print(ss)
    # # 获取目录列表
    # # 遍历文件夹中的.properties文件 /WEB-INF/classes/config/system
    # # 读取文件中 比较文件差别
    # # 追加不同的k-v
    # p = Properties('nanjing.properties')
    # print(p.getProperties())
    # E:\test
    pathstr = sys.argv[1]
    host = sys.argv[2]
    print(pathstr)
    if os.path.exists(pathstr):
        main(pathstr, host)
    else:
        print('路径不存在')
    # main("E:\\test")
    # main("/root/test/work_build")
