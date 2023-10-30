package com.pbfw.choomo.mapper;

import java.util.HashMap;
import java.util.List;

public interface ChoomoMapper {

	List<HashMap<String, Object>> selectObituaryList(HashMap<String, Object> requestMap) throws Exception;
	String selectObituaryTotalCount(HashMap<String, Object> requestMap) throws Exception;
	
	//추모 테이블로 변경
	List<HashMap<String, Object>> selectEventObituaryAlive(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventObituary(HashMap<String, Object> requestMap) throws Exception;
	Integer insertObituary(HashMap<String, Object> requestMap) throws Exception;
	
	
	Integer insertEventObituary(HashMap<String, Object> requestMap) throws Exception;
	List<HashMap<String, Object>> selectEventObituaryList(HashMap<String, Object> requestMap) throws Exception;
	
	
}