package com.pbfw.common.interceptor;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.pbfw.common.service.CommonService;

public class LoginInterceptor extends HandlerInterceptorAdapter {
	protected Logger log = LoggerFactory.getLogger(LoggerInterceptor.class);
	
	@Resource(name="commonService")
	private CommonService commonService;
	
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();

		if(session.getAttribute("loginProcess") != null) {
			log.debug("Login Session Exist. Checking...");
			JSONObject loginObject =  (JSONObject) request.getSession().getAttribute("loginProcess");
			
			HashMap<String, Object> loginMap = new HashMap<String, Object>();
			loginMap.put("userNo", loginObject.get("USER_NO").toString());
			if(loginObject.get("LV").equals("99") && loginObject.get("FUNERAL_NO") != null) loginMap.put("targetFuneralNo", loginObject.get("FUNERAL_NO"));
			
			request.getSession().setAttribute("loginProcess", new JSONObject(commonService.selectLoginUserInfo(loginMap)));
		} else {
			
		}
		
        return super.preHandle(request, response, handler);
    }
     
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    	
    }
}
