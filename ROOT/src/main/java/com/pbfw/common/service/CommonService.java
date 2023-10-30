package com.pbfw.common.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

public interface CommonService {
	HashMap<String, Object> selectUserInfoList(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectLoginUserInfo(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectRaspberryLoginInfo(HashMap<String, Object> requestMap) throws Exception;
	Integer updaterRaspberryDeviceCode(HashMap<String, Object> requestMap) throws Exception;
	HashMap<String, Object> selectPythonLoginInfo(HashMap<String, Object> requestMap) throws Exception;
	Integer updaterPythonIp(HashMap<String, Object> requestMap) throws Exception;
	
	List<HashMap<String, Object>> selectAllMenu(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectCommonCode(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectCityCode(HashMap<String, Object> requestMap) throws Exception;
	
	boolean overlapChecked(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertUser(HashMap<String, Object> requestMap) throws Exception;
	Integer updateUser(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteUser(HashMap<String, Object> requestMap) throws Exception;

	Integer updateLoginToken(HashMap<String, Object> requestMap) throws Exception;
	Integer updateLogoutToken(HashMap<String, Object> requestMap) throws Exception;
	
	Integer insertImages(HashMap<String, Object> requestMap) throws Exception;
	Integer deleteImages(HashMap<String, Object> requestMap) throws Exception;
	
	void createLog(String logDivision, String logActionCode, HttpServletRequest request, HashMap<String, Object> requestMap) throws Exception;

	List<HashMap<String, Object>> selectEventSche10() throws Exception;
	HashMap<String, Object> selectEventSche30(HashMap<String, Object> requestMap) throws Exception;
	
	
	HashMap<String, Object> selectRaspEventSche(HashMap<String, Object> requestMap) throws Exception;
	
	
}
