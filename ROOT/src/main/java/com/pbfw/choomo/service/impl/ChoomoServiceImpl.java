package com.pbfw.choomo.service.impl;

import java.util.HashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.pbfw.choomo.service.ChoomoService;
import com.pbfw.choomo.mapper.ChoomoMapper;
import com.pbfw.common.interceptor.LoggerInterceptor;
import com.pbfw.common.util.CommonUtil;

@Service("choomoService")
public class ChoomoServiceImpl implements ChoomoService {
	protected Logger log = LoggerFactory.getLogger(LoggerInterceptor.class);
	
	@Autowired
	ChoomoMapper choomoMapper;
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;

	
}