package com.pbfw.common.schedule;


import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.swing.JInternalFrame;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;

import com.pbfw.admin.service.AdminService;
import com.pbfw.common.service.CommonService;
import com.pbfw.common.util.CommonUtil;

@Controller
public class schedulerController{
	Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
	@Resource(name="adminService")
	AdminService adminService;
	
	@Resource(name="commonService")
	CommonService commonService;
	
	@Resource(name = "SocketServer")
	SocketServer socketServer;
	
	
	/**
	* 라즈베리 행사 예약 - 리프레시 보내기
	* @param null
	* @return void
	* @exception Exception
	**/
	@Scheduled(cron="*/60 * * * * *")
	public void selectEventReserve() throws Exception {
//		System.out.println("selectEventReserve");
		//입실일이랑 현재시간 비교해서 같을시 RASPBERRY_CONNECTION_NO(빈소번호) 가져와서 업데이트 해주고
		//종합화면에 해당 빈소가 포함되어 있으면 종합화면 조회해서 종합도 업데이트 해주기
		
		//빈소번호 가져오기
		List<HashMap<String, Object>> binsoList = commonService.selectEventSche10();
		if(!binsoList.isEmpty()) {
			for(HashMap<String, Object> map:binsoList) {
				//빈소번호로 먼저 푸시 보내기
				HashMap<String, Object> requestMap = new HashMap<String, Object>();
				requestMap.put("rpiBinsoList", map.get("BINSO_LIST"));
				requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
				List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
				commonUtil.sendCloudMessages(rpiList, "1", "", null);
				
				
				//빈소번호로 종합화면(해당빈소가 포함되어 있는) 조회
				requestMap.put("binsoList", map.get("BINSO_LIST"));
				HashMap<String, Object> jongList = commonService.selectEventSche30(requestMap);
				
				if(jongList != null) {
					requestMap.put("rpiBinsoList", jongList.get("BINSO_LIST"));
					requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
					List<HashMap<String, Object>> rpiList2 = adminService.selectSendRpiList(requestMap);
					commonUtil.sendCloudMessages(rpiList2, "1", "", null);
				}
			}
		}
		
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("flag", "3");
		HashMap<String, Object> tmpMap = commonService.selectRaspEventSche(map);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		
	}
	
	
	/**
	* 소켓통신 핑퐁하기
	* @param null
	* @return void
	* @exception Exception
	**/
	@Scheduled(cron="0 0/5 * * * *")
//	@Scheduled(cron="*/20 * * * * *")
	public void schePingPong() throws Exception {
		socketServer.sendPingPong();
	}
	

//	@Scheduled(cron="*/5 * * * * *")
//	public void schePingPong() throws Exception {
//		System.out.println("\n\n\n5 SECOND = " + new Date() +"\n\n\n");
//		HashMap<String, Object> tmpMap = adminService.selectTestList();
//		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
//	}
	

	
	
}
