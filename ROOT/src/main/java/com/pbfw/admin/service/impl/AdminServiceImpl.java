package com.pbfw.admin.service.impl;

import java.util.ArrayList;
import org.apache.commons.net.util.Base64;
import javax.servlet.http.HttpServletRequest;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pbfw.admin.mapper.AdminMapper;
import com.pbfw.admin.service.AdminService;
import com.pbfw.admin_sec.mapper.AdminSecMapper;
import com.pbfw.choomo.mapper.ChoomoMapper;
import com.pbfw.common.interceptor.LoggerInterceptor;
import com.pbfw.common.util.CommonUtil;

@Service("adminService")
public class AdminServiceImpl implements AdminService {
	protected Logger log = LoggerFactory.getLogger(LoggerInterceptor.class);
	
	@Autowired
	AdminMapper adminMapper;

	@Autowired
	AdminSecMapper adminSecMapper;
	
	@Autowired
	ChoomoMapper choomoMapper;
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	

	public HashMap<String, Object> selectTestList() throws Exception {
		HashMap<String, Object> requestMap = new HashMap<String, Object>(); 
		requestMap.put("list", adminMapper.selectTestList());
		return requestMap;
	}
	
	
	public HashMap<String, Object> selectNoticeList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectNoticeList(requestMap));
		requestMap.put("total", adminMapper.selectNoticeTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer insertNotice(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertNotice(requestMap);
	}
	
	public Integer updateNotice(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateNotice(requestMap);
	}
	
	public Integer deleteNotice(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteNotice(requestMap);
	}
	
	public HashMap<String, Object> selectAllFuneralHallList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectAllFuneralHallList(requestMap));
		requestMap.put("total", adminMapper.selectAllFuneralHallTotalCount(requestMap));
		return requestMap;
	}	
	
	public Integer insertFuneralHall(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertFuneralHall(requestMap);
	}
	
	public Integer updateFuneralHall(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateFuneralHall(requestMap);
	}
	
	public Integer deleteFuneralHall(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteFuneralHall(requestMap);
	}
	
	public HashMap<String, Object> selectRaspberryList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectRaspberryList(requestMap));
		requestMap.put("total", adminMapper.selectRaspberryTotalCount(requestMap));
		return requestMap;
	}	
	
	public Integer insertRaspberry(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertRaspberry(requestMap);
	}
	
	public Integer updateRaspberry(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateRaspberry(requestMap);
	}
	
	public Integer deleteRaspberry(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteRaspberry(requestMap);
	}
	
	public List<HashMap<String, Object>> selectRaspberryControlList(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectRaspberryList(requestMap);
	}	
	
	public Integer updateRaspberryControlReset(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateRaspberryControlReset(requestMap);
	}
	
	public Integer updateRaspberryControl(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateRaspberryControl(requestMap);
	}
	
	
	public HashMap<String, Object> selectRaspberryConnectionList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectRaspberryConnectionList(requestMap));
		requestMap.put("total", adminMapper.selectRaspberryConnectionTotalCount(requestMap));
		requestMap.put("rasp", adminMapper.selectRaspberryList(requestMap));
		return requestMap;
	}	
	
	public Integer insertRaspberryConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertRaspberryConnection(requestMap);
	}
	
	public Integer updateRaspberryConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateRaspberryConnection(requestMap);
	}
	
	public Integer deleteRaspberryConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteRaspberryConnection(requestMap);
	}
	
	public HashMap<String, Object> selectMaterialList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectMaterialList(requestMap));
		requestMap.put("total", adminMapper.selectMaterialTotalCount(requestMap));
		return requestMap;
	}	
	
	public Integer insertMaterial(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertMaterial(requestMap);
	}
	
	public Integer updateMaterial(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateMaterial(requestMap);
	}
	
	public Integer deleteMaterial(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteMaterial(requestMap);
	}
	
	public HashMap<String, Object> selectEventList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectEventList(requestMap));
		requestMap.put("total", adminMapper.selectEventTotalCount(requestMap));
		return requestMap;
	}	
	
	public Integer insertEvent(HashMap<String, Object> requestMap) throws Exception {
		adminMapper.insertEvent(requestMap);
		return 1;
	}

	public Integer updateEvent(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateEvent(requestMap);
	}
	
	public Integer deleteEvent(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteEvent(requestMap);
	}
	
	public Integer insertEventRpiConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertEventRpiConnection(requestMap);
	}
	
	public Integer deleteEventRpiConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteEventRpiConnection(requestMap);
	}
	
	public List<HashMap<String, Object>> selectEventFamily(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectEventFamily(requestMap);
	}
	
	public Integer insertEventFamily(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertEventFamily(requestMap);
	}
	
	public Integer deleteEventFamily(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteEventFamily(requestMap);
	}
	
	public List<HashMap<String, Object>> selectEventCar(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectEventFamily(requestMap);
	}
	
	public Integer insertEventCar(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertEventCar(requestMap);
	}
	
	public Integer deleteEventCar(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteEventCar(requestMap);
	}
	
	public Integer deleteEventCalculate(HashMap<String, Object> requestMap) throws Exception {
		// 二쇰Ц�젙蹂대옉 諛섑뭹�젙蹂�, �엫�쓽�긽�뭹 �젙蹂대쭔 �궘�젣
		// 寃곗젣�젙蹂�, �쁽湲덉쁺�닔利� �궘�젣 �븞�븿.
		adminMapper.deleteEventOrder(requestMap);
		adminMapper.deleteEventTakeBack(requestMap);
		adminMapper.deleteEventRandomItem(requestMap);
		adminMapper.deleteEventOrderTmp(requestMap);
		adminMapper.deleteEventTakeBackTmp(requestMap);
		return 1;
		
	}
	
	
	public HashMap<String, Object> selectEventDetail(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> eventMap = new HashMap<String, Object>(); 
		List<HashMap<String, Object>> eventInfo = adminMapper.selectEventList(requestMap);
		eventMap.put("eventInfo", eventInfo);
		
		if(!eventInfo.isEmpty()) {
			if(requestMap.get("eventNo") == null || requestMap.get("eventNo").equals("")) requestMap.put("eventNo", eventInfo.get(0).get("EVENT_NO"));
			eventMap.put("eventFamilyInfo", adminMapper.selectEventFamily(requestMap));
			eventMap.put("eventCarInfo", adminMapper.selectEventCar(requestMap));
			eventMap.put("music", adminMapper.selectEvtForMusic(requestMap));
			List<HashMap<String, Object>> rpiStatusList = adminMapper.selectRaspberryStatusPlateBinsoList(requestMap);
			if(!rpiStatusList.isEmpty()) eventMap.put("raspberryStatusPlate", rpiStatusList.get(0));
		}
		return eventMap;
	}
	
	public List<HashMap<String, Object>> selectRaspberryStatusPlateList(HashMap<String, Object> requestMap) throws Exception {
		
		HashMap<String, Object> musictMap = new HashMap<String, Object>(); 
		musictMap.put("music", adminMapper.selectEvtForMusic(requestMap));
		
		List<HashMap<String, Object>> temp = adminMapper.selectRaspberryStatusPlateList(requestMap);
		temp.add(musictMap);		
		return temp;
	}

	public Integer insertRaspberryStatusPlate(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertRaspberryStatusPlate(requestMap);
	}
	
	public Integer updateRaspberryStatusPlate(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateRaspberryStatusPlate(requestMap);
	}
	
	public List<HashMap<String, Object>> selectStatusPlateStyle(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectStatusPlateStyle(requestMap);
	}
	
	public List<HashMap<String, Object>> selectStatusPlateBg(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectStatusPlateBg(requestMap);
	}

	public Integer resetStatusPlateBg(HashMap<String, Object> requestMap) throws Exception { 
		adminMapper.deleteStatusPlateBg(requestMap);
		List<HashMap<String, Object>> temp = new ArrayList<>();
		String[] arr = {"http://211.251.237.150:7080/dsfiles/religion/christian/christian_1.png"
					, "http://211.251.237.150:7080/dsfiles/religion/catholic/catholic_1.png"
					,"http://211.251.237.150:7080/dsfiles/religion/buddhism/buddhism_4.png"
					,"http://211.251.237.150:7080/dsfiles/religion/wonbuddhism/wonbuddhism_2.png"
					,"http://211.251.237.150:7080/dsfiles/religion/merit/merit_2.png"};
		for(int i = 0; i < 5; i++) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("religionNo", i+1);
			map.put("file", arr[i]);
			temp.add(map);
		}
		requestMap.put("list", temp);
		return adminMapper.resetStatusPlateBg(requestMap);
	}
	
	public Integer insertStatusPlateBg(HashMap<String, Object> requestMap) throws Exception { 
		return adminMapper.insertStatusPlateBg(requestMap);
	}
	
	public Integer deleteStatusPlateBg(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteStatusPlateBg(requestMap);
	}
	
	public Integer insertStatusPlateBinso(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertStatusPlateBinso(requestMap);
	}
	
	public Integer deleteStatusPlateBinso(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteStatusPlateBinso(requestMap);
	}
	
	public List<HashMap<String, Object>> selectStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectStatusPlateFiles(requestMap);
	}
	
	public Integer insertStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertStatusPlateFiles(requestMap);
	}
	
	public Integer deleteStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteStatusPlateFiles(requestMap);
	}
	
	public List<HashMap<String, Object>> selectAllEventList(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectAllEventList(requestMap);
	}
	
	public List<HashMap<String, Object>> selectRpiScreen(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectRpiScreen(requestMap);
	}
	
	
	public HashMap<String, Object> selectStatusPlateDetail(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<>();
//		System.out.println("醫낇빀�쁽�솴�뙋 �긽�꽭�솕硫�");
		List<HashMap<String, Object>> rpiStatusList = adminMapper.selectRaspberryStatusPlateList(requestMap);
		
		if(!rpiStatusList.isEmpty()) {
			// 醫낇빀 硫��떚紐⑤뱶媛� �븘�땺 寃쎌슦
			if(rpiStatusList.get(0).get("MULTI_MODE").toString().equals("2")) {
//				System.out.println("硫��떚紐⑤뱶 �븘�땺寃쎌슦");
				
				HashMap<String, Object> detailMap = adminMapper.selectRaspberryStatusPlateList(requestMap).get(0);
				resultMap.put("style", detailMap);
				
				String [] binsoStr = detailMap.get("BINSO_LIST").toString().split(",");
				List<HashMap<String, Object>> list = new ArrayList<>();
				
				for(String binsoNo:binsoStr) {
					requestMap.put("raspberryConnectionNo", binsoNo);
					HashMap<String, Object> binsoMap = new HashMap<String, Object>();
					
					requestMap.put("eventNo", "");
					requestMap.put("orderNo", "1");
					HashMap<String, Object> eventMap = adminMapper.selectEventList(requestMap).isEmpty() ? null:adminMapper.selectEventList(requestMap).get(0);
					
					if(eventMap != null) {
						requestMap.put("eventNo", eventMap.get("EVENT_NO"));
						
						binsoMap.put("eventInfo", eventMap);
						binsoMap.put("eventFamilyInfo", adminMapper.selectEventFamily(requestMap));
						binsoMap.put("eventCarInfo", adminMapper.selectEventCar(requestMap));
						list.add(binsoMap);
					}
				}
				
				resultMap.put("binsoList", list);
			}else {
				//硫��떚紐⑤뱶�씪 寃쎌슦
				//泥섏쓬 醫낇빀�벑濡� �썑 �옣濡��떇�옣 �솕硫닿�由ъ뿉�꽌 珥덇린�꽕�젙 �븞�뻽�쓣�떆 flow�옉 媛숈쓬
//				resultMap.put("style", adminMapper.selectStatusPlateStyle(requestMap).get(0));
				List<HashMap<String, Object>> eventList = adminMapper.selectEventGeneralList(requestMap);
				List<HashMap<String, Object>> list = new ArrayList<>();
				
				if(eventList != null) {
					for(HashMap<String, Object> map:eventList) {
						HashMap<String, Object> binsoMap = new HashMap<String, Object>();

						requestMap.put("statusPlateStyleNo", map.get("STATUS_PLATE_STYLE_NO"));


//						resultMap.put("style", adminMapper.selectStatusPlateStyle(requestMap).get(0));
						resultMap.put("style", adminMapper.selectRaspberryStatusPlateList(requestMap).get(0));
						
						
						requestMap.put("eventNo", map.get("EVENT_NO"));
						binsoMap.put("eventInfo", map);
						binsoMap.put("eventFamilyInfo", adminMapper.selectEventFamily(requestMap));
						binsoMap.put("eventCarInfo", adminMapper.selectEventCar(requestMap));
						list.add(binsoMap);
					}
				}
				resultMap.put("binsoList", list);
				
			}
		}
		else {
			//泥섏쓬 醫낇빀�벑濡� �썑 �옣濡��떇�옣 �솕硫닿�由ъ뿉�꽌 珥덇린�꽕�젙 �븞�뻽�쓣�떆 flow
			requestMap.put("statusPlateStyleBasic", "true");
//			resultMap.put("style", adminMapper.selectStatusPlateStyle(requestMap).get(0));
			resultMap.put("style", adminMapper.selectRaspberryStatusPlateList(requestMap).get(0));

			List<HashMap<String, Object>> eventList = adminMapper.selectEventGeneralList(requestMap);
			List<HashMap<String, Object>> list = new ArrayList<>();
			
			if(eventList != null) {
				for(HashMap<String, Object> map:eventList) {
					HashMap<String, Object> binsoMap = new HashMap<String, Object>();
					
					requestMap.put("eventNo", map.get("EVENT_NO"));
					binsoMap.put("eventInfo", map);
					binsoMap.put("eventFamilyInfo", adminMapper.selectEventFamily(requestMap));
					binsoMap.put("eventCarInfo", adminMapper.selectEventCar(requestMap));
					list.add(binsoMap);
				}
			}
			resultMap.put("binsoList", list);
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> selectPhotoManagerList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectPhotoManagerList(requestMap));
		requestMap.put("total", adminMapper.selectPhotoManagerTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer insertPhotoManager(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertPhotoManager(requestMap);
	}
	
	public Integer updatePhotoManager(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updatePhotoManager(requestMap);
	}
	
	public Integer deletePhotoManager(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deletePhotoManager(requestMap);
	}
	
	public Integer deleteDmPhoto(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteDmPhoto(requestMap);
	}
	
	public Integer updateEventAliveFlag(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateEventAliveFlag(requestMap);
	}
	
	public Integer insertRpiControll(HashMap<String, Object> requestMap) throws Exception {
		List<HashMap<String, Object>> list = adminMapper.selectRaspberryList(requestMap);
		
		if(list.isEmpty()) {
			return 0;
		} else {
			commonUtil.sendCloudMessages(list, requestMap.get("codeValue").toString(), "", null);
			return 1;
		}
	}
	
	public List<HashMap<String, Object>> selectSendRpiList(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectRaspberryList(requestMap);
	}
	
	public List<HashMap<String, Object>> dongsungApi(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.selectEventForApi(requestMap);
	}
	
	public HashMap<String, Object> selectLogList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectLogList(requestMap));
		requestMap.put("total", adminMapper.selectLogTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectPhotoDetail(HashMap<String, Object> requestMap) throws Exception {
		
		HashMap<String, Object> eventMap = new HashMap<String, Object>(); 

		eventMap.put("music", adminMapper.selectEvtForMusic(requestMap));
		eventMap.put("list", adminMapper.selectPhotoDetail(requestMap));
		return eventMap;
	}
	
	
	public Integer insertEventObituary(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> tmp = adminMapper.selectFuneralName(requestMap);
		
		String body = "�븞�뀞�븯�꽭�슂. "+requestMap.get("name").toString()+" �긽二쇰떂\r"+
				tmp.get("FUNERAL_NAME").toString()+"�엯�땲�떎.\r\r"+
				
				"吏��씤遺꾨뱾�뿉寃� 蹂대궪 �닔 �엳�뒗\r"+
				"紐⑤컮�씪 遺�怨좎옣(遺�怨�)�쓣 蹂대궡�뱶由쎈땲�떎.\r\r"+
				
				"遺�怨좊궡�슜 �솗�씤 �썑 移댁뭅�삤�넚 �삉�뒗\r"+
				"臾몄옄濡� 諛붾줈 �쟾�넚媛��뒫�빀�땲�떎.\r\r"+
				
				"遺�怨좎옣 �솗�씤 :\r"+
				"https://choomo.app/999901?eventNo="+requestMap.get("eventNo").toString()+"\r\r"+
				
				"[紐⑤컮�씪 遺�怨좎옣 蹂대궡�뒗諛⑸쾿]\r"+
				"'遺�怨좎옣 �솗�씤' �겢由� �썑\r"+
				"�쟾�넚諛⑸쾿 �꽑�깮 �썑 �쟾�넚\r\r"+
				
				"臾몄쓽�쟾�솕 : 1668-3120\r\r"+
				
				"遺�怨좎옣 �닔�젙�씠 �븘�슂�븯�떊 寃쎌슦\r"+
				tmp.get("FUNERAL_NAME").toString()+" �궗臾댁떎濡�\r"+
				"�닔�젙 �슂泥��븯�뿬 二쇱떆湲� 諛붾엻�땲�떎.\r\r"+
				
				"�궪媛� 怨좎씤�쓽 紐낅났�쓣 鍮뺣땲�떎.";
		
		requestMap.put("funeralName", tmp.get("FUNERAL_NAME").toString());
		requestMap.put("body", body);
		return choomoMapper.insertEventObituary(requestMap);
//		return adminMapper.insertEventObituary(requestMap);
	}
	
	public HashMap<String, Object> selectEventObituaryList(HashMap<String, Object> requestMap) throws Exception {
//		requestMap.put("list", adminMapper.selectEventObituaryList(requestMap));
		requestMap.put("list", choomoMapper.selectEventObituaryList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectScreen10List(HashMap<String, Object> requestMap) throws Exception {
		List<HashMap<String, Object>> list= adminMapper.selectEventList(requestMap);
		requestMap.put("event", list);
		//�씪利덈쿋由� 議고쉶�떆 ENTRANCE_ROOM_DT �젣嫄�
		requestMap.put("order", requestMap.get("order").toString().replace(", ENTRANCE_ROOM_DT DESC", ""));
		requestMap.put("list", 		adminMapper.selectRaspberryConnectionList(requestMap));
		requestMap.put("total", 	adminMapper.selectRaspberryConnectionTotalCount(requestMap));
		
		if(list.size() > 0) {
			ArrayList<String> eventNos = new ArrayList<>();
			for(HashMap<String, Object> map : list) {
				eventNos.add(map.get("EVENT_NO").toString());
			}
			requestMap.put("eventNos", String.join(", ", eventNos));
//			requestMap.put("obituary", adminMapper.selectEventObituaryAlive(requestMap));
//			requestMap.put("obituary", choomoMapper.selectEventObituaryAlive(requestMap));
			
		}
		requestMap.put("family", adminMapper.selectEventFamily(requestMap));
		return requestMap;
		
	}
	
	public HashMap<String, Object> selectScreen30List(HashMap<String, Object> requestMap) throws Exception {
		List<HashMap<String, Object>> event = adminMapper.selectEventScreen30List(requestMap);
		requestMap.put("event", event);

		//�씪利덈쿋由� 議고쉶�떆 ENTRANCE_ROOM_DT �젣嫄�
		requestMap.put("order", requestMap.get("order").toString().replace(", ENTRANCE_ROOM_DT ASC", ""));
		
		ArrayList<String> numbers = new ArrayList<>();
		for(HashMap<String, Object> map:event) {
			numbers.add(map.get("EVENT_NO").toString());
		}
		requestMap.put("eventNos", String.join(", ", numbers));
		requestMap.put("waitInfo", 			adminMapper.selectRaspberryWait(requestMap));
		requestMap.put("funeral", 			adminSecMapper.selectFuneralInfo(requestMap));
		requestMap.put("divideImg", 		adminSecMapper.selectFuneralDivideImg(requestMap));
		requestMap.put("family", 			adminMapper.selectEventFamily(requestMap));
		requestMap.put("list", 				adminMapper.selectRaspberryConnectionList(requestMap));
		requestMap.put("total", 			adminMapper.selectRaspberryConnectionTotalCount(requestMap));
		return requestMap;
	}
	
	//�쓬�썝�젙蹂� 愿��젴
	
	public HashMap<String, Object> selectFuneralMusic(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectFuneralMusic(requestMap));
		return requestMap;
	}	
	
	public Integer insertFuneralMusic(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.insertFuneralMusic(requestMap);
	}
	
	public Integer updateFuneralMusic(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateFuneralMusic(requestMap);
	}
	
	public Integer deleteFuneralMusic(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.deleteFuneralMusic(requestMap);
	}
	public HashMap<String, Object> selectRaspForMusic(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectRaspForMusic(requestMap));
		return requestMap;
	}	
	
	public Integer updateRaspForMusic(HashMap<String, Object> requestMap) throws Exception {
		return adminMapper.updateRaspForMusic(requestMap);
	}
	
	public HashMap<String, Object> selectEvtForMusic(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectEvtForMusic(requestMap));
		return requestMap;
	}	
	
	public HashMap<String, Object> selectJonghapPreview(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> eventMap = new HashMap<String, Object>(); 
		eventMap.put("evt", adminMapper.selectJonghapBinsoForPreview(requestMap));
		eventMap.put("attr", adminMapper.selectJonghapAttrForPreview(requestMap));
		eventMap.put("style", adminMapper.selectJonghapStyleForPreview(requestMap));
		eventMap.put("funeral", adminMapper.selectJonghapFuneralForPreview(requestMap));
		eventMap.put("divideImg", adminSecMapper.selectFuneralDivideImg(requestMap));
		return eventMap;
	}
	public HashMap<String, Object> selectPreviewWhoIAm(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> rsMap = new HashMap<String, Object>(); 
		rsMap.put("list", adminMapper.selectPreviewWhoIAm(requestMap));
		return rsMap;
	}
	
	public HashMap<String, Object> selectPreviewFindBinsoEvent(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> rsMap = new HashMap<String, Object>(); 
		rsMap.put("list", adminMapper.selectPreviewFindBinsoEvent(requestMap));
		return rsMap;
	}

	public HashMap<String, Object> selectPreviewSYIPEvent(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> rsMap = new HashMap<String, Object>(); 
		rsMap.put("list", adminMapper.selectPreviewSYIPEvent(requestMap));
		return rsMap;
	}

	public HashMap<String, Object> selectPreviewSYIPStyle(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectPreviewSYIPStyle(requestMap));
		return requestMap;
	}
	
	
	public HashMap<String, Object> selectPreviewFindMultiMode(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> rsMulti = new HashMap<String, Object>(); 
		rsMulti.put("list", adminMapper.selectPreviewFindMultiMode(requestMap));
		return rsMulti;
	}
	
	public HashMap<String, Object> selectJonghapBinsoForPreview(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> eventMap = new HashMap<String, Object>(); 
		eventMap.put("evt", adminMapper.selectJonghapBinsoForPreview(requestMap));
		return eventMap;
	}
	
	
	/*
	 * public HashMap<String, Object> selectEventForFuneralPreview(HashMap<String,
	 * Object> requestMap) throws Exception { HashMap<String, Object> eventMap = new
	 * HashMap<String, Object>(); eventMap.put("evt",
	 * adminMapper.selectEventForFuneralPreview(requestMap)); return eventMap; }
	 */
	
	// modify by LSH - 23.03.20 
		public HashMap<String, Object> selectEventForFuneralPreview(HashMap<String, Object> requestMap) throws Exception {
			HashMap<String, Object> eventMap = new HashMap<String, Object>();
			
			String funeralNo = requestMap.get("funeralNo").toString();
			System.out.println("funeralNo before : "+funeralNo);
			if(funeralNo != null && !"".equals(funeralNo)) { 
				funeralNo = new String(Base64.decodeBase64(funeralNo.getBytes()));
				requestMap.put("funeralNo", funeralNo);
			}
			System.out.println("funeralNo after : "+funeralNo);
			eventMap.put("evt", adminMapper.selectEventForFuneralPreview(requestMap));
			return eventMap;
		}
	
	

	public HashMap<String, Object> selectSpecialPreview(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectSpecialPreview(requestMap));
		return requestMap;
	}

	public HashMap<String, Object> selectWaitPreview(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectWaitPreview(requestMap));
		return requestMap;
	}

	public HashMap<String, Object> selectYJPreview(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectYJPreview(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectIpGwanPreview(HashMap<String, Object> requestMap) throws Exception {
		List<HashMap<String, Object>> event = adminMapper.selectIpGwanPreview(requestMap);
		if(event.size() > 0) {
			requestMap.put("list", event);
			requestMap.put("eventNo", event.get(0).get("EVENT_NO"));
			requestMap.put("eventFamilyInfo", adminMapper.selectEventFamily(requestMap));
		}
		return requestMap;
	}

	public HashMap<String, Object> selectSanggaList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectSanggaList(requestMap));
		requestMap.put("funeralInfo", adminMapper.selectFuneralName(requestMap));
		return requestMap;
	}


	public HashMap<String, Object> selectWaitVideo(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectWaitVideo(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectSpecialVideo(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectSpecialVideo(requestMap));
		return requestMap;
	}


	public HashMap<String, Object> selectPreviewMusic(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectPreviewMusic(requestMap));
		return requestMap;
	}
	public HashMap<String, Object> selectPreviewUpdateMusic(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectPreviewUpdateMusic(requestMap));
		return requestMap;
	}
	

	/**
	 * �뻾�궗 �닔�젙�떆 �뻾�궗�뿉 �빐�떦�븯�뒗 �씪利덈쿋由щぉ濡� �쟾遺� 媛��졇�삤湲�
	 * @param HashMap<String, Object> requestMap
	 * @return HashMap<String, Object>
	 * @exception Exception
	 **/
	public HashMap<String, Object> selectRaspEvent(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectRaspEvent(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectYjRaspList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectYjRaspList(requestMap));
		return requestMap;
	}

	public HashMap<String, Object> selectRaspMultiPythonInfoExcept(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectRaspMultiPythonInfoExcept(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectRaspMultiPythonInfo(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectRaspMultiPythonInfo(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectRaspPythonInfo(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectRaspPythonInfo(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectReligionRaspList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectReligionRaspList(requestMap));
		return requestMap;
	}

	//염습대장	
		public HashMap<String, Object> selectShroudNote(HashMap<String, Object> requestMap) throws Exception {
			requestMap.put("list", adminMapper.selectShroudNote(requestMap));		
			return requestMap;
		}	
		
	//정산 제품사용량 조회	
	public HashMap<String, Object> selectProductUsage(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectProductUsage(requestMap));		
		return requestMap;
	}		
	
	//정산 정산표 조회	
	public HashMap<String, Object> selectSettlementTable(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectSettlementTable(requestMap));		
		return requestMap;
	}	
	
	//정산 합계 조회	
	public HashMap<String, Object> selectSumSettlementTable(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectSumSettlementTable(requestMap));		
		return requestMap;
	}			
	
	//정산 영수증 조회	
	public HashMap<String, Object> selectCalculateRecipe(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminMapper.selectCalculateRecipe(requestMap));		
		return requestMap;
	}			
}