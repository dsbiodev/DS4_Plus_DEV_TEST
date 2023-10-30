package com.pbfw.admin_sec.service.impl;

import java.util.HashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pbfw.admin_sec.mapper.AdminSecMapper;
import com.pbfw.admin_sec.service.AdminSecService;
import com.pbfw.common.interceptor.LoggerInterceptor;
import com.pbfw.common.util.CommonUtil;

@Service("adminSecService")
public class AdminSecServiceImpl implements AdminSecService {
	protected Logger log = LoggerFactory.getLogger(LoggerInterceptor.class);
	
	@Autowired
	AdminSecMapper adminSecMapper;
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
	
	public HashMap<String, Object> selectFuneralList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStockTotalStatusList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectStockCompanyList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("funeralList", adminSecMapper.selectFuneralList(requestMap));
		requestMap.put("userList", adminSecMapper.selectStockUserList(requestMap));
		requestMap.put("itemList", adminSecMapper.selectStockItemList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectStockList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStockList(requestMap));
		requestMap.put("total", adminSecMapper.selectStockTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectStockStatusList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStockStatusList(requestMap));
		return requestMap;
	}
	
	public Integer insertStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertStock(requestMap);
		
		String list = requestMap.get("list").toString();
		if(!list.equals("[]")) {
			requestMap.put("list", commonUtil.jsonStringToList(list));
			adminSecMapper.insertStockStatus(requestMap);
		}
		return 1;
	}
	
	public Integer updateStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateStock(requestMap);
		
		String list = requestMap.get("list").toString();
		if(!list.equals("[]")) {
			requestMap.put("STOCK_NO", requestMap.get("stockNo"));
			requestMap.put("list", commonUtil.jsonStringToList(list));
			adminSecMapper.deleteStockStatus(requestMap);
			adminSecMapper.insertStockStatus(requestMap);
		}
		return 1;
	}
	
	public Integer deleteStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.deleteStockStatus(requestMap);
		return adminSecMapper.deleteStock(requestMap);
	}
	
	
	public HashMap<String, Object> selectUserStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectUserStockTotalStatusList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectUserStockList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectUserStockList(requestMap));
		requestMap.put("total", adminSecMapper.selectUserStockTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectUserStockStatusList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectUserStockStatusList(requestMap));
		return requestMap;
	}
	
	public Integer insertUserStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertUserStock(requestMap);
		
		String list = requestMap.get("list").toString();
		if(!list.equals("[]")) {
			requestMap.put("list", commonUtil.jsonStringToList(list));
			adminSecMapper.insertUserStockStatus(requestMap);
		}
		return 1;
	}
	
	public Integer updateUserStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateUserStock(requestMap);
		
		String list = requestMap.get("list").toString();
		if(!list.equals("[]")) {
			requestMap.put("STOCK_NO", requestMap.get("stockNo"));
			requestMap.put("list", commonUtil.jsonStringToList(list));
			adminSecMapper.deleteUserStockStatus(requestMap);
			adminSecMapper.insertUserStockStatus(requestMap);
		}
		return 1;
	}
	
	public Integer deleteUserStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.deleteUserStockStatus(requestMap);
		return adminSecMapper.deleteUserStock(requestMap);
	}
	
	
	
	public HashMap<String, Object> selectStockItemList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStockItemList(requestMap));
		requestMap.put("total", adminSecMapper.selectStockItemTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer insertStockItem(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertStockItem(requestMap);
	}
	
	public Integer updateStockItem(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updateStockItem(requestMap);
	}
	
	public Integer deleteStockItem(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deleteStockItem(requestMap);
	}
	
	public Integer dupStockItemCode(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.dupStockItemCode(requestMap);
	}
	
	
	public HashMap<String, Object> selectStockClassificationList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStockClassificationList(requestMap));
		requestMap.put("total", adminSecMapper.selectStockClassificationTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer insertStockClassification(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertStockClassification(requestMap);
	}
	
	public Integer updateStockClassification(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updateStockClassification(requestMap);
	}
	
	public Integer deleteStockClassification(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deleteStockClassification(requestMap);
	}
	
	
	
	public HashMap<String, Object> selectQuestionList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectQuestionList(requestMap));
		requestMap.put("total", adminSecMapper.selectQuestionTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer updateQuestion(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updateQuestion(requestMap);
	}
	
	
	public HashMap<String, Object> selectFuneralHallList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralHallList(requestMap));
		requestMap.put("total", adminSecMapper.selectFuneralHallTotalCount(requestMap));
		return requestMap;
	}
	
	
	public HashMap<String, Object> selectAllFuneralHallList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectAllFuneralHallList(requestMap));
		requestMap.put("total", adminSecMapper.selectAllFuneralHallTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectFuneralDivideImg(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("divideImg", adminSecMapper.selectFuneralDivideImg(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectFuneralManagerList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("managerList", adminSecMapper.selectFuneralManagerList(requestMap));
		requestMap.put("photoManagerList", adminSecMapper.selectFuneralPhotoManagerList(requestMap));
		return requestMap;
	}
	
	public Integer insertAllFuneralHall(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertAllFuneralHall(requestMap);
		requestMap.put("funeralNo", requestMap.get("FUNERAL_NO"));
		adminSecMapper.deleteFuneralDivdeImg(requestMap);
		if(requestMap.get("divideList") != null && !requestMap.get("divideList").toString().equals("[]")) 
			adminSecMapper.insertFuneralDivdeImg(requestMap);
		return 1;
	}
	
	public Integer updateAllFuneralHall(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateAllFuneralHall(requestMap);
		adminSecMapper.deleteFuneralDivdeImg(requestMap);
		if(requestMap.get("divideList") != null && !requestMap.get("divideList").toString().equals("[]")) 
			adminSecMapper.insertFuneralDivdeImg(requestMap);
		if(requestMap.get("menuNoList") != null)
			adminSecMapper.deleteUserMenu(requestMap);
		return 1;
	}
	
	public Integer deleteAllFuneralHall(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deleteAllFuneralHall(requestMap);
	}
	
	
	
	public HashMap<String, Object> selectRaspberryConnectionList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectRaspberryConnectionList(requestMap));
		return requestMap;
	}
	
	public Integer insertRaspberryConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertRaspberryConnection(requestMap);
	}
	
	public Integer updateRaspberryConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updateRaspberryConnection(requestMap);
	}
	
	public Integer deleteRaspberryConnection(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deleteRaspberryConnection(requestMap);
	}

	public HashMap<String, Object> selectStatisticsFuneralList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStatisticsFuneralList(requestMap));
		requestMap.put("total", adminSecMapper.selectStatisticsFuneralTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectStatisticsAreaList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStatisticsAreaList(requestMap));
		requestMap.put("total", adminSecMapper.selectStatisticsAreaTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectStatisticsUserList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStatisticsUserList(requestMap));
		requestMap.put("total", adminSecMapper.selectStatisticsUserTotalCount(requestMap));
		return requestMap;
	}
	
	
	
	/*******************************************************************************************/
	public HashMap<String, Object> selectCMName(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("cmName", adminSecMapper.selectCMName(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectOrderTotalList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectOrderTotalList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> insertEventRandomItem(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertEventRandomItem(requestMap);
		requestMap.put("randomItemNo", requestMap.get("RANDOM_ITEM_NO"));
		requestMap.put("list", adminSecMapper.selectRandomItemList(requestMap));
		return requestMap;
	}
	
	public Integer insertEventOrder(HashMap<String, Object> requestMap) throws Exception {
		String orderList = requestMap.get("orderList").toString();
		String stockList = requestMap.get("stockList").toString();
		
		if(!orderList.equals("[]")) {
			requestMap.put("orderList", commonUtil.jsonStringToList(orderList));
			adminSecMapper.insertEventOrder(requestMap);
			adminSecMapper.deleteEventOrderTmp(requestMap);
			adminSecMapper.insertEventOrderTmp(requestMap);
		}
		if(!stockList.equals("[]")) {
			requestMap.put("stockList", commonUtil.jsonStringToList(stockList));
			adminSecMapper.insertEventOrderStock(requestMap);
			adminSecMapper.insertEventOrderStockStatus(requestMap);
		}
		return 1;
	}
	
	public Integer insertEventTakeBack(HashMap<String, Object> requestMap) throws Exception {
		String stockList = requestMap.get("stockList").toString();
		String orderList = requestMap.get("orderList").toString();
		if(!orderList.equals("[]")) {
			requestMap.put("orderList", commonUtil.jsonStringToList(orderList));
			adminSecMapper.insertEventTakeBack(requestMap);
			adminSecMapper.deleteEventTakeBackTmp(requestMap);
			adminSecMapper.insertEventTakeBackTmp(requestMap);
		}
		if(!stockList.equals("[]")) {
			requestMap.put("stockList", commonUtil.jsonStringToList(stockList));
			adminSecMapper.insertEventTakeBackStock(requestMap);
			adminSecMapper.insertEventOrderStockStatus(requestMap);
		}
		return 1;
	}

	public HashMap<String, Object> selectEventOrderRePrintList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("partner", adminSecMapper.selectPartnerManagementList(requestMap));
		
		if(requestMap.get("flag").equals("order")) requestMap.put("list", adminSecMapper.selectEventOrderRePrintList(requestMap));
		else requestMap.put("list", adminSecMapper.selectEventTakeBackRePrintList(requestMap));
		
		// 프린트 출력시 장례식장 정보 가져오기
		requestMap.put("funeralInfoList", adminSecMapper.selectEventFuneralInfoList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectEventOrderList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectEventOrderList(requestMap));
		requestMap.put("total", adminSecMapper.selectEventOrderTotalCount(requestMap));
//		requestMap.put("totalList", adminSecMapper.selectTotalOrderList(requestMap));
//		requestMap.put("priceList", adminSecMapper.selectTotalPriceList(requestMap));
		return requestMap;
	}
	
	
	public HashMap<String, Object> selectEventCalculateList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("partnerCalculateList", adminSecMapper.selectPartnerCalculateList(requestMap));
		requestMap.put("calculateHistoryList", adminSecMapper.selectCalculateHistoryList(requestMap));
		requestMap.put("receiptHistoryList", adminSecMapper.selectReceiptHistoryList(requestMap));
		requestMap.put("calculateDiscountList", adminSecMapper.selectCalculateDiscountList(requestMap));
		return requestMap;
	}
	
	public String insertCalCulate(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertCalCulate(requestMap);
		return "1";
	}
	
	public String insertReceipt(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertReceipt(requestMap);
		return "1";
	}
	
	public String updateCalCulate(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateCalCulate(requestMap);
		return "1";
	}
	
	public String updateReceipt(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateReceipt(requestMap);
		return "1";
	}
	
	public HashMap<String, Object> selectEventFuneralInfoList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("funeralInfoList", adminSecMapper.selectEventFuneralInfoList(requestMap));
		requestMap.put("partner", adminSecMapper.selectPartnerManagementList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectEventOrderPrintList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("partnerCnt", adminSecMapper.selectEventOrderPartner(requestMap));
		requestMap.put("list", adminSecMapper.selectEventOrderPrintList(requestMap));
		requestMap.put("infoList", adminSecMapper.selectEventOrderInfoList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectEventBoardPrintList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectEventBoardPrintList(requestMap));
		requestMap.put("familyList", adminSecMapper.selectEventBoardFamilyPrintList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectEventConfirmPrintList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("info", adminSecMapper.selectEventInfoList(requestMap));
		requestMap.put("family", adminSecMapper.selectEventFamilyList(requestMap));
		requestMap.put("binso", adminSecMapper.selectEventBinsoList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectBinsoList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectBinsoList(requestMap));
		requestMap.put("total", adminSecMapper.selectBinsoTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer updateBinso(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.deleteBinsoImg(requestMap);
		if(!requestMap.get("imgList").toString().equals("[]")) {
			adminSecMapper.insertBinsoImg(requestMap);
		}
		return adminSecMapper.updateBinso(requestMap);
	}
	
	public HashMap<String, Object> selectBinsoImgList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectBinsoImgList(requestMap));
		return requestMap;
	}
	
	
	public Integer insertQuestion(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertQuestion(requestMap);
	}
	
	public HashMap<String, Object> selectFuneralInfo(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("infoList", adminSecMapper.selectFuneralInfo(requestMap));
		requestMap.put("divideImg", adminSecMapper.selectFuneralDivideImg(requestMap));
		return requestMap;
	}
	
	public Integer updateFuneralInfo(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateFuneralInfo(requestMap);
		adminSecMapper.deleteFuneralDivdeImg(requestMap);
		if(requestMap.get("divideList") != null && !requestMap.get("divideList").toString().equals("[]")) 
			adminSecMapper.insertFuneralDivdeImg(requestMap);
		return 1;
	}
	
	public HashMap<String, Object> selectPartnerManagementList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectPartnerManagementList(requestMap));
		requestMap.put("total", adminSecMapper.selectPartnerManagementTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer insertPartnerManagement(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertPartnerManagement(requestMap);
	}
	
	public Integer updatePartnerManagement(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updatePartnerManagement(requestMap);
	}
	
	public Integer deletePartnerManagement(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deletePartnerManagement(requestMap);
	}
	
	
	public HashMap<String, Object> selectFuneralItemPartner(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralItemPartner(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectFuneralClassificationList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralClassificationList(requestMap));
		return requestMap;
	}
	
	public Integer insertFuneralClassification(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertFuneralClassification(requestMap);
	}
	
	public Integer updateFuneralClassification(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updateFuneralClassification(requestMap);
	}
	
	public Integer deleteFuneralClassification(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deleteFuneralClassification(requestMap);
	}
	
	public HashMap<String, Object> selectFuneralItemList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralItemList(requestMap));
		requestMap.put("total", adminSecMapper.selectFuneralItemTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer dupFuneralItemCode(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.dupFuneralItemCode(requestMap);
	}
	
	public Integer insertFuneralItem(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertFuneralItem(requestMap);
	}
	
	public Integer insertFuneralItemBatch(HashMap<String, Object> requestMap) throws Exception {
		String list = requestMap.get("list").toString();
		requestMap.put("list", commonUtil.jsonStringToList(list));
		return adminSecMapper.insertFuneralItemBatch(requestMap);
	}
	
	public Integer updateFuneralItem(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updateFuneralItem(requestMap);
	}
	
	public Integer deleteFuneralItem(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deleteFuneralItem(requestMap);
	}
	
	
	
	public HashMap<String, Object> selectSetList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectSetList(requestMap));
		requestMap.put("total", adminSecMapper.selectSetTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer insertSet(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertSet(requestMap);
		String setItemList = requestMap.get("setItemList").toString();
		if(!setItemList.equals("[]")) {
			requestMap.put("setItemList", commonUtil.jsonStringToList(setItemList));
			adminSecMapper.insertSetItem(requestMap);
		}
		return 1;
	}
	
	public Integer updateSet(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateSet(requestMap);
		String setItemList = requestMap.get("setItemList").toString();
		adminSecMapper.deleteSetItem(requestMap);
		requestMap.put("SET_NO", requestMap.get("setNo").toString());
		if(!setItemList.equals("[]")) {
			requestMap.put("setItemList", commonUtil.jsonStringToList(setItemList));
			adminSecMapper.insertSetItem(requestMap);
		}
		return 1;
	}
	
	public Integer deleteSet(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.deleteSetItem(requestMap);
		return adminSecMapper.deleteSet(requestMap);
	}
	
	public HashMap<String, Object> selectSetItemList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectSetItemList(requestMap));
		return requestMap;
	}
	
	
	public HashMap<String, Object> selectDiscountList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectDiscountList(requestMap));
		requestMap.put("total", adminSecMapper.selectDiscountTotalCount(requestMap));
		return requestMap;
	}
	
	public Integer insertDiscount(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.insertDiscount(requestMap);
	}
	
	public Integer updateDiscount(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.updateDiscount(requestMap);
	}
	
	public Integer deleteDiscount(HashMap<String, Object> requestMap) throws Exception {
		return adminSecMapper.deleteDiscount(requestMap);
	}
	
	
	public HashMap<String, Object> selectFuneralStockList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralStockList(requestMap));
		requestMap.put("total", adminSecMapper.selectFuneralStockTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectFuneralStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralStockTotalStatusList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectFuneralStockItemList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralStockItemList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectFuneralStockStatusList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralStockStatusList(requestMap));
		return requestMap;
	}
	
	public Integer insertFuneralStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.insertFuneralStock(requestMap);
		
		String list = requestMap.get("list").toString();
		if(!list.equals("[]")) {
			requestMap.put("list", commonUtil.jsonStringToList(list));
			adminSecMapper.insertFuneralStockStatus(requestMap);
		}
		return 1;
	}
	
	public Integer updateFuneralStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.updateFuneralStock(requestMap);
		
		String list = requestMap.get("list").toString();
		if(!list.equals("[]")) {
			requestMap.put("STOCK_NO", requestMap.get("stockNo"));
			requestMap.put("list", commonUtil.jsonStringToList(list));
			adminSecMapper.deleteFuneralStockStatus(requestMap);
			adminSecMapper.insertFuneralStockStatus(requestMap);
		}
		return 1;
	}
	
	public Integer deleteFuneralStock(HashMap<String, Object> requestMap) throws Exception {
		adminSecMapper.deleteFuneralStockStatus(requestMap);
		return adminSecMapper.deleteFuneralStock(requestMap);
	}
	
	
	public HashMap<String, Object> selectStatisticsCalList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStatisticsCalList(requestMap));
		requestMap.put("total", adminSecMapper.selectStatisticsCalTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectStatisticsBinsoList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectStatisticsBinsoList(requestMap));
		requestMap.put("total", adminSecMapper.selectStatisticsBinsoTotalCount(requestMap));
		return requestMap;
	}
	

	public HashMap<String, Object> selectFuneralRaspList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectFuneralRaspList(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectJhRaspList(HashMap<String, Object> requestMap) throws Exception {
		requestMap.put("list", adminSecMapper.selectJhRaspList(requestMap));
		return requestMap;
	}
	
	
	/*
	 * 화환 권한 생성일자 관련
	 * 
	 */
	public HashMap<String, Object> selectFlowerFuneralCreateDt(HashMap<String, Object> requestMap) throws Exception {		
		requestMap.put("list", adminSecMapper.selectFlowerFuneralCreateDt(requestMap));
		return requestMap;
	}

	public HashMap<String, Object> insertFlowerFuneralCreateDt(HashMap<String, Object> requestMap) throws Exception {		
		System.out.println("serviceimple");
		requestMap.put("list", adminSecMapper.insertFlowerFuneralCreateDt(requestMap));		
		return requestMap;
	}
	
}