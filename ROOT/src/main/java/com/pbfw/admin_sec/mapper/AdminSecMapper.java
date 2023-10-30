package com.pbfw.admin_sec.mapper;

import java.util.HashMap;
import java.util.List;

public interface AdminSecMapper {
	

	List<HashMap<String, Object>> selectStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectFuneralList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectStockUserList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectStockList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectStockStatusList(HashMap<String, Object> requestMap) throws Exception;
	String selectStockTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStock(HashMap<String, Object> requestMap) throws Exception;
	Integer updateStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStockStatus(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStockStatus(HashMap<String, Object> requestMap) throws Exception;

	
	List<HashMap<String, Object>> selectUserStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectUserStockList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectUserStockStatusList(HashMap<String, Object> requestMap) throws Exception;
	String selectUserStockTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertUserStock(HashMap<String, Object> requestMap) throws Exception;
	Integer updateUserStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteUserStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteUserStockStatus(HashMap<String, Object> requestMap) throws Exception;
	Integer insertUserStockStatus(HashMap<String, Object> requestMap) throws Exception;
	
	
	
	Integer insertEventOrderStock(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventOrderStockStatus(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertEventTakeBackStock(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventTakeBackStockStatus(HashMap<String, Object> requestMap) throws Exception;
	
	
	List<HashMap<String, Object>> selectStockItemList(HashMap<String, Object> requestMap) throws Exception;
	String selectStockItemTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStockItem(HashMap<String, Object> requestMap) throws Exception;
	Integer updateStockItem(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStockItem(HashMap<String, Object> requestMap) throws Exception;
	Integer dupStockItemCode(HashMap<String, Object> requestMap) throws Exception;
	
	
	List<HashMap<String, Object>> selectStockClassificationList(HashMap<String, Object> requestMap) throws Exception;
	String selectStockClassificationTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStockClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer updateStockClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStockClassification(HashMap<String, Object> requestMap) throws Exception;
	
	
	List<HashMap<String, Object>> selectQuestionList(HashMap<String, Object> requestMap) throws Exception;
	String selectQuestionTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer updateQuestion(HashMap<String, Object> requestMap) throws Exception;
	
	
	
	List<HashMap<String, Object>> selectFuneralHallList(HashMap<String, Object> requestMap) throws Exception;
	String selectFuneralHallTotalCount(HashMap<String, Object> requestMap) throws Exception;

	
	List<HashMap<String, Object>> selectAllFuneralHallList(HashMap<String, Object> requestMap) throws Exception;
	String selectAllFuneralHallTotalCount(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectFuneralManagerList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectFuneralPhotoManagerList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertAllFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer updateAllFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteAllFuneralHall(HashMap<String, Object> requestMap) throws Exception;

	
	List<HashMap<String, Object>> selectRaspberryConnectionList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	

	List<HashMap<String, Object>> selectStatisticsFuneralList(HashMap<String, Object> requestMap) throws Exception;
	String selectStatisticsFuneralTotalCount(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatisticsAreaList(HashMap<String, Object> requestMap) throws Exception;
	String selectStatisticsAreaTotalCount(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatisticsUserList(HashMap<String, Object> requestMap) throws Exception;
	String selectStatisticsUserTotalCount(HashMap<String, Object> requestMap) throws Exception;
	

	/*******************************************************************************************/
	HashMap<String, Object> selectCMName(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectOrderTotalList(HashMap<String, Object> requestMap) throws Exception;

	Integer insertEventRandomItem(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectRandomItemList(HashMap<String, Object> requestMap) throws Exception;
	
	
	Integer insertEventOrder(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventOrderTmp(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventOrderTmp(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertEventTakeBack(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventTakeBackTmp(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventTakeBackTmp(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectEventOrderRePrintList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventTakeBackRePrintList(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectEventOrderList(HashMap<String, Object> requestMap) throws Exception;
	String selectEventOrderTotalCount(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectTotalOrderList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectTotalPriceList(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectPartnerCalculateList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectCalculateHistoryList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectReceiptHistoryList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectCalculateDiscountList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertCalCulate(HashMap<String, Object> requestMap) throws Exception;
	Integer insertReceipt(HashMap<String, Object> requestMap) throws Exception;
	Integer updateCalCulate(HashMap<String, Object> requestMap) throws Exception;
	Integer updateReceipt(HashMap<String, Object> requestMap) throws Exception;

	
	List<HashMap<String, Object>> selectEventFuneralInfoList(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectEventOrderPartner(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventOrderPrintList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventOrderInfoList(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectEventBoardPrintList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventBoardFamilyPrintList(HashMap<String, Object> requestMap) throws Exception;

	
	List<HashMap<String, Object>> selectEventInfoList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventFamilyList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventBinsoList(HashMap<String, Object> requestMap) throws Exception;

	
	List<HashMap<String, Object>> selectBinsoList(HashMap<String, Object> requestMap) throws Exception;
	String selectBinsoTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteBinsoImg(HashMap<String, Object> requestMap) throws Exception;
	Integer insertBinsoImg(HashMap<String, Object> requestMap) throws Exception;
	Integer updateBinso(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectBinsoImgList(HashMap<String, Object> requestMap) throws Exception;
	
	
	Integer insertQuestion(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectFuneralInfo(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectFuneralDivideImg(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralInfo(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralDivdeImg(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralDivdeImg(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteUserMenu(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectPartnerManagementList(HashMap<String, Object> requestMap) throws Exception;
	String selectPartnerManagementTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertPartnerManagement(HashMap<String, Object> requestMap) throws Exception;
	Integer updatePartnerManagement(HashMap<String, Object> requestMap) throws Exception;
	Integer deletePartnerManagement(HashMap<String, Object> requestMap) throws Exception;

	
	List<HashMap<String, Object>> selectFuneralItemPartner(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectFuneralClassificationList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralClassification(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralClassification(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectFuneralItemList(HashMap<String, Object> requestMap) throws Exception;
	String selectFuneralItemTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer dupFuneralItemCode(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralItem(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralItemBatch(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralItem(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralItem(HashMap<String, Object> requestMap) throws Exception;
	
	
	List<HashMap<String, Object>> selectSetList(HashMap<String, Object> requestMap) throws Exception;
	String selectSetTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertSet(HashMap<String, Object> requestMap) throws Exception;
	Integer updateSet(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteSet(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectSetItemList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertSetItem(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteSetItem(HashMap<String, Object> requestMap) throws Exception;
	
	
	List<HashMap<String, Object>> selectDiscountList(HashMap<String, Object> requestMap) throws Exception;
	String selectDiscountTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertDiscount(HashMap<String, Object> requestMap) throws Exception;
	Integer updateDiscount(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteDiscount(HashMap<String, Object> requestMap) throws Exception;
	

	List<HashMap<String, Object>> selectFuneralStockList(HashMap<String, Object> requestMap) throws Exception;
	String selectFuneralStockTotalCount(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectFuneralStockTotalStatusList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectFuneralStockItemList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectFuneralStockStatusList(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertFuneralStock(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralStock(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralStockStatus(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralStockStatus(HashMap<String, Object> requestMap) throws Exception;
	

	List<HashMap<String, Object>> selectStatisticsCalList(HashMap<String, Object> requestMap) throws Exception;
	String selectStatisticsCalTotalCount(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectStatisticsBinsoList(HashMap<String, Object> requestMap) throws Exception;
	String selectStatisticsBinsoTotalCount(HashMap<String, Object> requestMap) throws Exception;


	List<HashMap<String, Object>> selectFuneralRaspList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectJhRaspList(HashMap<String, Object> requestMap) throws Exception;
	
	/**
	 * 화환 권한 생성일자 관련
	 */
	List<HashMap<String, Object>> selectFlowerFuneralCreateDt(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> insertFlowerFuneralCreateDt(HashMap<String, Object> requestMap) throws Exception;
	
}