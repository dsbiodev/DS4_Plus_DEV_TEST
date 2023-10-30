package com.pbfw.choomo.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pbfw.choomo.service.ChoomoService;
import com.pbfw.common.util.CommonUtil;

@Controller
public class ChoomoController {
	Logger log = LoggerFactory.getLogger(this.getClass());

	@Resource(name="choomoService")
	ChoomoService choomoService;

	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
}
