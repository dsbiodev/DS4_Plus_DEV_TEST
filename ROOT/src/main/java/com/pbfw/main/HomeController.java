package com.pbfw.main;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.net.util.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.pbfw.admin.controller.AdminController;
import com.pbfw.admin.service.AdminService;
import com.pbfw.common.util.CommonUtil;

@Controller
public class HomeController {
	Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
	@Resource(name="adminService")
	AdminService adminService;
	
	@RequestMapping(value = "/main")
	public ModelAndView mainController(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		ModelAndView mv  = new ModelAndView("/main");
		return mv;
	}
	
	@RequestMapping(value = "/{path}")
	public ModelAndView pathController(@PathVariable String path, @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		ModelAndView mv  = new ModelAndView("/main");
		return mv;
	}
	
	@RequestMapping(value = "/{path}/{subPath}")
	public ModelAndView pathController(@PathVariable String path, @PathVariable String subPath, @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		log.debug("pathController");
		ModelAndView mv  = null;
		mv = new ModelAndView("/main");
		mv.addObject("path", path);
		mv.addObject("subPath", subPath);
		
		Iterator<String> mapIter = requestMap.keySet().iterator();
		while(mapIter.hasNext()) {
            String key = mapIter.next();
            String value = (String) requestMap.get(key);
            mv.addObject(key, value);
        }
		
		return mv;
	}
	
	@RequestMapping(value = "/admin/{path}/{pk}")
	public ModelAndView adminSubPathPkControll(@PathVariable String path, @PathVariable String pk, @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		log.debug("adminSubPathPkControll");
		commonUtil.hashmapToString(requestMap);
		ModelAndView mv  = new ModelAndView("/main");
		mv.addObject("path", path);
		mv.addObject("pk", pk);
		return mv;
	}
	
	@RequestMapping(value = "/manager/{path}/{pk}")
	public ModelAndView managerSubPathPkControll(@PathVariable String path, @PathVariable String pk, @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		log.debug("managerSubPathPkControll");
		commonUtil.hashmapToString(requestMap);
		ModelAndView mv  = new ModelAndView("/main");
		mv.addObject("path", path);
		mv.addObject("pk", pk);
		return mv;
	}
	
	@RequestMapping(value = "/client/{path}/{pk}")
	public ModelAndView clientSubPathPkControll(@PathVariable String path, @PathVariable String pk, @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		log.debug("clientSubPathPkControll");
		commonUtil.hashmapToString(requestMap);
		ModelAndView mv  = new ModelAndView("/main");
		mv.addObject("path", path);
		mv.addObject("pk", pk);
		return mv;
	}
	
	@RequestMapping(value = "/webview/{path}/{pk}")
	public ModelAndView webviewControll(@PathVariable String path, @PathVariable String pk, @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonUtil.hashmapToString(requestMap);
		ModelAndView mv  = new ModelAndView("/webview/"+path);
		mv.addObject("pk", pk);
		return mv;
	}
	
	@RequestMapping(value = "/view/print/{pk}")
	public ModelAndView webviewPrintPage(@PathVariable String path, @PathVariable String pk, @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		commonUtil.hashmapToString(requestMap);
		ModelAndView mv  = new ModelAndView("/view/print");
		mv.addObject("pk", pk);
		return mv;
	}
	
	@RequestMapping(value = "/dsapi/{pk}", method=RequestMethod.GET)
	public @ResponseBody List<HashMap<String, Object>> dongsungApi(@PathVariable String pk, HttpServletRequest request) throws Exception {
		if(pk != null && !pk.equals("")) {
			HashMap<String, Object> _param = new HashMap<String, Object>();
			String funeralNo = new String(Base64.decodeBase64(pk.getBytes()));
//			System.out.println("decode : "+funeralNo);
			_param.put("funeralNo", funeralNo);
			_param.put("statusPlate", "true");
			return adminService.dongsungApi(_param);
		} else return null;
	}
}
