package com.pbfw.admin_sec.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.pbfw.admin.service.AdminService;
import com.pbfw.admin_sec.service.AdminSecService;
import com.pbfw.common.schedule.SocketServer;
import com.pbfw.common.service.CommonService;
import com.pbfw.common.util.CommonUtil;


@Controller
public class AdminSecController {
	Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="adminSecService")
	AdminSecService adminSecService;
	
	@Resource(name="commonService")
	CommonService commonService;
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
	@Resource(name="adminService")
	AdminService adminService;

	@Resource(name = "SocketServer")
	SocketServer socketServer;
	
	/**
	* 오로지 장례식장 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralList(requestMap);
	}
	
	
	/**
	* 재고관리 재고현황 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStockTotalStatusList.do")
	public @ResponseBody HashMap<String, Object> selectStockTotalStatusList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStockTotalStatusList(requestMap);
	}
	
	/**
	* 재고관리 장례식장, 영업담당자 가져오기
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStockCompanyList.do")
	public @ResponseBody HashMap<String, Object> selectStockCompanyList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStockCompanyList(requestMap);
	}
	
	/**
	* 재고관리 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStockList.do")
	public @ResponseBody HashMap<String, Object> selectStockList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStockList(requestMap);
	}
	
	/**
	* 재고관리 STATUS 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStockStatusList.do")
	public @ResponseBody HashMap<String, Object> selectStockStatusList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStockStatusList(requestMap);
	}
	
	/**
	* 재고관리 저장
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertStock.do")
	public @ResponseBody Integer insertStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0104", request, requestMap);
		return adminSecService.insertStock(requestMap);
	}
	
	/**
	* 재고관리 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateStock.do")
	public @ResponseBody Integer updateStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0104", request, requestMap);
		return adminSecService.updateStock(requestMap);
	}
	
	/**
	* 재고관리 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteStock.do")
	public @ResponseBody Integer deleteStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0104", request, requestMap);
		return adminSecService.deleteStock(requestMap);
	}
	
	
	
	/**
	* 직원재고 재고현황 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectUserStockTotalStatusList.do")
	public @ResponseBody HashMap<String, Object> selectUserStockTotalStatusList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectUserStockTotalStatusList(requestMap);
	}
	
	/**
	* 직원재고 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectUserStockList.do")
	public @ResponseBody HashMap<String, Object> selectUserStockList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectUserStockList(requestMap);
	}
	
	/**
	* 직원재고 STATUS 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectUserStockStatusList.do")
	public @ResponseBody HashMap<String, Object> selectUserStockStatusList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectUserStockStatusList(requestMap);
	}
	
	/**
	* 재고관리 저장
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertUserStock.do")
	public @ResponseBody Integer insertUserStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0129", request, requestMap);
		return adminSecService.insertUserStock(requestMap);
	}
	
	/**
	* 재고관리 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateUserStock.do")
	public @ResponseBody Integer updateUserStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0129", request, requestMap);
		return adminSecService.updateUserStock(requestMap);
	}
	
	/**
	* 재고관리 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteUserStock.do")
	public @ResponseBody Integer deleteUserStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0129", request, requestMap);
		return adminSecService.deleteUserStock(requestMap);
	}
	
	
	
	
	
	
	
	/**
	* 물품관리 품목 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStockItemList.do")
	public @ResponseBody HashMap<String, Object> selectStockItemList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStockItemList(requestMap);
	}
	
	/**
	* 물품관리 품목 저장
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertStockItem.do")
	public @ResponseBody Integer insertStockItem(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0106", request, requestMap);
		return adminSecService.insertStockItem(requestMap);
	}
	
	/**
	* 물품관리 품목 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateStockItem.do")
	public @ResponseBody Integer updateStockItem(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0106", request, requestMap);
		return adminSecService.updateStockItem(requestMap);
	}
	
	/**
	* 물품관리 품목 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteStockItem.do")
	public @ResponseBody Integer deleteStockItem(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0106", request, requestMap);
		return adminSecService.deleteStockItem(requestMap);
	}
	
	/**
	* 물품관리 품목 중복체크
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/dupStockItemCode.do")
	public @ResponseBody Integer dupStockItemCode(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.dupStockItemCode(requestMap);
	}
	
	
	
	
	
	/**
	* 물품관리 분류 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStockClassificationList.do")
	public @ResponseBody HashMap<String, Object> selectStockClassificationList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStockClassificationList(requestMap);
	}
	
	/**
	* 물품관리 분류 저장
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertStockClassification.do")
	public @ResponseBody Integer insertStockClassification(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0105", request, requestMap);
		return adminSecService.insertStockClassification(requestMap);
	}
	
	/**
	* 물품관리 분류 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateStockClassification.do")
	public @ResponseBody Integer updateStockClassification(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0105", request, requestMap);
		return adminSecService.updateStockClassification(requestMap);
	}
	
	/**
	* 물품관리 분류 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteStockClassification.do")
	public @ResponseBody Integer deleteStockClassification(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0105", request, requestMap);
		return adminSecService.deleteStockClassification(requestMap);
	}
	
	
	
	/**
	* 문의사항 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectQuestionList.do")
	public @ResponseBody HashMap<String, Object> selectQuestionList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectQuestionList(requestMap);
	}
	
	/**
	* 문의사항 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateQuestion.do")
	public @ResponseBody Integer updateQuestion(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0109", request, requestMap);
		return adminSecService.updateQuestion(requestMap);
	}
	
	
	/**
	* 장례식장 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralHallList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralHallList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralHallList(requestMap);
	}
	
	
	/**
	* 장례식장DB관리 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectAllFuneralHallList.do")
	public @ResponseBody HashMap<String, Object> selectAllFuneralHallList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectAllFuneralHallList(requestMap);
	}
	
	/**
	* 장례식장DB관리 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralDivideImg.do")
	public @ResponseBody HashMap<String, Object> selectFuneralDivideImg(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralDivideImg(requestMap);
	}
	
	/**
	* 장례식장DB관리 담당자,영정업체 담당자 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralManagerList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralManagerList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralManagerList(requestMap);
	}
	
	/**
	* 장례식장DB관리 저장
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertAllFuneralHall.do")
	public @ResponseBody Integer insertAllFuneralHall(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0111", request, requestMap);
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);

		List<HashMap<String, Object>> divideList = new ArrayList<>();
		if(fileList.size() > 0) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			for(HashMap<String,Object> map : ftpFileList) {
				commonUtil.hashmapToString(map);
				
				if(map.get("fileKey").toString().contains("divide")) {
					HashMap<String, Object> tmp = new HashMap<String, Object>();
					tmp.put("divide", map.get("fileKey").toString());
					tmp.put("path", map.get("fileFullPath").toString());
					divideList.add(tmp);
				}else {
					requestMap.put(map.get("fileKey").toString(), map.get("fileFullPath").toString());
				}
			}
		}
		requestMap.put("divideList", divideList);
		return adminSecService.insertAllFuneralHall(requestMap);
	}
	
	
	/**
	* 장례식장DB관리 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateAllFuneralHall.do")
	public @ResponseBody Integer updateAllFuneralHall(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0111", request, requestMap);
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);
		
		List<HashMap<String, Object>> divideList = new ArrayList<>();
		String list = requestMap.get("divideList").toString();
		if(!list.equals("[]")) {
			divideList.addAll(commonUtil.jsonStringToList(list));
		}
		
		if(fileList.size() > 0) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			for(HashMap<String,Object> map : ftpFileList) {
				commonUtil.hashmapToString(map);
				
				if(map.get("fileKey").toString().contains("divide")) {
					HashMap<String, Object> tmp = new HashMap<String, Object>();
					tmp.put("divide", map.get("fileKey").toString());
					tmp.put("path", map.get("fileFullPath").toString());
					divideList.add(tmp);
				}else {
					requestMap.put(map.get("fileKey").toString(), map.get("fileFullPath").toString());
				}
			}
		}
		if(requestMap.get("calculateFlag").toString().equals("0")) {
			requestMap.put("menuNoList", requestMap.get("menuNoList").toString());
		}

		requestMap.put("flag", "3");
		HashMap<String, Object> tmpMap = adminSecService.selectFuneralRaspList(requestMap);
		if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
		
		//장례식장 수정시 푸시 다보내기
		requestMap.put("fcmClassification", "10, 20, 30, 40, 60");
		List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
		commonUtil.sendCloudMessages(rpiList, "7", "", null);
		
		requestMap.put("divideList", divideList);
		return adminSecService.updateAllFuneralHall(requestMap);
	}
	
	
	/**
	* 장례식장DB관리 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteAllFuneralHall.do")
	public @ResponseBody Integer deleteAllFuneralHall(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0111", request, requestMap);
		return adminSecService.deleteAllFuneralHall(requestMap);
	}
	
	
	/**
	* 장례식장DB관리 라즈베리 연결 리스트  출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectRaspberryConnectionList.do")
	public @ResponseBody HashMap<String, Object> selectRaspberryConnectionList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectRaspberryConnectionList(requestMap);
	}
	
	/**
	* 장례식장DB관리 라즈베리 연결 리스트  저장
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertRaspberryConnection.do")
	public @ResponseBody Integer insertRaspberryConnection(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
//		commonService.createLog("C", "L0112", request, requestMap);
		return adminSecService.insertRaspberryConnection(requestMap);
	}
	
	/**
	* 장례식장DB관리 라즈베리 연결 리스트  수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateRaspberryConnection.do")
	public @ResponseBody Integer updateRaspberryConnection(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0112", request, requestMap);
		return adminSecService.updateRaspberryConnection(requestMap);
	}
	
	/**
	* 장례식장DB관리 라즈베리 연결 리스트  삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteRaspberryConnection.do")
	public @ResponseBody Integer deleteRaspberryConnection(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0112", request, requestMap);
		return adminSecService.deleteRaspberryConnection(requestMap);
	}
	
	/**
	* 관리자 장례식장 통계
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStatisticsFuneralList.do")
	public @ResponseBody HashMap<String, Object> selectStatisticsFuneralList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStatisticsFuneralList(requestMap);
	}
	
	/**
	* 관리자 지역 통계
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStatisticsAreaList.do")
	public @ResponseBody HashMap<String, Object> selectStatisticsAreaList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStatisticsAreaList(requestMap);
	}
	
	/**
	* 관리자 담장자 통계
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStatisticsUserList.do")
	public @ResponseBody HashMap<String, Object> selectStatisticsUserList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStatisticsUserList(requestMap);
	}
	
	
	/********************************************/
	/**************** 장례식장 관리자 부분  ************/
	/********************************************/
	/**
	* 행사관리 상주명 가져오기
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectCMName.do")
	public @ResponseBody HashMap<String, Object> selectCMName(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectCMName(requestMap);
	}
	
	/**
	* 행사관리 주문 총수량 가져오기
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectOrderTotalList.do")
	public @ResponseBody HashMap<String, Object> selectOrderTotalList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectOrderTotalList(requestMap);
	}
	
	
	/**
	* 행사관리 임의상품 등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertEventRandomItem.do")
	public @ResponseBody HashMap<String, Object> insertEventRandomItem(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0125-1", request, requestMap);
		adminSecService.insertEventRandomItem(requestMap);
		return requestMap;
	}
	
	/**
	* 행사관리 주문하기
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertEventOrder.do")
	public @ResponseBody Integer insertEventOrder(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0125", request, requestMap);
		return adminSecService.insertEventOrder(requestMap);
//		if(adminSecService.insertEventOrder(requestMap) == 1) {
//			requestMap.put("fcmClassification", "60");
//			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
//			commonUtil.sendCloudMessages(rpiList, "1", "", null);
//			return 1;
//		} else return 0;
	}
	
	/**
	* 행사관리 반품하기
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertEventTakeBack.do")
	public @ResponseBody Integer insertEventReturn(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0126", request, requestMap);
		return adminSecService.insertEventTakeBack(requestMap);
//		if(adminSecService.insertEventTakeBack(requestMap) == 1) {
//			requestMap.put("fcmClassification", "60");
//			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
//			commonUtil.sendCloudMessages(rpiList, "1", "", null);
//			return 1;
//		} else return 0;
	}
	

	/**
	* 행사관리 주문 재출력
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/selectEventOrderRePrintList.do")
	public @ResponseBody HashMap<String, Object> selectEventOrderRePrintList(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		return adminSecService.selectEventOrderRePrintList(requestMap);
	}
	
	/**
	* 행사관리 주문내역 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectEventOrderList.do")
	public @ResponseBody HashMap<String, Object> selectEventOrderList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectEventOrderList(requestMap);
	}
	
	/**
	* 행사관리 정산 주문정보, 결제이력 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectEventCalculateList.do")
	public @ResponseBody HashMap<String, Object> selectEventCalculateList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectEventCalculateList(requestMap);
	}
	
	/**
	* 행사관리 결제하기
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertCalCulate.do")
	public @ResponseBody String insertCalCulate(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0127", request, requestMap);
		if(requestMap.get("payFlag").toString().equals("1")) {
			//단말기 전문을 구분하기 위한 separator 설정
			byte[] separator = new byte[1];
			separator[0] = (byte) 0x1C;
					
			String SEP = new String(separator);
	
			//StringTokenizer 를 이용하여 결과 전문데이터를 파싱
			StringTokenizer st = new StringTokenizer(requestMap.get("result").toString(), SEP);
			String[] parseData = requestMap.get("result").toString().split(SEP);

			// D1 : 승인
			String serviceCode = parseData[0];	
			requestMap.put("serviceCode", serviceCode);
			
			// A : 정상승인 / B : 승인거절
			String rejectCode = parseData[1];
			requestMap.put("rejectCode", rejectCode);
	
			String msg1 = "";
			String msg2 = "";
			if("A".equals(rejectCode)) {
				//YYMMDDhhmmss 승인일시
				String appDate = parseData[4];	
				requestMap.put("appDate", appDate);
	
				String amount = "";
				String vat = "";
				String appNo = "";
				String issuerName = "";
				String captureName = "";
				String mno = "";
				String cardNo = "";
				String quota = "";
				String catId = "";
				//승인금액
				amount = parseData[5];		
				requestMap.put("amount", amount);
				
				//부가세
				vat = parseData[6];		
				requestMap.put("vat", vat);
				
				//승인번호
				appNo = parseData[7];		
				requestMap.put("appNo", appNo);
				
				st.nextElement();	//발급사코드
				st.nextElement();	//매입사코드
				
				//발급사명
				issuerName = parseData[10];		
				requestMap.put("issuerName", issuerName);
				
				//매입사명
				captureName = parseData[11];	
				requestMap.put("captureName", captureName);
				
				//가맹점번호
				mno	= parseData[12];			
				requestMap.put("mno", mno);
				
				//카드번호
				cardNo = parseData[13];			
				requestMap.put("cardNo", cardNo);
				
				//할부
				quota = parseData[14];			
				requestMap.put("quota", quota);
				
				st.nextElement();	//처리일련번호
				
				//단말기 CAT-ID
				catId = parseData[16];			
				requestMap.put("catId", catId);
				
				return adminSecService.insertCalCulate(requestMap);
			}else {
				msg1 = parseData[2];
				msg2 = parseData[3];		
				return URLEncoder.encode(msg1 + "(" + msg2 + ")","UTF-8");
			}
		}else {
			// 현금결제
			return adminSecService.insertCalCulate(requestMap);
		}
	}
	
	
	/**
	* 행사관리 현금영수증 발행
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertReceipt.do")
	public @ResponseBody String insertReceipt(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0128", request, requestMap);
		
		//단말기 전문을 구분하기 위한 separator 설정
		byte[] separator = new byte[1];
		separator[0] = (byte) 0x1C;
				
		String SEP = new String(separator);

		//StringTokenizer 를 이용하여 결과 전문데이터를 파싱
		StringTokenizer st = new StringTokenizer(requestMap.get("result").toString(), SEP);

		// D1 : 승인
		String serviceCode = st.nextToken();	
		requestMap.put("serviceCode", serviceCode);
		
		// A : 정상승인 / B : 승인거절
		String rejectCode = st.nextToken();
		requestMap.put("rejectCode", rejectCode);

		String msg1 = "";
		String msg2 = "";
		if("A".equals(rejectCode)) {
			//YYMMDDhhmmss 승인일시
			String appDate = st.nextToken();	
			requestMap.put("appDate", appDate);

			String amount = "";
			String vat = "";
			String appNo = "";
			String issuerName = "";
			String type = "";
			String issuerNo = "";
			String serialNo = "";
			String catId = "";
			String msg = "";
			
			//승인금액
			amount = st.nextToken();		
			requestMap.put("amount", amount);
			
			//부가세
			vat = st.nextToken();		
			requestMap.put("vat", vat);
			
			//승인번호
			appNo = st.nextToken();		
			requestMap.put("appNo", appNo);
			
			//발급사코드
			issuerName = st.nextToken();	
			requestMap.put("issuerName", issuerName);
			
			//매입사코드
			type = st.nextToken();
			requestMap.put("type", type);
			
			//현금영수증 핸드폰,주민번호
			issuerNo = st.nextToken();		
			requestMap.put("issuerNo", issuerNo);
			
			//일련번호
			serialNo = st.nextToken();	
			requestMap.put("serialNo", serialNo);
			
			//단말기 CAT-ID
			catId = st.nextToken();			
			requestMap.put("catId", catId);
			
			//현금영수증 메세지
			msg = st.nextToken();			
			requestMap.put("msg", msg);

			return adminSecService.insertReceipt(requestMap);
		}else {
			msg1 = st.nextToken();
			msg2 = st.nextToken();		
			return URLEncoder.encode(msg1 + "(" + msg2 + ")","UTF-8");
		}
	}
	
	
	/**
	* 행사관리 결제취소하기
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateCalCulate.do")
	public @ResponseBody String insertCancelCalCulate(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0127", request, requestMap);
		if(requestMap.get("payFlag").toString().equals("1")) {
			//단말기 전문을 구분하기 위한 separator 설정
			byte[] separator = new byte[1];
			separator[0] = (byte) 0x1C;
					
			String SEP = new String(separator);
	
			//StringTokenizer 를 이용하여 결과 전문데이터를 파싱
			StringTokenizer st = new StringTokenizer(requestMap.get("result").toString(), SEP);
	
			// D1 : 승인
			String serviceCode = st.nextToken();	
			requestMap.put("serviceCode", serviceCode);
			
			// A : 정상승인 / B : 승인거절
			String rejectCode = st.nextToken();
			requestMap.put("rejectCode", rejectCode);
	
			String msg1 = "";
			String msg2 = "";
			if("A".equals(rejectCode)) {

				//YYMMDDhhmmss 승인일시
				String appDate = st.nextToken();	
				System.out.println("appDate:" + appDate);
				requestMap.put("appDate", appDate);
	
				String amount = "";
				String vat = "";
				String appNo = "";
				String issuerName = "";
				String captureName = "";
				String mno = "";
				String cardNo = "";
				String quota = "";
				String catId = "";
				//승인금액
				amount = st.nextToken();		
				requestMap.put("amount", amount);
				
				//부가세
				vat = st.nextToken();		
				requestMap.put("vat", vat);
				
				//승인번호
				appNo = st.nextToken();		
				requestMap.put("appNo", appNo);
				
				st.nextElement();	//발급사코드
				st.nextElement();	//매입사코드
				
				//발급사명
				issuerName = st.nextToken();		
				requestMap.put("issuerName", issuerName);
				
				//매입사명
				captureName = st.nextToken();	
				requestMap.put("captureName", captureName);
				
				//가맹점번호
				mno	= st.nextToken();			
				requestMap.put("mno", mno);
				
				//카드번호
				cardNo = st.nextToken();			
				requestMap.put("cardNo", cardNo);
				
				//할부
				quota = st.nextToken();			
				requestMap.put("quota", quota);
				
				st.nextElement();	//처리일련번호
				
				//단말기 CAT-ID
				catId = st.nextToken();			
				requestMap.put("catId", catId);
				
				return adminSecService.updateCalCulate(requestMap);
			}else {
				msg1 = st.nextToken();
				msg2 = st.nextToken();		
				return URLEncoder.encode(msg1 + "(" + msg2 + ")","UTF-8");
			}
		}else {
			return adminSecService.updateCalCulate(requestMap);
		}
	}
	
	/**
	* 행사관리 현금영수증 발행 취소
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateReceipt.do")
	public @ResponseBody String updateReceipt(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0128", request, requestMap);
		
		//단말기 전문을 구분하기 위한 separator 설정
		byte[] separator = new byte[1];
		separator[0] = (byte) 0x1C;
				
		String SEP = new String(separator);

		//StringTokenizer 를 이용하여 결과 전문데이터를 파싱
		StringTokenizer st = new StringTokenizer(requestMap.get("result").toString(), SEP);

		// D1 : 승인
		String serviceCode = st.nextToken();	
		requestMap.put("serviceCode", serviceCode);
		
		// A : 정상승인 / B : 승인거절
		String rejectCode = st.nextToken();
		requestMap.put("rejectCode", rejectCode);

		String msg1 = "";
		String msg2 = "";
		if("A".equals(rejectCode)) {
			//YYMMDDhhmmss 승인일시
			String appDate = st.nextToken();	
			requestMap.put("appDate", appDate);

			String amount = "";
			String vat = "";
			String appNo = "";
			String issuerName = "";
			String type = "";
			String issuerNo = "";
			String serialNo = "";
			String catId = "";
			String msg = "";
			
			//승인금액
			amount = st.nextToken();		
			requestMap.put("amount", amount);
			
			//부가세
			vat = st.nextToken();		
			requestMap.put("vat", vat);
			
			//승인번호
			appNo = st.nextToken();		
			requestMap.put("appNo", appNo);
			
			//발급사코드
			issuerName = st.nextToken();	
			requestMap.put("issuerName", issuerName);
			
			//매입사코드
			type = st.nextToken();
			requestMap.put("type", type);
			
			//현금영수증 핸드폰,주민번호
			issuerNo = st.nextToken();		
			requestMap.put("issuerNo", issuerNo);
			
			//일련번호
			serialNo = st.nextToken();	
			requestMap.put("serialNo", serialNo);
			
			//단말기 CAT-ID
			catId = st.nextToken();			
			requestMap.put("catId", catId);
			
			//현금영수증 메세지
			msg = st.nextToken();			
			requestMap.put("msg", msg);

			return adminSecService.updateReceipt(requestMap);
		}else {
			msg1 = st.nextToken();
			msg2 = st.nextToken();		
			return URLEncoder.encode(msg1 + "(" + msg2 + ")","UTF-8");
		}
	}
	
	
	/**
	* 프린트 출력시 장례식장 정보 가져오기
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectEventFuneralInfoList.do")
	public @ResponseBody HashMap<String, Object> selectEventFuneralInfoList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectEventFuneralInfoList(requestMap);
	}
	
	/**
	* 행사관리 장례확인서 프린트 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectEventConfirmPrintList.do")
	public @ResponseBody HashMap<String, Object> selectEventConfirmPrintList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectEventConfirmPrintList(requestMap);
	}
	
	/**
	* 행사관리 주문내역 장례비용내역 프린트 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectEventOrderPrintList.do")
	public @ResponseBody HashMap<String, Object> selectEventOrderPrintList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectEventOrderPrintList(requestMap);
	}
	
	/**
	* 행사관리 주문내역 장례비용내역 프린트 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectEventBoardPrintList.do")
	public @ResponseBody HashMap<String, Object> selectEventBoardPrintList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectEventBoardPrintList(requestMap);
	}
	
	
	/**
	* 빈소관리 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectBinsoList.do")
	public @ResponseBody HashMap<String, Object> selectBinsoList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectBinsoList(requestMap);
	}
	
	/**
	* 빈소관리 수정
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/updateBinso.do")
	public @ResponseBody Integer updateBinso(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0116", request, requestMap);
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);

		List<HashMap<String, Object>> imgList = new ArrayList<>();
		String list = requestMap.get("imgList").toString();
		if(!list.equals("[]")) {
			imgList.addAll(commonUtil.jsonStringToList(list));
		}
		if(fileList.size() > 0) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			imgList.addAll(ftpFileList);
		}
		requestMap.put("imgList", imgList);
		return adminSecService.updateBinso(requestMap);
	}
	
	/**
	* 빈소관리 이미지 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectBinsoImgList.do")
	public @ResponseBody HashMap<String, Object> updateBinso(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectBinsoImgList(requestMap);
	}
	
	
	
	/**
	* 장례식장관리자 문의하기
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertQuestion.do")
	public @ResponseBody Integer insertQuestion(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0109", request, requestMap);
		return adminSecService.insertQuestion(requestMap);
	}
	
	
	/**
	* 장례식장관리자 기본정보관리 장례식장 정보  출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralInfo.do")
	public @ResponseBody HashMap<String, Object> selectFuneralInfo(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralInfo(requestMap);
	}
	
	/**
	* 장례식장관리자 기본정보관리 장례식장 정보  수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateFuneralInfo.do")
	public @ResponseBody Integer updateFuneralInfo(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0111", request, requestMap);
		List<HashMap<String, Object>> fileList = commonUtil.multiFileUploadUtility(mhsr);

		List<HashMap<String, Object>> divideList = new ArrayList<>();
		String list = requestMap.get("divideList").toString();
		if(!list.equals("[]")) {
			divideList.addAll(commonUtil.jsonStringToList(list));
		}
		
		if(fileList.size() > 0) {
			List<HashMap<String, Object>> ftpFileList = commonUtil.connectFtpFileServer(fileList);
			for(HashMap<String,Object> map : ftpFileList) {
				commonUtil.hashmapToString(map);
				
				if(map.get("fileKey").toString().contains("divide")) {
					HashMap<String, Object> tmp = new HashMap<String, Object>();
					tmp.put("divide", map.get("fileKey").toString());
					tmp.put("path", map.get("fileFullPath").toString());
					divideList.add(tmp);
				}else {
					requestMap.put(map.get("fileKey").toString(), map.get("fileFullPath").toString());
				}
			}
		}
		requestMap.put("divideList", divideList);
		
		if(!fileList.isEmpty()) {
			requestMap.put("flag", "3");
			HashMap<String, Object> tmpMap = adminSecService.selectJhRaspList(requestMap);
			if(!tmpMap.get("list").toString().equals("[]")) socketServer.send(tmpMap);
			
			requestMap.put("fcmClassification", "30");
			List<HashMap<String, Object>> rpiList = adminService.selectSendRpiList(requestMap);
			commonUtil.sendCloudMessages(rpiList, "1", "", null);
		}
		
		return adminSecService.updateFuneralInfo(requestMap);
	}
	
	
	/**
	* 업체관리
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectPartnerManagementList.do")
	public @ResponseBody HashMap<String, Object> selectPartnerManagementList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectPartnerManagementList(requestMap);
	}
	
	/**
	* 업체관리 업체 등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertPartnerManagement.do")
	public @ResponseBody Integer insertPartnerManagement(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0117", request, requestMap);
		return adminSecService.insertPartnerManagement(requestMap);
	}
	
	/**
	* 업체관리 업체 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updatePartnerManagement.do")
	public @ResponseBody Integer updatePartnerManagement(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0117", request, requestMap);
		return adminSecService.updatePartnerManagement(requestMap);
	}
	
	/**
	* 업체관리 업체 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deletePartnerManagement.do")
	public @ResponseBody Integer deletePartnerManagement(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0117", request, requestMap);
		return adminSecService.deletePartnerManagement(requestMap);
	}
	
	
	/**
	* 상품관리 -> 업체가져오기
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralItemPartner.do")
	public @ResponseBody HashMap<String, Object> selectFuneralItemPartner(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralItemPartner(requestMap);
	}
	
	/**
	* 상품관리 -> 분류 가져오기
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralClassificationList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralClassificationList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralClassificationList(requestMap);
	}
	
	/**
	* 상품관리 분류 등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertFuneralClassification.do")
	public @ResponseBody Integer insertFuneralClassification(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0118", request, requestMap);
		return adminSecService.insertFuneralClassification(requestMap);
	}
	
	/**
	* 상품관리 분류 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateFuneralClassification.do")
	public @ResponseBody Integer updateFuneralClassification(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0118", request, requestMap);
		return adminSecService.updateFuneralClassification(requestMap);
	}
	
	/**
	* 상품관리 분류 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteFuneralClassification.do")
	public @ResponseBody Integer deleteFuneralClassification(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0118", request, requestMap);
		return adminSecService.deleteFuneralClassification(requestMap);
	}
	
	/**
	* 상품관리 -> 품목 가져오기
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralItemList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralItemList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralItemList(requestMap);
	}
	
	/**
	* 물품관리 품목 중복체크
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/dupFuneralItemCode.do")
	public @ResponseBody Integer dupFuneralItemCode(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.dupFuneralItemCode(requestMap);
	}
	
	/**
	* 상품관리 품목 등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertFuneralItem.do")
	public @ResponseBody Integer insertFuneralItem(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0119", request, requestMap);
		return adminSecService.insertFuneralItem(requestMap);
	}
	
	/**
	* 상품관리 품목 일괄등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertFuneralItemBatch.do")
	public @ResponseBody Integer insertFuneralItemBatch(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0119", request, requestMap);
		return adminSecService.insertFuneralItemBatch(requestMap);
	}
	
	
	/**
	* 상품관리 품목 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateFuneralItem.do")
	public @ResponseBody Integer updateFuneralItem(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0119", request, requestMap);
		return adminSecService.updateFuneralItem(requestMap);
	}
	
	/**
	* 상품관리 품목 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteFuneralItem.do")
	public @ResponseBody Integer deleteFuneralItem(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0119", request, requestMap);
		return adminSecService.deleteFuneralItem(requestMap);
	}
	
	
	/**
	* 상품관리 -> 세트관리 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectSetList.do")
	public @ResponseBody HashMap<String, Object> selectSetList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectSetList(requestMap);
	}
	
	/**
	* 상품관리 세트관리 등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertSet.do")
	public @ResponseBody Integer insertSet(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0120", request, requestMap);
		return adminSecService.insertSet(requestMap);
	}
	
	/**
	* 상품관리 세트관리 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateSet.do")
	public @ResponseBody Integer updateSet(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0120", request, requestMap);
		return adminSecService.updateSet(requestMap);
	}
	
	/**
	* 상품관리 세트관리 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteSet.do")
	public @ResponseBody Integer deleteSet(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0120", request, requestMap);
		return adminSecService.deleteSet(requestMap);
	}
	
	
	/**
	* 상품관리 -> 세트관리 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectSetItemList.do")
	public @ResponseBody HashMap<String, Object> selectSetItemList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectSetItemList(requestMap);
	}
	/**
	
	
	
	/**
	* 상품관리 -> 할인관리 리스트
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectDiscountList.do")
	public @ResponseBody HashMap<String, Object> selectDiscountList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectDiscountList(requestMap);
	}
	
	/**
	* 상품관리 할인 등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertDiscount.do")
	public @ResponseBody Integer insertDiscount(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0121", request, requestMap);
		return adminSecService.insertDiscount(requestMap);
	}
	
	/**
	* 상품관리 할인 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateDiscount.do")
	public @ResponseBody Integer updateDiscount(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0121", request, requestMap);
		return adminSecService.updateDiscount(requestMap);
	}
	
	/**
	* 상품관리 할인 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteDiscount.do")
	public @ResponseBody Integer deleteDiscount(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0121", request, requestMap);
		return adminSecService.deleteDiscount(requestMap);
	}
	
	
	/**
	* 재고관리 -> 입출고 내역
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralStockList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralStockList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralStockList(requestMap);
	}
	
	/**
	* 재고관리 -> 재고현황표
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralStockTotalStatusList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralStockTotalStatusList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralStockTotalStatusList(requestMap);
	}
	
	/**
	* 재고관리 -> 재고물품가져오기
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralStockItemList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralStockItemList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralStockItemList(requestMap);
	}
	
	/**
	* 재고관리 STATUS 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectFuneralStockStatusList.do")
	public @ResponseBody HashMap<String, Object> selectFuneralStockStatusList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFuneralStockStatusList(requestMap);
	}
	
	/**
	* 재고관리 저장
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/insertFuneralStock.do")
	public @ResponseBody Integer insertFuneralStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("C", "L0122", request, requestMap);
		return adminSecService.insertFuneralStock(requestMap);
	}
	
	/**
	* 재고관리 수정
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/updateFuneralStock.do")
	public @ResponseBody Integer updateFuneralStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("U", "L0122", request, requestMap);
		return adminSecService.updateFuneralStock(requestMap);
	}
	
	/**
	* 재고관리 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/adminSec/deleteFuneralStock.do")
	public @ResponseBody Integer deleteFuneralStock(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonService.createLog("D", "L0122", request, requestMap);
		return adminSecService.deleteFuneralStock(requestMap);
	}
	
	
	/**
	* 장례식장 매출통계
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStatisticsCalList.do")
	public @ResponseBody HashMap<String, Object> selectStatisticsCalList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStatisticsCalList(requestMap);
	}
	
	/**
	* 장례식장 빈소통계
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/adminSec/selectStatisticsBinsoList.do")
	public @ResponseBody HashMap<String, Object> selectStatisticsBinsoList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectStatisticsBinsoList(requestMap);
	}
	
	
	/**
	 * 화환 생성일 Insert
	 */
	@RequestMapping(value="/adminSec/insertFlowerFuneralCreateDt.do")
	public @ResponseBody HashMap<String, Object> insertFlowerFuneralCreateDt(@RequestParam HashMap<String, Object> requestMap) throws Exception {		
		commonUtil.hashmapToString(requestMap);
		System.out.println("/adminSec/insertFlowerFuneralCreateDt.do");
		return adminSecService.insertFlowerFuneralCreateDt(requestMap);
	} 
	
	/**
	 * 화환 통계 생성일 기준
	 */
	@RequestMapping(value="/adminSec/selectFlowerFuneralCreateDt.do")
	public @ResponseBody HashMap<String, Object> selectFlowerFuneralCreateDt(@RequestParam HashMap<String, Object> requestMap) throws Exception {		
		commonUtil.hashmapToString(requestMap);
		return adminSecService.selectFlowerFuneralCreateDt(requestMap);
	}
	
}
