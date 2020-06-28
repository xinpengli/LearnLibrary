package com.geekplus.test.athena.controller;

import com.geekplus.athena.api.APIResponse;
import com.geekplus.athena.api.msg.body.v3_1_0.RobotTaskRequestBody;
import com.geekplus.athena.api.msg.body.v3_1_0.RobotTaskResponseBody;
import com.geekplus.athena.common.entity.api.msg.RequestHeader;
import com.geekplus.athena.facade.robot.RobotTask;
import com.geekplus.common.util.JSONUtil;
import com.geekplus.common.util.RandomUtil;
import com.geekplus.test.athena.common.Dom4jUtil;
import com.geekplus.test.athena.entity.TestJob;
import com.geekplus.test.athena.rpc.RpcTaskManage;
import com.geekplus.test.athena.service.BaseInfoService;
import com.google.common.collect.Sets;

import cn.hutool.core.lang.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.Comparator;
import java.util.List;
import java.util.Random;

/**
 * athena测试平台，rpc任务下发接口
 * @author wanghao
 */
@RestController
@RequestMapping("/rpc")
public class RpcTestControllor {

    @Autowired
    private RpcTaskManage rpcTaskManage;
    @Autowired
    private BaseInfoService baseInfoService;
    
    
   
 
   

   
    @RequestMapping("/robot")
    @ResponseBody
	//获取前端data传过来的控件name=file的filew文件，且定义为MultipartFile类型的file变量，MultipartFile为获取formdate类型的file类型
    public String testRobot(@RequestParam("file") MultipartFile file){

        if (!file.isEmpty()) {
            try {
                /*
                 * 这段代码执行完毕之后，图片上传到了工程的跟路径； 大家自己扩散下思维，如果我们想把图片上传到
                 * d:/files大家是否能实现呢？ 等等;
                 * 这里只是简单一个例子,请自行参考，融入到实际中可能需要大家自己做一些思考，比如： 1、文件路径； 2、文件名；
                 * 3、文件格式; 4、文件大小的限制;
                 */
				 //BufferedOutputStream 写入file.getOriginalFilename()文件里，写文件
                BufferedOutputStream out = new BufferedOutputStream(
                        new FileOutputStream(new File(
                                file.getOriginalFilename())));
                System.out.println(file.getName());
				//file.getBytes(),返回文件内容的二进制数组数据byte[],BufferedOutputStream.write（byte[] b）写入将b.length个二进制数据写入文件流
                out.write(file.getBytes());
                out.flush();
                out.close();
               String fileString= out.toString();
                return fileString ;
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                return "上传失败," + e.getMessage();
            } catch (IOException e) {
                e.printStackTrace();
                return "上传失败," + e.getMessage();
            }



        } else {
            return "上传失败，因为文件是空的.";
        }





    }
    @RequestMapping("/getUncompleteRobotTask")
    @ResponseBody
    public String getUncompleteRobotTask(){
        return "success:"+JSONUtil.objToJson(RpcTaskManage.robotTasks);
    }
}
