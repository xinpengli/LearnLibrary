package com.geekplus.test.athenatest;

import static org.junit.Assert.assertEquals;

import java.awt.Point;

//import com.geekplus.athena.common.entity.Point3D;
import com.geekplus.common.util.JSONUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.geekplus.athena.api.APIResponse;
import com.geekplus.athena.api.facade.RobotTaskFacade;
import com.geekplus.athena.api.msg.body.v3_1_0.RobotTaskRequestBody;
import com.geekplus.athena.api.msg.body.v3_1_0.RobotTaskResponseBody;
import com.geekplus.athena.common.entity.api.msg.RequestHeader;
import com.geekplus.test.athena.config.MotanClient;
import com.geekplus.test.athena.config.MotanRpcConfiguration;
import com.google.common.collect.Sets;

import cn.hutool.core.lang.UUID;

@SuppressWarnings("unchecked")
@ComponentScan(basePackages = "com.geekplus.test.athena",excludeFilters={@ComponentScan.Filter(type= FilterType.ASSIGNABLE_TYPE,value=MotanRpcConfiguration.class)})
@SpringBootTest(classes =MotanClient.class)
public class RpcClient extends AbstractTestNGSpringContextTests{
    private static final Logger logger = LoggerFactory.getLogger(RpcClient.class);
    @Autowired
    private RobotTaskFacade robotTaskFacade;
  /*  @Autowired
    private  RpcTaskManage rpcTaskManage;*/

	@BeforeClass
	public void setUp(){
		//RPCserver.startServer();
	}
	@AfterClass
	public void tearDown(){

	}


	@Test
	public void addDeliverShelfToStationTask_1(String shelfCode,int stationId,int priority,String[]  shelfSides,boolean allowChangeShelfPlacement,boolean allowSwapShelf) {
  /* RequestHeader header = new RequestHeader();*/

        RequestHeader header = RequestHeader.builder()
				.requestId(UUID.randomUUID().toString())
				.clientCode("zara")
				.userId("111")
				.userKey("22")
				.version("3.1.0")
				.channelId("channel1")
				.warehouseCode("Robot-1")
				.build();

        RobotTaskRequestBody body = new RobotTaskRequestBody();
        body.setShelfCode(shelfCode);
        //body.setTaskType("DELIVER_SHELF_TO_STATION");
        body.setTaskType("DELIVER_SHELF_TO_STATION");
        body.setInstruction("GO_FETCH");
        body.setStationId(stationId);
        body.setAllowChangeShelfPlacement(allowChangeShelfPlacement);
        body.setAllowSwapShelf(allowSwapShelf);
       body.setNeededSides(Sets.newHashSet(shelfSides));
        APIResponse<RobotTaskResponseBody> response=robotTaskFacade.assign(header, body);

        assertEquals(response.getCode(), 0);
	}
    @Test
    public void updateDeliverShelfToStationTask_1(int taskId,String shelfCode,int stationId,int priority,String[] shelfSides) {
    	 RequestHeader header = RequestHeader.builder()
 				.requestId(UUID.randomUUID().toString())
 				.clientCode("zara")
 				.userId("111")
 				.userKey("22")
 				.version("3.1.0")
 				.channelId("channel1")
 				.warehouseCode("Robot-1")
 				.build();

         RobotTaskRequestBody body = new RobotTaskRequestBody();
         body.setTaskId(taskId);
         body.setShelfCode(shelfCode);
         //body.setTaskType("DELIVER_SHELF_TO_STATION");
       //  body.setTaskType("DELIVER_SHELF_TO_STATION");
         body.setInstruction("GO_RETURN");
        // body.setStationId(stationId);
         //body.setInstruction("GO_RETURN");
         //body.setTaskId(45);
        body.setNeededSides(Sets.newHashSet(shelfSides));
         APIResponse<RobotTaskResponseBody> response=robotTaskFacade.confirm(header, body);

         assertEquals(response.getCode(), 0);
    }

    public int addMoveShelfToStationTask( String shelfCode,int stationId,int priority,String[] shelfSides ,boolean allowChangeShelfPlacement,boolean allowSwapShelf){

    	 RequestHeader header = RequestHeader.builder()
  				.requestId(UUID.randomUUID().toString())
  				.clientCode("zara")
  				.userId("111")
  				.userKey("22")
  				.version("3.1.0")
  				.channelId("channel1")
  				.warehouseCode("Robot-1")
  				.build();

          RobotTaskRequestBody body = new RobotTaskRequestBody();

          body.setShelfCode(shelfCode);
          //body.setTaskType("DELIVER_SHELF_TO_STATION");
          body.setTaskType("MOVE_SHELF_TO_STATION");
          body.setInstruction("GO_RETURN");
          body.setStationId(stationId);
          body.setAllowChangeShelfPlacement(allowChangeShelfPlacement);
          body.setAllowSwapShelf(allowSwapShelf);
         body.setNeededSides(Sets.newHashSet(shelfSides));
         APIResponse<RobotTaskResponseBody> response=robotTaskFacade.assign(header, body);

          assertEquals(response.getCode(), 0);
          return  response.getCode();










    }


    public int addFetchFromShelfFromStationTask( String shelfCode,int stationId,int priority,String[] shelfSides){
    	 RequestHeader header = RequestHeader.builder()
   				.requestId(UUID.randomUUID().toString())
   				.clientCode("zara")
   				.userId("111")
   				.userKey("22")
   				.version("3.1.0")
   				.channelId("channel1")
   				.warehouseCode("Robot-1")
   				.build();

           RobotTaskRequestBody body = new RobotTaskRequestBody();

           body.setShelfCode(shelfCode);
           //body.setTaskType("DELIVER_SHELF_TO_STATION");
           body.setTaskType("FETCH_SHELF_TO_STATION");
           body.setInstruction("GO_RETURN");
          body.setStationId(stationId);
           //body.setInstruction("GO_RETURN");
           //body.setTaskId(45);
          body.setNeededSides(Sets.newHashSet(shelfSides));
          APIResponse<RobotTaskResponseBody> response=robotTaskFacade.assign(header, body);

           assertEquals(response.getCode(), 0);

         return response.getCode();
    }

    public int addDELIVER_SHELF( String shelfCode,int stationId,int priority,String[] shelfSides ,boolean allowChangeShelfPlacement,boolean allowSwapShelf ){

    	 RequestHeader header = RequestHeader.builder()
    				.requestId(UUID.randomUUID().toString())
    				.clientCode("zara")
    				.userId("111")
    				.userKey("22")
    				.version("3.1.0")
    				.channelId("channel1")
    				.warehouseCode("Robot-1")
    				.build();

            RobotTaskRequestBody body = new RobotTaskRequestBody();

            body.setShelfCode(shelfCode);
            //body.setTaskType("DELIVER_SHELF_TO_STATION");
            body.setTaskType("DELIVER_SHELF");
            body.setInstruction("GO_FETCH");
           body.setStationId(stationId);
           body.setAllowSwapShelf(allowSwapShelf);
           body.setNeededSides(Sets.newHashSet(shelfSides));
           body.setNeededSides(Sets.newHashSet(shelfSides));
           APIResponse<RobotTaskResponseBody> response=robotTaskFacade.assign(header, body);

            assertEquals(response.getCode(), 0);

          return response.getCode();

    }
	public int retrurnDELIVER_SHELF(long taskId,String shelfCode,int stationId,int priority,String ...shelfSides){

		 RequestHeader header = RequestHeader.builder()
	 				.requestId(UUID.randomUUID().toString())
	 				.clientCode("zara")
	 				.userId("111")
	 				.userKey("22")
	 				.version("3.1.0")
	 				.channelId("channel1")
	 				.warehouseCode("Robot-1")
	 				.build();

	         RobotTaskRequestBody body = new RobotTaskRequestBody();
	         body.setTaskId(taskId);
	         body.setShelfCode(shelfCode);

	         body.setInstruction("GO_RETURN");
	         body.setStationId(stationId);
	        body.setNeededSides(Sets.newHashSet(shelfSides));
	         APIResponse<RobotTaskResponseBody> response=robotTaskFacade.confirm(header, body);

	         assertEquals(response.getCode(), 0);
	         return response.getCode();

	}
    @Test
	public int addMOVE_SHELF( String shelfCode,  int priority, Point point, String [] shelfSides ,boolean allowChangeShelfPlacement,boolean allowSwapShelf){
    	RequestHeader header = RequestHeader.builder()
				.requestId(UUID.randomUUID().toString())
				.clientCode("zara")
				.userId("111")
				.userKey("22")
				.version("3.1.0")
				.channelId("channel1")
				.warehouseCode("Robot-1")
				.build();

        RobotTaskRequestBody body = new RobotTaskRequestBody();

        body.setShelfCode(shelfCode);
        //body.setTaskType("DELIVER_SHELF_TO_STATION");
        body.setTaskType("MOVE_SHELF");
        body.setInstruction("GO_RETURN");
       // body.setDest(point);
       body.setNeededSides(Sets.newHashSet(shelfSides));
       body.setAllowChangeShelfPlacement(allowChangeShelfPlacement);;
       body.setAllowSwapShelf(allowSwapShelf);
       APIResponse<RobotTaskResponseBody> response=robotTaskFacade.assign(header, body);

        assertEquals(response.getCode(), 0);

      return response.getCode();






    }


    @Test
    public void add_CEEAR_WAIT_POINT(long taksid,String waitpoint) {
    	 RequestHeader header = RequestHeader.builder()
 				.requestId(UUID.randomUUID().toString())
 				.clientCode("zara")
 				.userId("111")
 				.userKey("22")
 				.version("3.1.0")
 				.channelId("channel1")
 				.warehouseCode("Robot-1")
 				.build();

    /*    RobotTaskCallbackBody callbackBody = new RobotTaskCallbackBody();
        callbackBody.setTaskType("DELIVER_SHELF_TO_STATION");
        callbackBody.setShelfCode("A000001");
        callbackBody.setTaskPhase("GO_RETURN");
        callbackBody.setStationId(1);*/
       // logger.info("assign task:{}", JSONUtil.objToJson(body2));
        RobotTaskRequestBody body = new RobotTaskRequestBody();
        body.setTaskId(taksid);

        body.setWaitCellCode(waitpoint);

        body.setInstruction("CLEAR_WAITPOINT");

        robotTaskFacade.confirm(header, body);

    }


    @Test
	public void massTest() {

    	boolean allowChangeShelfPlacement=false;
    	boolean allowSwapShelf=false;
		String shelfCode="A000001";
		//String shelfCode="A000105";
		int taskId=1;
		int stationId = 4;
		int priority=1;
		int endAreaId=22;
		String[] shelfSides= {"L"};
		int shelfCore = 60;
		//成都 A0001230，-1430 ，staion 1-10

        //地图
		for(int shelfNum=1;shelfNum<=9;shelfNum++){
            String	b=String.valueOf(shelfNum);

            b=(b.length() == 3 ? "0" + b: b.length() == 2 ? "00" + b : b.length() == 1 ? "000" + b: b);
            shelfCode="A000"+b;
			addDeliverShelfToStationTask_1(shelfCode, stationId, priority, shelfSides, allowChangeShelfPlacement, allowSwapShelf);

//            addMoveShelfToStationTask(taskId,shelfCode,stationId,priority,shelfSides);

			taskId++;
		/*	if(stationId==7){
				stationId=1;
			}else{
				stationId++;
			}*/
		}
		//robotTask.setShelfState(SHELF_STATE.GO_RETURN);
		//robotTask.setRobotId(1001);
		//addDeliverShelfTask_1(taskId,shelfCode,endAreaId,priority);
		//addDeliverShelfTask_2(taskId,shelfCode,endAreaId,priority);

	}



    @Test
    public void go_test() {
    	boolean allowChangeShelfPlacement=false;
    	boolean allowSwapShelf=false;
		String shelfCode="A0000001";
		//String shelfCode="A000105";
		int taskId=1;
		int stationId = 1;
		int priority=1;
		int endAreaId=22;
		String[] shelfSides= {"L"};
		int shelfCore = 60;
		addDeliverShelfToStationTask_1(shelfCode, stationId, priority, shelfSides, allowChangeShelfPlacement, allowSwapShelf);
//		updateDeliverShelfToStationTask_1(taskId, shelfCode, stationId, priority, shelfSides);
		//addMoveShelfToStationTask(shelfCode, stationId, priority, shelfSides, allowChangeShelfPlacement, allowSwapShelf);
//		addDELIVER_SHELF(shelfCode, stationId, priority, shelfSides, allowChangeShelfPlacement, allowSwapShelf);
//	    retrurnDELIVER_SHELF(taskId, shelfCode, stationId, priority, shelfSides);
//		addFetchFromShelfFromStationTask(shelfCode, stationId, priority, shelfSides);



//		Point point= new Point(11,12);
//		addMOVE_SHELF(shelfCode, priority, point, shelfSides, allowChangeShelfPlacement, allowSwapShelf);


//		String waitpoint ="1111111";
//		add_CEEAR_WAIT_POINT(taskId, waitpoint );



    }

    @Test
	public void test_uuu(){
        boolean allowChangeShelfPlacement=false;
        boolean allowSwapShelf=false;
        String shelfCode="A000001";
        //String shelfCode="A0000168";
        //int taskId=1;
        int stationId = 1;
        int priority=1;
        int endAreaId=22;
        String[] shelfSides= {"F"};
        int shelfCore = 60;
        RequestHeader header = RequestHeader.builder()
                .requestId(UUID.randomUUID().toString())
                .clientCode("zara")
                .userId("111")
                .userKey("22")
                .version("3.1.0")
                .channelId("channel1")
                .warehouseCode("Robot-1")
                .build();

        RobotTaskRequestBody body = new RobotTaskRequestBody();
        body.setShelfCode(shelfCode);
        body.setTaskType("DELIVER_SHELF_TO_STATION");
        //body.setTaskType("MOVE_SHELF");
        //body.setTaskType("DELIVER_SHELF");
        //body.setTaskType("MOVE_SHELF_TO_STATION");
        //body.setTaskType("FETCH_SHELF_FROM_ENTRY");
         body.setStationId(stationId);
         body.setNeededSides(Sets.newHashSet(shelfSides));
        //body.setDestAreaId(0);
         //body.setDest(new Point3D.IPoint(1,14,9));

         //body.setInstruction("CLEAR_WAITPOINT");


        //body.setInstruction("GO_FETCH");
       //body.setInstruction("GO_RETURN");
        //body.setInstruction("GO_TURN");
       // body.setInstruction("ALLOW_ENTER_ELEVATOR");
       //body.setInstruction("ALLOW_LEAVE_ELEVATOR");
        //body.setWaitCellCode("01650105");

         //body.setTaskId(180);

        //body.setAllowChangeShelfPlacement(allowChangeShelfPlacement);
       // body.setAllowSwapShelf(allowSwapShelf);
       //body.setNeededSides(Sets.newHashSet(shelfSides));
       APIResponse<RobotTaskResponseBody> response=robotTaskFacade.assign(header, body);
         //APIResponse<RobotTaskResponseBody> response=robotTaskFacade.confirm(header, body);
        logger.info("结果：{}",response.getCode());
        logger.info(response.toString());
        logger.info(JSONUtil.objToJson(response.getData()));
        //assertEquals(0, response.getCode());
    }


}
