package com.pbfw.admin_sec.service;

import java.util.HashMap;

public interface AdminSecService {
	

	HashMap<String, Object> selectFuneralList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectStockCompanyList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectStockList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectStockStatusList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStock(HashMap<String, Object> requestMap) throws Exception;
	Integer updateStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStock(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectUserStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectUserStockList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectUserStockStatusList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertUserStock(HashMap<String, Object> requestMap) throws Exception;
	Integer updateUserStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteUserStock(HashMap<String, Object> requestMap) throws Exception;
	
	
	HashMap<String, Object> selectStockItemList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStockItem(HashMap<String, Object> requestMap) throws Exception;
	Integer updateStockItem(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStockItem(HashMap<String, Object> requestMap) throws Exception;
	Integer dupStockItemCode(HashMap<String, Object> requestMap) throws Exception;


	HashMap<String, Object> selectStockClassificationList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStockClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer updateStockClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStockClassification(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectQuestionList(HashMap<String, Object> requestMap) throws Exception;
	Integer updateQuestion(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectFuneralHallList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectAllFuneralHallList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralDivideImg(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralManagerList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertAllFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer updateAllFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteAllFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	
	
	HashMap<String, Object> selectRaspberryConnectionList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectStatisticsFuneralList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectStatisticsAreaList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectStatisticsUserList(HashMap<String, Object> requestMap) throws Exception;
	
	
	/*******************************************************************************************/
	HashMap<String, Object> selectCMName(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectOrderTotalList(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> insertEventRandomItem(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertEventOrder(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventTakeBack(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectEventOrderRePrintList(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectEventOrderList(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectEventCalculateList(HashMap<String, Object> requestMap) throws Exception;
	String insertCalCulate(HashMap<String, Object> requestMap) throws Exception;
	String insertReceipt(HashMap<String, Object> requestMap) throws Exception;
	String updateCalCulate(HashMap<String, Object> requestMap) throws Exception;
	String updateReceipt(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectEventFuneralInfoList(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectEventConfirmPrintList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectEventOrderPrintList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectEventBoardPrintList(HashMap<String, Object> requestMap) throws Exception;
	
	
	HashMap<String, Object> selectBinsoList(HashMap<String, Object> requestMap) throws Exception;
	Integer updateBinso(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectBinsoImgList(HashMap<String, Object> requestMap) throws Exception;
	
	
	Integer insertQuestion(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralInfo(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralInfo(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectPartnerManagementList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertPartnerManagement(HashMap<String, Object> requestMap) throws Exception;
	Integer updatePartnerManagement(HashMap<String, Object> requestMap) throws Exception;
	Integer deletePartnerManagement(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectFuneralItemPartner(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralClassificationList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralClassification(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectFuneralItemList(HashMap<String, Object> requestMap) throws Exception;
	Integer dupFuneralItemCode(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralItem(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralItemBatch(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralItem(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralItem(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectSetList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertSet(HashMap<String, Object> requestMap) throws Exception;
	Integer updateSet(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteSet(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectSetItemList(HashMap<String, Object> requestMap) throws Exception;
	
	
	HashMap<String, Object> selectDiscountList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertDiscount(HashMap<String, Object> requestMap) throws Exception;
	Integer updateDiscount(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteDiscount(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectFuneralStockList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralStockItemList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralStockStatusList(HashMap<String, Object> requestMap) throws Exception;

	Integer insertFuneralStock(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralStock(HashMap<String, Object> requestMap) throws Exception;

	
	HashMap<String, Object> selectStatisticsCalList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectStatisticsBinsoList(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectFuneralRaspList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectJhRaspList(HashMap<String, Object> requestMap) throws Exception;
	
	/**
	 * 화환권한 생성일자 관련
	 */
	HashMap<String, Object> insertFlowerFuneralCreateDt(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectFlowerFuneralCreateDt(HashMap<String, Object> requestMap) throws Exception;

}
