package com.pbfw.admin.service;

import java.util.HashMap;
import java.util.List;

public interface AdminService {
	
	HashMap<String, Object> selectTestList() throws Exception;
	
	
	
	HashMap<String, Object> selectNoticeList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertNotice(HashMap<String, Object> requestMap) throws Exception;
	Integer updateNotice(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteNotice(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectAllFuneralHallList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralHall(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectRaspberryList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberry(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberry(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteRaspberry(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectRaspberryControlList(HashMap<String, Object> requestMap) throws Exception;
	
	Integer updateRaspberryControlReset(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryControl(HashMap<String, Object> requestMap) throws Exception;
	
	
	HashMap<String, Object> selectRaspberryConnectionList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteRaspberryConnection(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectMaterialList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertMaterial(HashMap<String, Object> requestMap) throws Exception;
	Integer updateMaterial(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteMaterial(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectEventList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEvent(HashMap<String, Object> requestMap) throws Exception;
	Integer updateEvent(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEvent(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertEventRpiConnection(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventRpiConnection(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectEventFamily(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventFamily(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventFamily(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectEventCar(HashMap<String, Object> requestMap) throws Exception;
	Integer insertEventCar(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventCar(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteEventCalculate(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectEventDetail(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectRaspberryStatusPlateList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRaspberryStatusPlate(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspberryStatusPlate(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatusPlateStyle(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	Integer resetStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStatusPlateBg(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectAllEventList(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectRpiScreen(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertStatusPlateBinso(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStatusPlateBinso(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception;
	Integer insertStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteStatusPlateFiles(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectStatusPlateDetail(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectPhotoManagerList(HashMap<String, Object> requestMap) throws Exception;
	Integer insertPhotoManager(HashMap<String, Object> requestMap) throws Exception;
	Integer updatePhotoManager(HashMap<String, Object> requestMap) throws Exception;
	Integer deletePhotoManager(HashMap<String, Object> requestMap) throws Exception;
	
	Integer deleteDmPhoto(HashMap<String, Object> requestMap) throws Exception;
	Integer updateEventAliveFlag(HashMap<String, Object> requestMap) throws Exception;
	Integer insertRpiControll(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectSendRpiList(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> dongsungApi(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectLogList(HashMap<String, Object> requestMap) throws Exception;
	
	HashMap<String, Object> selectPhotoDetail(HashMap<String, Object> requestMap) throws Exception;
	
	

	Integer insertEventObituary(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectEventObituaryList(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectScreen10List(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectScreen30List(HashMap<String, Object> requestMap) throws Exception;
	
	
	
	//�쓬�썝 �젙蹂� 愿��젴
	HashMap<String, Object> selectFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer insertFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer updateFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteFuneralMusic(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectRaspForMusic(HashMap<String, Object> requestMap) throws Exception;
	Integer updateRaspForMusic(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectEvtForMusic(HashMap<String, Object> requestMap) throws Exception;
	
	// 誘몃━蹂닿린 愿��젴 �쁺�뿭
	HashMap<String, Object> selectJonghapPreview(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPreviewWhoIAm(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPreviewFindBinsoEvent(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPreviewSYIPEvent(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPreviewSYIPStyle(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPreviewFindMultiMode(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectJonghapBinsoForPreview(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectEventForFuneralPreview(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectSpecialPreview(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectWaitPreview(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectYJPreview(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectIpGwanPreview(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectSanggaList(HashMap<String, Object> requestMap) throws Exception;
	

	HashMap<String, Object> selectWaitVideo(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectSpecialVideo(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPreviewMusic(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPreviewUpdateMusic(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectRaspEvent(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectYjRaspList(HashMap<String, Object> requestMap) throws Exception;

	HashMap<String, Object> selectRaspMultiPythonInfoExcept(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectRaspMultiPythonInfo(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectRaspPythonInfo(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectReligionRaspList(HashMap<String, Object> requestMap) throws Exception;
	
	//2021.07.18 염습대장 insert service	
	HashMap<String, Object> selectShroudNote(HashMap<String, Object> requestMap) throws Exception;
	
	//2021.01.03 정산 제품 사용량 조회
	HashMap<String, Object> selectProductUsage(HashMap<String, Object> requestMap) throws Exception;
	
	//2021.01.03 정산표 조회
	HashMap<String, Object> selectSettlementTable(HashMap<String, Object> requestMap) throws Exception;
	
	//2021.01.03 정산표 합계조회
	HashMap<String, Object> selectSumSettlementTable(HashMap<String, Object> requestMap) throws Exception;
		
	
	//2021.01.03 정산 영수증 조회
	HashMap<String, Object> selectCalculateRecipe(HashMap<String, Object> requestMap) throws Exception;
	

}
