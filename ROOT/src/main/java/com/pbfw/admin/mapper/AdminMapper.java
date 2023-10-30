package com.pbfw.admin.mapper;

import java.util.HashMap;
import java.util.List;

public interface AdminMapper {
	List<HashMap<String, Object>> selectTestList() throws Exception;
	
	
	
	List<HashMap<String, Object>> selectNoticeList(HashMap<String, Object> requestMap) throws Exception;
	String selectNoticeTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertNotice(HashMap<String, Object> requestMap) throws Exception;
	Integer updateNotice(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteNotice(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectAllFuneralHallList(HashMap<String, Object> requestMap) throws Exception;
	String selectAllFuneralHallTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertUserMenu(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteUserMenu(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertUserFuneral(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteUserFuneral(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectRaspberryList(HashMap<String, Object> requestMap) throws Exception;
	String selectRaspberryTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberry(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberry(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteRaspberry(HashMap<String, Object> requestMap) throws Exception;

	Integer updateRaspberryControlReset(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryControl(HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectRaspberryWait(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectRaspberryConnectionList(HashMap<String, Object> requestMap) throws Exception;
	String selectRaspberryConnectionTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectMaterialList(HashMap<String, Object> requestMap) throws Exception;
	String selectMaterialTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertMaterial(HashMap<String, Object> requestMap) throws Exception;
	Integer updateMaterial(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteMaterial(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectEventScreen30List(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventForApi(HashMap<String, Object> requestMap) throws Exception;
	String selectEventTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEvent(HashMap<String, Object> requestMap) throws Exception;
	Integer updateEvent(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEvent(HashMap<String, Object> requestMap) throws Exception;
	

	List<HashMap<String, Object>> selectEventGeneralList(HashMap<String, Object> requestMap) throws Exception;
	
	
	Integer insertEventRpiConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventRpiConnection(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectEventFamily(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventFamily(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventFamily(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectEventCar(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventCar(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventCar(HashMap<String, Object> requestMap) throws Exception;
	
	Integer deleteEventOrder(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventTakeBack(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventRandomItem(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventOrderTmp(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventTakeBackTmp(HashMap<String, Object> requestMap) throws Exception;
	

//	List<HashMap<String, Object>> selectEventObituaryAlive(HashMap<String, Object> requestMap) throws Exception;
//	List<HashMap<String, Object>> selectEventObituary(HashMap<String, Object> requestMap) throws Exception;
//	Integer insertObituary(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectRaspberryStatusPlateBinsoList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectRaspberryStatusPlateList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberryStatusPlate(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryStatusPlate(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatusPlateStyle(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	Integer resetStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectRpiScreen(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectAllEventList(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertStatusPlateBinso(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStatusPlateBinso(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectPhotoManagerList(HashMap<String, Object> requestMap) throws Exception;
	String selectPhotoManagerTotalCount(HashMap<String, Object> requestMap) throws Exception;
	Integer insertPhotoManager(HashMap<String, Object> requestMap) throws Exception;
	Integer updatePhotoManager(HashMap<String, Object> requestMap) throws Exception;
	Integer deletePhotoManager(HashMap<String, Object> requestMap) throws Exception;
	
	Integer deleteDmPhoto(HashMap<String, Object> requestMap) throws Exception;
	Integer updateEventAliveFlag(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectLogList(HashMap<String, Object> requestMap) throws Exception;
	String selectLogTotalCount(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectPhotoDetail(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectFuneralName(HashMap<String, Object> requestMap) throws Exception;
	
//	Integer insertEventObituary(HashMap<String, Object> requestMap) throws Exception;
//	List<HashMap<String, Object>> selectEventObituaryList(HashMap<String, Object> requestMap) throws Exception;
	
	
	
	//�쓬�썝 �젙蹂� 愿��젴
	List<HashMap<String, Object>> selectFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectRaspForMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspForMusic(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEvtForMusic(HashMap<String, Object> requestMap) throws Exception;
	
	//PreView留뚮뱾湲� �쐞�빐 異붽��맂 遺�遺� 
	List<HashMap<String, Object>> selectJonghapPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectJonghapBinsoForPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectJonghapAttrForPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectJonghapStyleForPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectJonghapFuneralForPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectPreviewWhoIAm(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectPreviewFindBinsoEvent(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectPreviewSYIPEvent(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectPreviewSYIPStyle(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectPreviewFindMultiMode(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventForFuneralPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectSpecialPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectWaitPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectYJPreview(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectIpGwanPreview(HashMap<String, Object> requestMap) throws Exception;
	
	

	List<HashMap<String, Object>> selectSanggaList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectWaitVideo(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectSpecialVideo(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectPreviewMusic(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectPreviewUpdateMusic(HashMap<String, Object> requestMap) throws Exception;


	List<HashMap<String, Object>> selectRaspEvent(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectYjRaspList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectRaspMultiPythonInfoExcept(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectRaspMultiPythonInfo(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectRaspPythonInfo(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectReligionRaspList(HashMap<String, Object> requestMap) throws Exception;

	//염습대장
	List<HashMap<String, Object>> selectShroudNote(HashMap<String, Object> requestMap) throws Exception;
	
	//정산 제품사용량 조회
	List<HashMap<String, Object>> selectProductUsage(HashMap<String, Object> requestMap) throws Exception;
	
	//정산 정산표 조회
	List<HashMap<String, Object>> selectSettlementTable(HashMap<String, Object> requestMap) throws Exception;
	
	//정산 정산표합계 조회
	List<HashMap<String, Object>> selectSumSettlementTable(HashMap<String, Object> requestMap) throws Exception;
	
	//정산 영수증 출력
	List<HashMap<String, Object>> selectCalculateRecipe(HashMap<String, Object> requestMap) throws Exception;	
}