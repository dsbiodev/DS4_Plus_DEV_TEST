package com.pbfw.common.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pbfw.admin.mapper.AdminMapper;
import com.pbfw.common.interceptor.LoggerInterceptor;
import com.pbfw.common.mapper.CommonMapper;
import com.pbfw.common.service.CommonService;
import com.pbfw.common.util.CommonUtil;

@Service("commonService")
public class CommonServiceImpl implements CommonService {
	protected Logger log = LoggerFactory.getLogger(LoggerInterceptor.class);
	
	@Autowired
	CommonMapper commonMapper;
	
	@Autowired
	AdminMapper adminMapper;
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;

	public HashMap<String, Object> selectUserInfoList(HashMap<String, Object> requestMap) throws Exception {
		if(requestMap.get("deviceCodeCheck") != null && !requestMap.get("deviceCodeCheck").equals("")) {
			List<HashMap<String, Object>> userlist = commonMapper.selectUserInfoList(requestMap);
			List<String> deviceList = new ArrayList<String>();
			for(HashMap<String, Object> deviceCode : userlist) {
				if(deviceCode.get("DEVICE_CODE") != null && !deviceCode.get("DEVICE_CODE").equals("")) deviceList.add(deviceCode.get("DEVICE_CODE").toString());
			}
			
			requestMap.put("deviceList", deviceList);
			requestMap.put("list", userlist);
		} else requestMap.put("list", commonMapper.selectUserInfoList(requestMap));
		
		requestMap.put("total", commonMapper.selectUserInfoTotalCount(requestMap));
		return requestMap;
	}
	
	public HashMap<String, Object> selectLoginUserInfo(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.selectLoginUserInfo(requestMap);
	}

	public HashMap<String, Object> selectRaspberryLoginInfo(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.selectRaspberryLoginInfo(requestMap);
	}
	
	public HashMap<String, Object> selectPythonLoginInfo(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.selectPythonLoginInfo(requestMap);
	}
	
	public Integer updaterRaspberryDeviceCode(HashMap<String, Object> requestMap) throws Exception {
		commonMapper.updaterRaspberryOverlapInit(requestMap);
		return commonMapper.updaterRaspberryDeviceCode(requestMap);
	}

	public Integer updaterPythonIp(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.updaterPythonIp(requestMap);
	}
	
	public List<HashMap<String, Object>> selectAllMenu(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.selectAllMenu(requestMap);
	}
	
	public List<HashMap<String, Object>> selectCommonCode(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.selectCommonCode(requestMap);
	}
	
	public List<HashMap<String, Object>> selectCityCode(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.selectCityCode(requestMap);
	}
	
	public boolean overlapChecked(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.overlapChecked(requestMap);
	}
	
	public Integer insertUser(HashMap<String, Object> requestMap) throws Exception {
		if(commonMapper.insertUser(requestMap) == 1) {
			requestMap.put("userNo", requestMap.get("USER_NO"));
			requestMap.put("photoManagerNo", requestMap.get("USER_NO"));
			
			if(requestMap.get("calculateFlag") != null && !requestMap.get("calculateFlag").equals("")) adminMapper.updateFuneralHall(requestMap);
			if(requestMap.get("menuNoList") != null) adminMapper.insertUserMenu(requestMap);
			if(requestMap.get("funeralNoList") != null) adminMapper.updateFuneralHall(requestMap);
		}
		
		return 1;
	}
	
	public Integer updateUser(HashMap<String, Object> requestMap) throws Exception {
		if(commonMapper.updateUser(requestMap) == 1) {
			if(requestMap.get("calculateFlag") != null && !requestMap.get("calculateFlag").equals("")) adminMapper.updateFuneralHall(requestMap);
			if(requestMap.get("menuNoList") != null) {
				adminMapper.deleteUserMenu(requestMap);
				adminMapper.insertUserMenu(requestMap);
			}
			if(requestMap.get("photoManagerNo") != null) adminMapper.deleteFuneralHall(requestMap);
			if(requestMap.get("funeralNoList") != null) adminMapper.updateFuneralHall(requestMap);
			
		}
		
		return 1;
	}
	
	public Integer deleteUser(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.deleteUser(requestMap);
	}
	
	public Integer updateLoginToken(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.updateLoginToken(requestMap);
	}
	
	public Integer updateLogoutToken(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.updateLogoutToken(requestMap);
	}
	
	public Integer insertImages(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.insertImages(requestMap);
	}
	
	public Integer deleteImages(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.deleteImages(requestMap);
	}
	
	public void createLog(String logDivision, String logActionCode, HttpServletRequest request, HashMap<String, Object> requestMap) throws Exception {
		JSONObject loginObject =  (JSONObject) request.getSession().getAttribute("loginProcess");
		requestMap.put("dataString", requestMap.toString());
		if(logActionCode.equals("LOGIN")) {
			requestMap.put("logUserNo", requestMap.get("LOG_USER_NO"));
		}else {
			requestMap.put("logUserNo", loginObject != null ? loginObject.get("USER_NO") : 1);
		}
		requestMap.put("logDivision", logDivision);
		requestMap.put("logActionCode", logActionCode);
		requestMap.put("logIp", commonUtil.getIpAddress(request));
		
		commonMapper.createLog(requestMap);
	}
	
	public List<HashMap<String, Object>> selectEventSche10() throws Exception {
		return commonMapper.selectEventSche10();
	}
	
	public HashMap<String, Object> selectEventSche30(HashMap<String, Object> requestMap) throws Exception {
		return commonMapper.selectEventSche30(requestMap);
	}

	public HashMap<String, Object> selectRaspEventSche(HashMap<String, Object> requestMap) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("list", commonMapper.selectRaspEventSche(requestMap));
		return map;
	}
	
}
