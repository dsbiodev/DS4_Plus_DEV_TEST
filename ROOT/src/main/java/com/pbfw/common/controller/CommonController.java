package com.pbfw.common.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.pbfw.admin.service.AdminService;
import com.pbfw.common.service.CommonService;
import com.pbfw.common.util.CommonUtil;
import com.pbfw.common.util.MailUtil;

@Controller
public class CommonController {
	Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="commonService")
	CommonService commonService;
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
	@Resource(name="adminService")
	AdminService adminService;
	
	@Value("${file.basic.localpath}")
	private String fileUploadLoc;
	
	@Value("${file.basic.wastemppath}")
	private String fileTempWas;
	
	@Value("${file.basic.loctemppath}")
	private String fileTempLoc;
	
	
	/**
	* 페이지 헨들러
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/common/pageConnectionHandler.do", method = RequestMethod.POST)
	public ModelAndView pageHandler(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception {
		ModelAndView pageMv = new ModelAndView((String) requestMap.get("page"));
		pageMv.addObject("data", new JSONObject(requestMap));
		return pageMv;
	}
	
	/**
	* 로그인 (Web)
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/loginProcess.do")
	public @ResponseBody HashMap<String, Object> loginProcess(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpSession session) throws Exception {
		commonUtil.hashmapToString(requestMap);
		HashMap<String, Object> userInfo = commonService.selectLoginUserInfo(requestMap);
		if(userInfo != null && requestMap.get("deviceCode") != null && !requestMap.get("deviceCode").equals("")) {
			requestMap.put("userNo", userInfo.get("USER_NO"));
			commonService.updateLoginToken(requestMap);
		}
		if(requestMap.get("session") != null && userInfo != null) {
			requestMap.put("LOG_USER_NO", userInfo.get("USER_NO"));
			commonService.createLog("C", "LOGIN", request, requestMap);
			request.getSession().setAttribute("loginProcess", new JSONObject(userInfo));
			return userInfo;
		} else if(userInfo != null) return userInfo;
		else return null;
	}
	

	/**
	* 로그인 (Web) : 자동로그인 이후 검사 과정 추가 -20201207
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/common/selectLoginUserInfo.do")
	public @ResponseBody HashMap<String, Object> selectLoginUserInfo(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return commonService.selectLoginUserInfo(requestMap);
	}
	
	/**
	* 라즈베리 로그인 (raspberry)
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/raspberryLoginProcess.do")
	public @ResponseBody HashMap<String, Object> raspberryLoginProcess(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpSession session) throws Exception {
		HashMap<String, Object> userInfo = commonService.selectRaspberryLoginInfo(requestMap);
		if(userInfo != null && requestMap.get("deviceCode") != null && !requestMap.get("deviceCode").equals(""))
			commonService.updaterRaspberryDeviceCode(requestMap);
		if(userInfo != null) return userInfo;
		else return null;
	}
	

	/**
	* python 로그인 정보 전달용 (python)
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/pythonLoginInfo.do")
	public @ResponseBody HashMap<String, Object> pythonLoginInfo(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpSession session) throws Exception {
		return commonService.selectPythonLoginInfo(requestMap);
	}
	
	
	/**
	* python 로그인 (python)
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/pythonLoginProcess.do")
	public @ResponseBody HashMap<String, Object> pythonLoginProcess(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpSession session) throws Exception {
		HashMap<String, Object> userInfo = commonService.selectPythonLoginInfo(requestMap);
		if(userInfo != null) {
			commonService.updaterPythonIp(requestMap);
			return userInfo;
		}else return null;
	}
	
	
	
	/**
	* 로그아웃 (Web)
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value = "/logoutProcess.do")
	public String logoutProcess(@RequestParam HashMap<String, Object> requestMap, HttpSession session, HttpServletRequest request) throws Exception {
		JSONObject loginObject =  (JSONObject) request.getSession().getAttribute("loginProcess");

		if(loginObject != null) {
			requestMap.put("userNo", loginObject.get("USER_NO").toString());
			session.removeAttribute("loginProcess");
		}
		
//		commonService.updateLogoutToken(requestMap);
		return "redirect:/";
	}

	/**
	* 메뉴검색
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value = "/common/selectAllMenu.do")
	public @ResponseBody List<HashMap<String, Object>> selectAllMenu(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return commonService.selectAllMenu(requestMap);
	}
	
	/**
	* 공통코드 테이블
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value = "/common/selectCommonCode.do")
	public @ResponseBody List<HashMap<String, Object>> selectCommonCode(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return commonService.selectCommonCode(requestMap);
	}
	
	/**
	* 지역코드 호출
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value = "/common/selectCityCode.do")
	public @ResponseBody List<HashMap<String, Object>> selectCityCode(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return commonService.selectCityCode(requestMap);
	}

	/**
	* 아이디 중복체크
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value = "/common/overlapChecked.do")
	public @ResponseBody boolean overlapChecked(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		return commonService.overlapChecked(requestMap);
	}
	
	/**
	* 회원 리스트 출력
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value="/common/selectUserInfoList.do")
	public @ResponseBody HashMap<String, Object> selectUserInfoList(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return commonService.selectUserInfoList(requestMap);
	}
	
	/**
	* 회원가입
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/common/insertUser.do")
	public @ResponseBody Integer insertUser(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpServletResponse response, MultipartHttpServletRequest mhsr) throws Exception {
		if(requestMap.get("menuNoList") != null) requestMap.put("menuNoList", requestMap.get("menuNoList").toString().split(","));
		
		String actionCode = "";
		if(requestMap.get("lv").equals("20") || requestMap.get("lv").equals("29")) actionCode = "L0101";
		else if(requestMap.get("lv").equals("39")) actionCode = "L0102";
		else if(requestMap.get("lv").equals("90") || requestMap.get("lv").equals("91")) actionCode = "L0103";
		
		commonService.createLog("C", actionCode, request, requestMap);
		return commonService.insertUser(requestMap);
	}
	
	/**
	* 회원 정보 업데이트 (관리자)
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/common/updateUser.do")
	public @ResponseBody Integer updateUser(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpServletResponse response, MultipartHttpServletRequest mhsr) throws Exception {
		commonUtil.hashmapToString(requestMap);
		if(requestMap.get("menuNoList") != null) requestMap.put("menuNoList", requestMap.get("menuNoList").toString().split(","));
		
		String actionCode = "";
		if(requestMap.get("lv").equals("20") || requestMap.get("lv").equals("29")) actionCode = "L0101";
		else if(requestMap.get("lv").equals("39")) actionCode = "L0102";
		else if(requestMap.get("lv").equals("90") || requestMap.get("lv").equals("91")) actionCode = "L0103";
		
		commonService.createLog("U", actionCode, request, requestMap);
		return commonService.updateUser(requestMap);
	}
	
	/**
	* 회원 정보 업데이트 (사용자)
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/common/updateMobileUser.do")
	public @ResponseBody Integer updateMobileUser(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpServletResponse response, MultipartHttpServletRequest mhsr) throws Exception {
		commonUtil.hashmapToString(requestMap);
		requestMap.put("profileImg", commonUtil.fileUploadUtility(mhsr).get("filePath"));
		return commonService.updateUser(requestMap);
	}

	/**
	* 회원 정보 삭제
	* @param HashMap<String, Object> requestMap
	* @return ModelAndView
	* @exception Exception
	**/
	@RequestMapping(value="/common/deleteUser.do")
	public @ResponseBody Integer deleteUser(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return commonService.deleteUser(requestMap);
	}
	
	/**
	* 비밀번호 찾기 (이메일)
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value = "/common/selectFindPasswordEmail.do")
	public @ResponseBody Integer selectFindPasswordEmail(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		String newPassword = commonUtil.getRandomString().toUpperCase().substring(0, 10);
		requestMap.put("password", newPassword);
		
		if(commonService.updateUser(requestMap) == 1) {
			HashMap<String, Object> mailMap = new HashMap<String, Object>();
			mailMap.put("to", requestMap.get("userId").toString());
			mailMap.put("title", requestMap.get("name").toString()+"님이 요청하신 임시 비밀번호입니다.");
			mailMap.put("text", newPassword);
			
			MailUtil mUtil = new MailUtil();
			return mUtil.mailSender(mailMap);
		} else return 0;
	}
	
	/**
	* 편집기 이미지 업로드
	* @param HashMap<String, Object> requestMap
	* @return HashMap<String, Object>
	* @exception Exception
	**/
	@RequestMapping(value = "/common/editorImageUpload.do")
	public @ResponseBody HashMap<String, String> editorImageUpload(@RequestParam HashMap<String, Object> requestMap, MultipartHttpServletRequest mhsr) throws Exception {
		return commonUtil.fileUploadUtility(mhsr); 
	}
	
	/**
	* 이미지 등록
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/admin/insertImages.do")
	public @ResponseBody Integer insertImages(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return commonService.insertImages(requestMap);
	}
	
	/**
	* 이미지 삭제
	* @param HashMap<String, Object> requestMap
	* @return Integer
	* @exception Exception
	**/
	@RequestMapping(value = "/admin/deleteImages.do")
	public @ResponseBody Integer deleteImages(@RequestParam HashMap<String, Object> requestMap) throws Exception {
		commonUtil.hashmapToString(requestMap);
		return commonService.deleteImages(requestMap);
	}
	
	/**
	* 파일다운로드
	* @param filePath
	* @return 
	* @exception Exception
	**/
	@RequestMapping(value="/common/fileDownload")
	public ModelAndView fileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			URL u = new URL(request.getParameter("filePath"));
			String OS = System.getProperty("os.name").toLowerCase();
			String dPath = (OS.indexOf("win") == 0 ? fileTempLoc:fileTempWas);
			
//			System.out.println("dPath : "+dPath);
			File tempDir = new File(dPath);
			if(!tempDir.exists()) { 
				tempDir.mkdirs();
				if(OS.indexOf("win") != 0) {
					String cmd = "chmod 777 " + (OS.indexOf("win") == 0 ? fileTempLoc:fileTempWas); 
					Runtime rt = Runtime.getRuntime(); 
					Process p = rt.exec(cmd); 
					p.waitFor();
				};
			};
			
			File [] dFiles = new File(dPath).listFiles();
			for(File f:dFiles) f.delete();
			
			InputStream is = u.openStream();
			FileOutputStream fos = new FileOutputStream(dPath+request.getParameter("fileName"));

			byte[] buf = new byte[1024];
			double len = 0;
			while ((len = is.read(buf)) > 0) fos.write(buf, 0, (int) len);

			fos.close();
			is.close();
			
			File down = new File(dPath+request.getParameter("fileName"));
			ModelAndView mv = new ModelAndView("download", "downloadFile", down);
	        mv.addObject("fileName", request.getParameter("fileName"));
	        return mv;
        } catch (Exception e) {
        	e.printStackTrace();
//        	System.out.println("다운로드 오류입니다. 나중에 다시 받아보세요.");
        	return null;
        }
	}
}
