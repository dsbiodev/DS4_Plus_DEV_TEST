package com.pbfw.admin.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.pbfw.admin.service.AdminService;
import com.pbfw.common.schedule.SocketServer;
import com.pbfw.common.service.CommonService;
import com.pbfw.common.util.CommonUtil;

@Controller
public class AdminController {
	Logger log = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "adminService")
	AdminService adminService;

	@Resource(name = "commonService")
	CommonService commonService;

	@Resource(name = "commonUtil")
	CommonUtil commonUtil;

	@Resource(name = "SocketServer")
	SocketServer socketServer;

	
	private SimpMessagingTemplate messagingTemplate;
	
	@Autowired
	public void setMessagingTemplate(SimpMessagingTemplate messagingTemplate) {
		this.messagingTemplate = messagingTemplate;
	}
	

    
	@RequestMapping(value = "/admin/pbSocketInfo.do")
	public @ResponseBody HashMap<String, Object> pbSocketInfo() throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>(); 
		map.put("client_rasp", SocketServer.clientsRaspList.toString());
		map.put("client_rasp_size", SocketServer.clientsRaspList.size());
		return map;
	}
	
	@RequestMapping(value = "/admin/pbSocketPingPong.do")
	public @ResponseBody void pbSocketPingPong() throws Exception {
		socketServer.sendPingPong();
	}
	
	@RequestMapping(value = "/admin/pbSocketTest.do")
	public @ResponseBody void pbSocketTest() throws Exception {
		socketServer.sendSocketTest();
	}
	
	
	

	/**
	 * �떒留먯젣�뼱 �쎒�냼耳�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/connChk.do")
	public @ResponseBody void connChk(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		try {
			messagingTemplate.convertAndSend("/subscribe/connChk", "{\"raspberryConnectionNo\":\""+requestMap.get("raspberryConnectionNo")+"\"}");
		}catch(Exception e) {
			log.debug("messagingTemplate = " + e);
		}
	}




	/**
	 * 怨듭��궗�빆 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectNoticeList.do")
	public @ResponseBody HashMap<String, Object> selectNoticeList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectNoticeList(requestMap);
	}

	/**
	 * 怨듭��궗�빆 �벑濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertNotice.do")
	public @ResponseBody Integer insertNotice(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.insertNotice(requestMap);
	}

	/**
	 * 怨듭��궗�빆 �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateNotice.do")
	public @ResponseBody Integer updateNotice(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.updateNotice(requestMap);
	}

	/**
	 * 怨듭��궗�빆 �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteNotice.do")
	public @ResponseBody Integer deleteNotice(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.deleteNotice(requestMap);
	}

	/**
	 * �쟾援� �옣濡��떇�옣 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectAllFuneralHallList.do")
	public @ResponseBody HashMap<String, Object> selectAllFuneralHallList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectAllFuneralHallList(requestMap);
	}

	/**
	 * �옣濡��떇�옣 �벑濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertFuneralHall.do")
	public @ResponseBody Integer insertFuneralHall(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.insertFuneralHall(requestMap);
	}

	/**
	 * �옣濡��떇�옣 �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateFuneralHall.do")
	public @ResponseBody Integer updateFuneralHall(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.updateFuneralHall(requestMap);
	}

	/**
	 * �옣濡��떇�옣 �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteFuneralHall.do")
	public @ResponseBody Integer deleteFuneralHall(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.deleteFuneralHall(requestMap);
	}

	/**
	 * �씪利덈쿋由� 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectRaspberryList.do")
	public @ResponseBody HashMap<String, Object> selectRaspberryList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectRaspberryList(requestMap);
	}

	
	/**
	 * �씪利덈쿋由� 援먯껜�븯湲�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/raspberryChange.do")
	public @ResponseBody HashMap<String, Object> raspberryChange(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		// 議고쉶�맂 �씪利덈쿋由� �뫖�떆 蹂대깂

		List<HashMap<String, Object>> changeList = new ArrayList<HashMap<String, Object>>();
		HashMap<String, Object> tmp01 = new HashMap<String, Object>();
		HashMap<String, Object> tmp02 = new HashMap<String, Object>();
		requestMap.put("flag", "8");
		tmp01.put("RASPBERRY_CONNECTION_NO", requestMap.get("wrongRaspNo"));
		tmp01.put("RASPBERRY_ID", requestMap.get("raspberryId"));
		tmp01.put("FLAG", "8");
		
		changeList.add(tmp01);
		tmp02.put("RASPBERRY_CONNECTION_NO", requestMap.get("raspNo"));
		tmp02.put("RASPBERRY_ID", requestMap.get("wrongRaspberryId"));
		tmp02.put("FLAG", "8");
		changeList.add(tmp02);
		requestMap.put("list", changeList);
		if(!requestMap.get("list").toString().equals("[]")) socketServer.send(requestMap);
				
		List<HashMap<String, Object>> list = adminService.selectRaspberryControlList(requestMap);
		commonUtil.sendCloudMessages(list, "8", requestMap.get("wrongRaspberryId").toString(), requestMap);
		return requestMap;
	}

	
	
	/**
	 * �씪利덈쿋由�-�떒留먭린�젣�뼱 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectRaspberryControlList.do")
	public @ResponseBody HashMap<String, Object> selectRaspberryControlList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		// �씪利덈쿋由� �뿰寃곗뿬遺� 紐⑤몢 珥덇린�솕
		adminService.updateRaspberryControlReset(requestMap);

		// 議고쉶�맂 �씪利덈쿋由� �뫖�떆 蹂대깂
		requestMap.put("flag", "4");
		List<HashMap<String, Object>> list = adminService.selectRaspberryControlList(requestMap);
		commonUtil.sendCloudMessages(list, "6", "", requestMap);
		
		return adminService.selectRaspberryList(requestMap);
	}
	
	/**
	 * �씪利덈쿋由�-�떒留먭린�젣�뼱 �뿰寃곗껜�겕
	 * @param HashMap<String, Object> requestMap
	 **/
	@RequestMapping(value = "/admin/raspListConnChk.do")
	public @ResponseBody void raspListConnChk(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		//異붽� �냼耳볧넻�떊
		requestMap.put("list", adminService.selectRaspberryControlList(requestMap));
		if(!requestMap.get("list").toString().equals("[]")) socketServer.send(requestMap);
	}

	/**
	 * �씪利덈쿋由� �긽�깭泥댄겕
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateRaspberryControl.do")
	public @ResponseBody Integer updateRaspberryControl(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		// �뫖�떆 諛쏆��썑 �뾽�뜲�씠�듃
		adminService.updateRaspberryControl(requestMap);

		// jsp �샇異�
		try {
			messagingTemplate.convertAndSend("/subscribe/teminal-control", requestMap);
		} catch (Exception e) {
			log.debug("messagingTemplate = " + e);
		}
		return 1;
	}

	/**
	 * �씪利덈쿋由� �벑濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertRaspberry.do")
	public @ResponseBody Integer insertRaspberry(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0107", request, requestMap);
		return adminService.insertRaspberry(requestMap);
	}

	/**
	 * �씪利덈쿋由� �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateRaspberry.do")
	public @ResponseBody Integer updateRaspberry(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {	
		commonService.createLog("U", "L0107", request, requestMap);
		return adminService.updateRaspberry(requestMap);
	}

	/**
	 * �씪利덈쿋由� �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteRaspberry.do")
	public @ResponseBody Integer deleteRaspberry(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0107", request, requestMap);
		return adminService.deleteRaspberry(requestMap);
	}

	/**
	 * �씪利덈쿋由� �뿰寃� �옣�냼 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectRaspberryConnectionList.do")
	public @ResponseBody HashMap<String, Object> selectRaspberryConnectionList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectRaspberryConnectionList(requestMap);
	}

	/**
	 * �씪利덈쿋由� �뿰寃� �옣�냼 �벑濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertRaspberryConnection.do")
	public @ResponseBody Integer insertRaspberryConnection(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		return adminService.insertRaspberryConnection(requestMap);
	}

	/**
	 * �씪利덈쿋由� �뿰寃� �옣�냼 �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateRaspberryConnection.do")
	public @ResponseBody Integer updateRaspberryConnection(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		return adminService.updateRaspberryConnection(requestMap);
	}

	/**
	 * �씪利덈쿋由� �뿰寃� �옣�냼 �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteRaspberryConnection.do")
	public @ResponseBody Integer deleteRaspberryConnection(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		return adminService.deleteRaspberryConnection(requestMap);
	}

	/**
	 * �옄猷뚯떎 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectMaterialList.do")
	public @ResponseBody HashMap<String, Object> selectMaterialList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectMaterialList(requestMap);
	}

	/**
	 * �옄猷뚯떎 �벑濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertMaterial.do")
	public @ResponseBody Integer insertMaterial(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		commonUtil.hashmapToString(requestMap);
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);
		if (!fileList.isEmpty()) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
			requestMap.put("oriFileName", ftpFileList.get(0).get("originalFileName"));
		}

		commonService.createLog("C", "L0110", request, requestMap);
		return adminService.insertMaterial(requestMap);
	}

	/**
	 * �옄猷뚯떎 �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateMaterial.do")
	public @ResponseBody Integer updateMaterial(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);
		if (!fileList.isEmpty()) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
			requestMap.put("oriFileName", ftpFileList.get(0).get("originalFileName"));
		}

		commonService.createLog("U", "L0110", request, requestMap);
		return adminService.updateMaterial(requestMap);
	}

	/**
	 * �옄猷뚯떎 �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteMaterial.do")
	public @ResponseBody Integer deleteMaterial(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0110", request, requestMap);
		return adminService.deleteMaterial(requestMap);
	}

	/**
	 * �뻾�궗 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectEventList.do")
	public @ResponseBody HashMap<String, Object> selectEventList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectEventList(requestMap);
	}

	/**
	 * �뻾�궗 �벑濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertEvent.do")
	public @ResponseBody HashMap<String, Object> insertEvent(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr) throws Exception {
		
		commonUtil.hashmapToString(requestMap);
		
		//System.out.println("fileList 시작 ");

		//20220412 이미지 압축 로직 추가
		List<HashMap<String, Object>> fileList = commonUtil.NewMultiFileUploadUtility(mhsr);
		
			if (!fileList.isEmpty()) {
			
				//image size err
				if(fileList.get(0).get("picture").toString().equals("9999")) {
					requestMap.put("pictureErr", "9999");			
					return requestMap;
				}
				List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
				requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
			}
						

		if (adminService.insertEvent(requestMap) == 1) {
			requestMap.put("eventNo", requestMap.get("EVENT_NO"));

			if (requestMap.get("binsoList") != null) {
				List<HashMap<String, Object>> binsoList = commonUtil.jsonStringToList(requestMap.get("binsoList").toString());
				requestMap.put("binsoList", binsoList);
				adminService.insertEventRpiConnection(requestMap);
			}

			if (requestMap.get("chiefMournerList") != null && !requestMap.get("chiefMournerList").equals("")) {
				List<HashMap<String, Object>> cmList = commonUtil.jsonStringToList(requestMap.get("chiefMournerList").toString());
				if (!cmList.isEmpty()) {
					requestMap.put("cmList", cmList);
					adminService.insertEventFamily(requestMap);
				}
			}

			if (requestMap.get("carInfoList") != null && !requestMap.get("carInfoList").equals("")) {
				List<HashMap<String, Object>> carInfoList = commonUtil.jsonStringToList(requestMap.get("carInfoList").toString());
				if (!carInfoList.isEmpty()) {
					requestMap.put("carInfoList", carInfoList);
					adminService.insertEventCar(requestMap);
				}
			}

			// �뻾�궗 �벑濡� - �삁�빟�뻾�궗 �벑濡앹떆 �솕硫� �뾽�뜲�씠�듃 諛⑹�
			requestMap.put("eventType", "insert");
			requestMap.put("eventAliveFlag", "true");

			requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1", requestMap.get("rpiBinsoNo").toString(), null);
			
			requestMap.put("flag", "3");
			HashMap<String, Object> tmpMap = adminService.selectRaspEvent(requestMap);
			if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
			
		}

//		遺�怨좎옣�쟾�넚
//		if(requestMap.get("obituaryPhoneList") != null) requestMap.put("obituaryPhoneList", requestMap.get("obituaryPhoneList").toString().split(","));
		return requestMap;
	}

	/**
	 * �뻾�궗 �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateEvent.do")
	public @ResponseBody HashMap<String, Object> updateEvent(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr) throws Exception {
		commonUtil.hashmapToString(requestMap);
		
		System.out.println("업데이트 시작 ");
		
		//20220412 이미지 압축 로직 추가
		
		List<HashMap<String, Object>> fileList = commonUtil.NewMultiFileUploadUtility(mhsr);
		
		if (!fileList.isEmpty()) {
			
			//image size err
			if(fileList.get(0).get("picture").toString().equals("9999")) {
				requestMap.put("pictureErr", "9999");			
				return requestMap;
			}
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
		}
									
		if (requestMap.get("eventNo") != null && !requestMap.get("eventNo").equals("") && adminService.updateEvent(requestMap) == 1) {
			if (requestMap.get("binsoList") != null) {
				List<HashMap<String, Object>> binsoList = commonUtil.jsonStringToList(requestMap.get("binsoList").toString());
				requestMap.put("binsoList", binsoList);
				if(adminService.deleteEventRpiConnection(requestMap) > -1)
					adminService.insertEventRpiConnection(requestMap);
			}
			adminService.deleteEventFamily(requestMap);
			if (requestMap.get("chiefMournerList") != null && !requestMap.get("chiefMournerList").equals("")) {
				List<HashMap<String, Object>> cmList = commonUtil.jsonStringToList(requestMap.get("chiefMournerList").toString());
				if (!cmList.isEmpty()) {
					requestMap.put("cmList", cmList);
					adminService.insertEventFamily(requestMap);
				}
			}

			if (requestMap.get("carInfoList") != null && !requestMap.get("carInfoList").equals("")) {
				List<HashMap<String, Object>> carInfoList = commonUtil.jsonStringToList(requestMap.get("carInfoList").toString());
				if (!carInfoList.isEmpty()) {
					requestMap.put("carInfoList", carInfoList);
					adminService.deleteEventCar(requestMap);
					adminService.insertEventCar(requestMap);
				}
			}
			
			requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1", requestMap.get("orginBinsoNo").toString(), null);
			
			if(requestMap.get("eventAliveFlag") != null && requestMap.get("eventAliveFlag").toString().equals("1")) {
				requestMap.put("eventAliveFlag", "true");
				requestMap.put("flag", "3");
				HashMap<String, Object> tmpMap = adminService.selectRaspEvent(requestMap);
				if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
			}
		
		}
		return requestMap;
		
	}

	/**
	 * �뻾�궗 �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteEvent.do")
	public @ResponseBody Integer deleteEvent(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		if(requestMap.get("eventAliveFlag") != null && requestMap.get("eventAliveFlag").toString().equals("1")) {

			// �뻾�궗 �궘�젣 = �쁺�젙�궗吏� �뾽�뜲�씠�듃 �븞�릺�꽌 �뵆�옒洹� 10�쑝濡� 蹂�寃�
			requestMap.put("eventType", "delete");
			requestMap.put("eventAliveFlag", "true");
			requestMap.put("flag", "10");
			HashMap<String, Object> tmpMap = adminService.selectRaspEvent(requestMap);
			if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		}
		
		if (adminService.deleteEvent(requestMap) == 1) {
			adminService.deleteEventRpiConnection(requestMap);
			adminService.deleteEventFamily(requestMap);
			adminService.deleteEventCar(requestMap);
			adminService.deleteEventCalculate(requestMap);
			
			
			requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1",  requestMap.get("rpiBinsoNo").toString(), null);
			return 1;
		} else
			return 0;
	}

	
	
	/**
	 * �씠踰ㅽ듃 �긽�꽭�젙蹂� 醫낇빀
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectEventDetail.do")
	public @ResponseBody HashMap<String, Object> selectEventDetail(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectEventDetail(requestMap);
	}

	/**
	 * �쁽�솴�뙋 �긽�꽭�젙蹂�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectRaspberryStatusPlateList.do")
	public @ResponseBody List<HashMap<String, Object>> selectRaspberryStatusPlateList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectRaspberryStatusPlateList(requestMap);
	}

	/**
	 * �쁽�솴�뙋 ���옣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertRaspberryStatusPlate.do")
	public @ResponseBody Integer insertRaspberryStatusPlate(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr) throws Exception {
		commonUtil.hashmapToString(requestMap);

		if (adminService.insertRaspberryStatusPlate(requestMap) == 1) {
			List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);
			requestMap.put("statusPlateNo", requestMap.get("STATUS_PLATE_NO"));
			if (requestMap.get("binsoList") != null && !requestMap.get("binsoList").equals("")) {
				requestMap.put("binsoList", requestMap.get("binsoList").toString().split(","));
				adminService.insertStatusPlateBinso(requestMap);
			} else if (!fileList.isEmpty()) {
				List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
				requestMap.put("fileList", ftpFileList);
				adminService.insertStatusPlateFiles(requestMap);
			}

			// 硫��떚�솕硫댁씪 寃쎌슦 議곌굔
			requestMap.put("flag", "3");
			if(requestMap.get("classification").equals("30") && requestMap.get("multiMode").equals("1")) {
				HashMap<String, Object> tmpMap = adminService.selectRaspMultiPythonInfo(requestMap);
				if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);			
			}else {
				HashMap<String, Object> tmpMap = adminService.selectRaspPythonInfo(requestMap);
				if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);			
			}
			
			requestMap.put("raspberryConnectionNo", null);
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1", "", null);
		}

		return 1;
	}

	/**
	 * �쁽�솴�뙋 �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateRaspberryStatusPlate.do")
	public @ResponseBody Integer updateRaspberryStatusPlate(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr) throws Exception {
		commonUtil.hashmapToString(requestMap);

		// 硫��떚�솕硫� �뿉�꽌 硫��떚�솕硫� 耳곕떎媛� 猿륁쓣 寃쎌슦 湲곗〈 硫��떚�솕硫� �깉濡쒓퀬移� �봽濡쒖꽭�뒪 異붽�
		// raspNo 媛��졇���꽌 �옄�떊 �젣�쇅�븯湲� -> �깉濡쒓퀬移� 2踰� �릺�뒗寃쎌슦 泥섎━
		requestMap.put("flag", "3");
		
		if(requestMap.get("originMultiMode") != null && requestMap.get("originMultiMode").equals("1") && requestMap.get("multiMode").equals("2")) {
			HashMap<String, Object> tmpMap = adminService.selectRaspMultiPythonInfoExcept(requestMap);
			if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		}
		
		
		if (adminService.updateRaspberryStatusPlate(requestMap) == 1) {
			List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);
			if (requestMap.get("binsoList") != null && !requestMap.get("binsoList").equals("")) {
				requestMap.put("binsoList", requestMap.get("binsoList").toString().split(","));
				if(adminService.deleteStatusPlateBinso(requestMap) > -1)
					adminService.insertStatusPlateBinso(requestMap);
			} else {
				adminService.deleteStatusPlateFiles(requestMap);
				if (!fileList.isEmpty()) {
					List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
					requestMap.put("fileList", ftpFileList);
					adminService.insertStatusPlateFiles(requestMap);
				}
			}

			// 硫��떚�솕硫댁씪 寃쎌슦 議곌굔
			if(requestMap.get("classification").equals("30") && requestMap.get("multiMode").equals("1")) {
				HashMap<String, Object> tmpMap = adminService.selectRaspMultiPythonInfo(requestMap);
				if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);			
			}else {
				HashMap<String, Object> tmpMap = adminService.selectRaspPythonInfo(requestMap);
				if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);			
			}
			

			String rpiNo = requestMap.get("raspberryConnectionNo").toString();
			requestMap.put("raspberryConnectionNo", null);
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1", rpiNo, null);
		}

		return 1;
	}

	/**
	 * �쁽�솴�뙋 �뒪���씪 由ъ뒪�듃
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectStatusPlateStyle.do")
	public @ResponseBody List<HashMap<String, Object>> selectStatusPlateStyle(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectStatusPlateStyle(requestMap);
	}

	/**
	 * �쁽�솴�뙋 諛곌꼍�솕硫� 由ъ뒪�듃
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectStatusPlateBg.do")
	public @ResponseBody List<HashMap<String, Object>> selectStatusPlateBg(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectStatusPlateBg(requestMap);
	}
	

	/**
	 * �쁽�솴�뙋 諛곌꼍�솕硫� �벑濡� - 醫낃탳�씠誘몄� 珥덇린�솕
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/resetStatusPlateBg.do")
	public @ResponseBody Integer resetStatusPlateBg(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		adminService.resetStatusPlateBg(requestMap);
		return 1;
	}

	/**
	 * �쁽�솴�뙋 諛곌꼍�솕硫� �벑濡� - 醫낃탳�씠誘몄� 蹂�寃�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertStatusPlateBg.do")
	public @ResponseBody Integer insertStatusPlateBg(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr) throws Exception {
		commonUtil.hashmapToString(requestMap);
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);

		if (!fileList.isEmpty()) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put("file", ftpFileList.get(0).get("fileFullPath"));
			adminService.insertStatusPlateBg(requestMap);
		} else {
			adminService.insertStatusPlateBg(requestMap);
		}

		requestMap.put("flag", "3");
		HashMap<String, Object> tmpMap = adminService.selectReligionRaspList(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		
		requestMap.put("fcmClassification", "10");
		List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
		commonUtil.sendCloudMessages(rpiList, "1", "", null);
		return 1;
	}

	/**
	 * �쁽�솴�뙋 諛곌꼍�솕硫� �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteStatusPlateBg.do")
	public @ResponseBody Integer deleteStatusPlateBg(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.deleteStatusPlateBg(requestMap);
	}

	/**
	 * �쁽�솴�뙋 �뙆�씪 由ъ뒪�듃
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectStatusPlateFiles.do")
	public @ResponseBody List<HashMap<String, Object>> selectStatusPlateFiles( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectStatusPlateFiles(requestMap);
	}

	/**
	 * �쁽�솴�뙋�젙蹂� (�엫�떆)
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectRpiScreen.do")
	public @ResponseBody List<HashMap<String, Object>> selectRpiScreen(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectRpiScreen(requestMap);
	}

	/**
	 * �뻾�궗 �쁽�솴�뙋 (怨듭떎�룷�븿)
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectAllEventList.do")
	public @ResponseBody List<HashMap<String, Object>> selectAllEventList( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectAllEventList(requestMap);
	}

	/**
	 * �뻾�궗 �쑀媛�議� 媛��졇�삤湲�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectEventFamily.do")
	public @ResponseBody List<HashMap<String, Object>> selectEventFamily( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectEventFamily(requestMap);
	}

	/**
	 * 醫낇빀�쁽�솴�뙋 �긽�꽭�젙蹂�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectStatusPlateDetail.do")
	public @ResponseBody HashMap<String, Object> selectStatusPlateDetail(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectStatusPlateDetail(requestMap);
	}

	/**
	 * �쁺�젙�뾽泥� 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPhotoManagerList.do")
	public @ResponseBody HashMap<String, Object> selectPhotoManagerList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectPhotoManagerList(requestMap);
	}

	/**
	 * �쁺�젙�뾽泥� �벑濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertPhotoManager.do")
	public @ResponseBody Integer insertPhotoManager(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.insertPhotoManager(requestMap);
	}

	/**
	 * �쁺�젙�뾽泥� �닔�젙
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updatePhotoManager.do")
	
	public @ResponseBody Integer updatePhotoManager(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr) throws Exception {
		commonUtil.hashmapToString(requestMap);
		
		List<HashMap<String, Object>> fileList = commonUtil.NewMultiFileUploadUtility(mhsr);
		
		//20220412 이미지 압축 기존 주석 처리 후 추가
		if (!fileList.isEmpty()) {
			
			//image size err
			if(fileList.get(0).get("picture").toString().equals("9999")) {
				//requestMap.put("pictureErr", "9999");			
				return 9999;
			}
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
		}
		
		/*
		if (!fileList.isEmpty()) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
		}
		*/

		if (adminService.updatePhotoManager(requestMap) == 1) {
			requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1", "", null);
			
			// �쁺�젙�궗吏� �뾽�뜲�씠�듃�븷�븣 �냼耳볧넻�떊�븯湲�
			requestMap.put("flag", "9");
			HashMap<String, Object> tmpMap = adminService.selectYjRaspList(requestMap);
			if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
			
			return 1;
		} else
			return 0;
	}

	/**
	 * �쁺�젙�뾽泥� �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deletePhotoManager.do")
	public @ResponseBody Integer deletePhotoManager(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.deletePhotoManager(requestMap);
	}

	/**
	 * �뻾�궗 �쁺�젙�궗吏� �궘�젣
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteDmPhoto.do")
	public @ResponseBody Integer deleteDmPhoto(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);

		requestMap.put("eventAliveFlag", "true");
		requestMap.put("flag", "3");
		HashMap<String, Object> tmpMap = adminService.selectRaspEvent(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		
		return adminService.deleteDmPhoto(requestMap);
	}

	/**
	 * �뻾�궗留덇컧
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateEventAliveFlag.do")
	public @ResponseBody Integer updateEventAliveFlag(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		
		requestMap.put("flag", "10");
		HashMap<String, Object> tmpMap = adminService.selectRaspEvent(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		
		if (adminService.updateEventAliveFlag(requestMap) == 1) {
			requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1",  requestMap.get("rpiBinsoNo").toString(), null);
			return 1;
		} else
			return 0;
	}

	/**
	 * �씪利덈쿋由� 而⑦듃濡�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertRpiControll.do")
	public @ResponseBody Integer insertRpiControll(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);

		HashMap<String, Object> map = new HashMap<String, Object>();
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		HashMap<String, Object> tmpMap = new HashMap<String, Object>();
		tmpMap.put("RASPBERRY_CONNECTION_NO", requestMap.get("raspberryConnectionNo"));
		tmpMap.put("FLAG", requestMap.get("socketFlag"));
		list.add(tmpMap);
		map.put("list", list);
		if(!map.get("list").toString().equals("[]")) socketServer.send(map);
		
		return adminService.insertRpiControll(requestMap);
	}

	/**
	 * 濡쒓렇 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectLogList.do")
	public @ResponseBody HashMap<String, Object> selectLogList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectLogList(requestMap);
	}

	/**
	 * 紐⑤컮�씪 �쁺�젙�궗吏� 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPhotoDetail.do")
	public @ResponseBody HashMap<String, Object> selectPhotoDetail(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectPhotoDetail(requestMap);
	}

	/**
	 * �뻾�궗 遺�怨좎옣 蹂대궡湲�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertEventObituary.do")
	public @ResponseBody Integer insertObituary(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.insertEventObituary(requestMap);
	}

	/**
	 * �뻾�궗 遺�怨좎옣 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectEventObituaryList.do")
	public @ResponseBody HashMap<String, Object> selectEventObituaryList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectEventObituaryList(requestMap);
	}

	/**
	 * �솕硫닿�由� 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectScreen10List.do")
	public @ResponseBody HashMap<String, Object> selectScreen10List(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectScreen10List(requestMap);
	}

	/**
	 * �솕硫닿�由� 由ъ뒪�듃 異쒕젰
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectScreen30List.do")
	public @ResponseBody HashMap<String, Object> selectScreen30List(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectScreen30List(requestMap);
	}

	
	/**
	 * �옣濡��떇�옣 �쓬�썝�뙆�씪 �젙蹂� 議고쉶�븯湲�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectFuneralMusic.do")
	public @ResponseBody HashMap<String, Object> selectFuneralMusic(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectFuneralMusic(requestMap);
	}
	
	/**
	 * �옣濡��떇�옣 �쓬�썝�뙆�씪 �젙蹂� �궫�엯�븯湲�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/insertFuneralMusic.do")
	public @ResponseBody Integer insertFuneralMusic(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		commonUtil.hashmapToString(requestMap);
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);
		if (!fileList.isEmpty()) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
			requestMap.put("oriFileName", ftpFileList.get(0).get("originalFileName"));
		}
		
		commonService.createLog("C", "L0125", request, requestMap);
		return adminService.insertFuneralMusic(requestMap);
	}

	/**
	 * �옣濡��떇�옣 �쓬�썝�뙆�씪 �젙蹂� �뾽�뜲�씠�듃�븯湲�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	
	@RequestMapping(value = "/admin/updateFuneralMusic.do")
	public @ResponseBody Integer updateFuneralMusic(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);
		if (!fileList.isEmpty()) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			requestMap.put(ftpFileList.get(0).get("fileKey").toString(), ftpFileList.get(0).get("fileFullPath"));
			requestMap.put("oriFileName", ftpFileList.get(0).get("originalFileName"));
		}

		commonService.createLog("U", "L0125", request, requestMap);
		return adminService.updateFuneralMusic(requestMap);
	}
	
	/**
	 * �옣濡��떇�옣 �쓬�썝�뙆�씪 �젙蹂� �궘�젣�븯湲�
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/deleteFuneralMusic.do")
	public @ResponseBody Integer deleteFuneralMusic(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		return adminService.deleteFuneralMusic(requestMap);
	}

	
	

	/**
	 * �쓬�썝 �벑濡앹쓣 �쐞�븳 �씪利덈쿋由� 議고쉶
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectRaspForMusic.do")
	public @ResponseBody HashMap<String, Object> selectRaspForMusic(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectRaspForMusic(requestMap);
	}
	
	/**
	 * �쓬�썝 �닔�젙�쓣 �쐞�븳 �씪利덈쿋由� �뾽�뜲�씠�듃
	 * 
	 * @param HashMap<String, Object> requestMap
	 * @return Integer
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/updateRaspForMusic.do")
	public @ResponseBody Integer updateRaspForMusic(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		//requestMap�뿉 raspberry ID瑜� �꽔�쑝硫� �빐�떦�븯�뒗 �씪利덈쿋由� �젙蹂� 由ъ뒪�듃瑜� 媛��졇�삩�떎 -> rpiList
		List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
		commonUtil.sendCloudMessages(rpiList, "1",  "", null);
		
		adminService.updateRaspForMusic(requestMap);
		
		requestMap.put("flag", "2");
		HashMap<String, Object> tmpMap = adminService.selectPreviewUpdateMusic(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		return 1; 
	}

	
	/**
	 * �빐�떦 �뻾�궗�쓽 �쓬�썝 踰덊샇 議고쉶
	 * �씠踰ㅽ듃 踰덊샇瑜� �엯�젰諛쏆븘 �씪利덈쿋由� 踰덊샇瑜� 李얘퀬, �빐�떦�븯�뒗 �씪利덈쿋由ъ쓽 �쓬�썝�씠 �엳�떎硫� �쟾�떖�븳
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectEvtForMusic.do")
	public @ResponseBody HashMap<String, Object> selectEvtForMusic(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectEvtForMusic(requestMap);
	}
	
	/**
	 * 醫낇빀�쁽�솴 議고쉶
	 * �쟾�떖諛쏆� con_no瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectJonghapPreview.do")
	public @ResponseBody HashMap<String, Object> selectJonghapPreview(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectJonghapPreview(requestMap);
	}
	
	/**
	 * �씪利덈쿋由� �냽�꽦 議고쉶
	 * �쟾�떖諛쏆� con_no瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPreviewWhoIAm.do")
	public @ResponseBody HashMap<String, Object> selectPreviewWhoIAm(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectPreviewWhoIAm(requestMap);
	}

	/**
	 * 鍮덉냼 �쑀�슚�꽦 議고쉶
	 * �쟾�떖諛쏆� con_no瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPreviewFindBinsoEvent.do")
	public @ResponseBody HashMap<String, Object> selectPreviewFindBinsoEvent(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectPreviewFindBinsoEvent(requestMap);
	}
	
	
	/**
	 * 鍮덉냼 �쑀�슚�꽦 議고쉶 - �궪�쑁 踰꾩쟾 �엯愿� �씪利덈쿋由щ꽆踰꾨줈 �뻾�궗 議고쉶
	 * �쟾�떖諛쏆� con_no瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPreviewSYIPEvent.do")
	public @ResponseBody HashMap<String, Object> selectPreviewSYIPEvent(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectPreviewSYIPEvent(requestMap);
	}
	

	/**
	 * �궪�쑁 踰꾩쟾 �엯愿� �씪利덈쿋由щ꽆踰꾨줈 �뒪���씪 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPreviewSYIPStyle.do")
	public @ResponseBody HashMap<String, Object> selectPreviewSYIPStyle(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectPreviewSYIPStyle(requestMap);
	}
	
	
	
	/**
	 * 硫��떚紐⑤뱶 議고쉶
	 * �쟾�떖諛쏆� 洹몃９�씠由꾧낵 �옣濡��떇�옣 踰덊샇瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPreviewFindMultiMode.do")
	public @ResponseBody HashMap<String, Object> selectPreviewFindMultiMode(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectPreviewFindMultiMode(requestMap);
	}
	/**
	 * �빐�떦 醫낇빀�뿉 �룷�븿�맂 鍮덉냼 議고쉶
	 * �쟾�떖諛쏆� con_no瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectJonghapBinsoForPreview.do")
	public @ResponseBody HashMap<String, Object> selectJonghapBinsoForPreview(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectJonghapBinsoForPreview(requestMap);
	}
	
	/**
	 * �옣濡��떇�옣蹂� �쁽�솴�뙋 誘몃━蹂닿린 �솕硫�
	 * �쟾�떖諛쏆� funeral_no瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	/*
	 * @RequestMapping(value = "/admin/selectEventForFuneralPreview.do")
	 * public @ResponseBody HashMap<String, Object>
	 * selectEventForFuneralPreview(@RequestParam HashMap<String, Object>
	 * requestMap) throws Exception { return
	 * adminService.selectEventForFuneralPreview(requestMap); }
	 */
	/*
	 * @param HashMap<String, Object> requestMap
	 * @param HttpServletRequest request  // modify by LSH - 23.03.21
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectEventForFuneralPreview.do")
	public @ResponseBody HashMap<String, Object> selectEventForFuneralPreview(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		String referer = request.getHeader("referer");
		System.out.println("selectEventForFuneralPreview referer : "+referer);
		if(referer != null && referer.indexOf("dslink")>0 )
			return adminService.selectEventForFuneralPreview(requestMap);
		else 
			return null;
	}


	/**
	 * �옣濡��떇�옣蹂� �쁽�솴�뙋 ��湲� �솕硫�
	 * �쟾�떖諛쏆� �씪利덈쿋由щ쾲�샇瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectSpecialPreview.do")
	public @ResponseBody HashMap<String, Object> selectSpecialPreview(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectSpecialPreview(requestMap);
	}

	/**
	 * �옣濡��떇�옣蹂� �쁽�솴�뙋 �듅�닔 �솕硫�
	 * �쟾�떖諛쏆� �씪利덈쿋由щ쾲�샇瑜� �넻�빐 議고쉶
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectWaitPreview.do")
	public @ResponseBody HashMap<String, Object> selectWaitPreview(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectWaitPreview(requestMap);
	}
	

	/**
	 * �쁺�젙�솕硫� �쓣�슦湲�
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectYJPreview.do")
	public @ResponseBody HashMap<String, Object> selectYJPreview(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectYJPreview(requestMap);
	}

	/**
	 * �엯愿��솕硫� �쓣�슦湲�
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectIpGwanPreview.do")
	public @ResponseBody HashMap<String, Object> selectIpGwanPreview(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectIpGwanPreview(requestMap);
	}

	/**
	 * �긽媛��솕硫�
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectSanggaList.do")
	public @ResponseBody HashMap<String, Object> selectSanggaList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return adminService.selectSanggaList(requestMap);
	}
	
	/**
	 * ��湲고솕硫댁씪�븣 �룞�쁺�긽 �뜲�씠�꽣 媛��졇�삤湲�
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectWaitVideo.do")
	public @ResponseBody HashMap<String, Object> selectWaitVideo(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("flag", "1");
		HashMap<String, Object> tmpMap = adminService.selectWaitVideo(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		return requestMap;
	}
	
	
	/**
	 * �듅�닔�솕硫댁씪�븣 �룞�쁺�긽 �뜲�씠�꽣 媛��졇�삤湲�
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectSpecialVideo.do")
	public @ResponseBody HashMap<String, Object> selectSpecialVideo(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("flag", "1");
		HashMap<String, Object> tmpMap = adminService.selectSpecialVideo(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		return requestMap;
	}
	

	/**
	 * �솕硫�(鍮덉냼, �쁺�젙, �엯愿�, �듅�닔) �쓬�썝 �뜲�씠�꽣 媛��졇�삤湲�
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	@RequestMapping(value = "/admin/selectPreviewMusic.do")
	public @ResponseBody HashMap<String, Object> selectPreviewMusic(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("flag", "2");
		HashMap<String, Object> tmpMap = adminService.selectPreviewMusic(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		return requestMap;
	}
	
	/***
	 * 염습대장
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/selectShroudNote.do")
	public @ResponseBody HashMap<String, Object> selectShroudNote(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectShroudNote(requestMap);
	}

	/***
	 * 정산 제품 사용량 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/selectProductUsage.do")
	public @ResponseBody HashMap<String, Object> selectProductUsage(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectProductUsage(requestMap);
	}	
	
	/***
	 * 정산 정산표 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/selectSettlementTable.do")
	public @ResponseBody HashMap<String, Object> selectSettlementTable(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectSettlementTable(requestMap);
	}
	
	/***
	 * 정산 정산표합계 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/selectSumSettlementTable.do")
	public @ResponseBody HashMap<String, Object> selectSumSettlementTable(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectSumSettlementTable(requestMap);
	}	
	
	/***
	 * 정산 영수증 출력
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/selectCalculateRecipe.do")
	public @ResponseBody HashMap<String, Object> selectCalculateRecipe (@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminService.selectCalculateRecipe(requestMap);
	}	
}
