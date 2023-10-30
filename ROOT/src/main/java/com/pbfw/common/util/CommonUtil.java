package com.pbfw.common.util;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.*;
import com.drew.metadata.MetadataException;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import com.mortennobel.imagescaling.ResampleOp;

@Service("commonUtil")
public class CommonUtil {
	private Logger log = LoggerFactory.getLogger(this.getClass());
	private static String OS = System.getProperty("os.name").toLowerCase();
	
	@Value("${file.basic.localpath}")
	private String fileUploadLoc;

	@Value("${file.basic.waspath}")
	private String fileUploadWas;
	
	@Value("${firebase.api.key}")
	private String firebaseApiKey;
	
	@Value("${file.server.url}")
	private String fileServerUrl;
	
	@Value("${file.server.port}")
	private String fileServerPort;
	
	@Value("${file.server.webport}")
	private String fileServerWebPort;

	@Value("${file.server.path}")
	private String fileServerPath;

	@Value("${file.server.user}")
	private String fileServerUser;
	
	@Value("${file.server.password}")
	private String fileServerPassword;
	
	public String getToDate(String format) {
		Date d = new Date();
		
		if(format == null || format.equals("")) format = "yyyyMMdd";
		
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        String toDateString = sdf.format(d);
        return toDateString;
	}
	
	// Map Log (Key : Value)
	public void mapToString(Map<String, ?> requestMap) throws Exception {
		Iterator<String> mapIter = requestMap.keySet().iterator();
        while(mapIter.hasNext()) {
            String key = mapIter.next();
            String value = (String) requestMap.get(key);
            log.debug(key+" : "+value);
        }
	}
	
	// HashMap Log (Key : Value)
	public void hashmapToString(HashMap<String, ?> requestMap) throws Exception {
		Iterator<String> mapIter = requestMap.keySet().iterator();
        while(mapIter.hasNext()) {
            String key = mapIter.next();
            String value = (String) requestMap.get(key);
            log.debug("["+requestMap.get(key).getClass().getName()+"] "+key+" : "+value);
        }
	}
	
	// HashMap Controll ( flag: i, d, u )
	public HashMap<String, Object> hashmapControll(HashMap<String, Object> requestMap, String flag) throws Exception {
		HashMap<String, Object> tempMap = new HashMap<String, Object>();
		tempMap.putAll(requestMap);
		
		Iterator<String> mapIter = tempMap.keySet().iterator();
        while(mapIter.hasNext()) {
            String key = mapIter.next();
            String value = (String) tempMap.get(key);
            if(flag.equals("d") && value.equals("")) requestMap.remove(key);
            if(flag.equals("u") && !value.equals("")) requestMap.put(key, URLDecoder.decode(value, "UTF-8"));
            if(flag.equals("u2") && !value.equals("")) requestMap.put(key, URLDecoder.decode(value, "EUC-KR"));
        }
        return requestMap;
	}
	
	// FileUpload
	public HashMap<String, String> fileUploadUtility(MultipartHttpServletRequest mhsr) throws Exception {
		HashMap<String, String> fileInfo =  new HashMap<String, String>();
		Iterator<String> itor = mhsr.getFileNames();
		
		File desti = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/");
		
		
		if(!desti.exists()) {
			desti.mkdirs();
			
			if(OS.indexOf("win") != 0) {
				String cmd = "chmod 777 " + (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas) + getToDate(""); 
				Runtime rt = Runtime.getRuntime(); 
				Process p = rt.exec(cmd);
				p.waitFor();
			};
		};
		
		while(itor.hasNext()) {
			String fileKey = itor.next();
			log.debug("fileKey : "+fileKey);
			MultipartFile mFile = mhsr.getFile(fileKey);
			String originalFileName = mFile.getOriginalFilename();
			if(originalFileName != null && !originalFileName.equals("")) {
				String fileExt = originalFileName.substring(originalFileName.lastIndexOf("."));
				String newFileName = getRandomString()+fileExt;
				
				File file = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName);
				mFile.transferTo(file);
				
				log.debug("[ "+fileKey+" ] OriginFileName : "+originalFileName);
	            log.debug("[ "+fileKey+" ] NewFileName : "+newFileName);
				
				fileInfo.put("originalFileName", originalFileName);
				fileInfo.put("newFileName", newFileName);
				fileInfo.put("fileExt", fileExt);
				fileInfo.put("filePath", "/FileRootPath/"+getToDate("")+"/"+newFileName);
			} else {
				fileInfo.put("newFileName", "");
			}
		}
		
		return fileInfo;
	}
	 
	// Multi FileUpload
		public List<HashMap<String, Object>> multiFileUploadUtility(MultipartHttpServletRequest mhsr) throws Exception {
			
			
			List<HashMap<String, Object>> fileInfo = new ArrayList<HashMap<String, Object>>();
			HashMap<String, Object> listMap = null;
			Iterator<String> itor = mhsr.getFileNames();
			
			File desti = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/");
			if(!desti.exists()) {
				desti.mkdirs();
				if(OS.indexOf("win") != 0) {
					String cmd = "chmod 777 " + (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate(""); 
					Runtime rt = Runtime.getRuntime(); 
					Process p = rt.exec(cmd); 
					p.waitFor();
				};
			};
			
			int idx = 0;
			while(itor.hasNext()) {
				listMap = new HashMap<String, Object>();
				String fileKey = itor.next();
				MultipartFile mFile = mhsr.getFile(fileKey);
				String originalFileName = mFile.getOriginalFilename();
				
				if(originalFileName != null && !originalFileName.equals("")) {
					String fileExt = originalFileName.substring(originalFileName.lastIndexOf("."));
					String newFileName = getRandomString()+fileExt;
					
					File file = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName);
					mFile.transferTo(file);
					
					listMap.put("originalFileName", originalFileName);
					listMap.put("fileKey", fileKey);
					listMap.put("fileIndex", idx);
					listMap.put("file", newFileName);
					listMap.put("filePath", "/FileRootPath/"+getToDate("")+"/"+newFileName);
					listMap.put("realFilePath", (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName);
					log.debug("fileIndex : "+fileKey);
					log.debug("file : "+newFileName);
//					System.out.println("fileIndex : "+fileKey);
//					System.out.println("file : "+newFileName);
					
					fileInfo.add(listMap);
					idx++;
				} else {
					
				}
			}
			
			return fileInfo;
			
//			
//			List<HashMap<String, Object>> fileInfo = new ArrayList<HashMap<String, Object>>();
//			HashMap<String, Object> listMap = null;
//			Iterator<String> itor = mhsr.getFileNames();
//			
//			File desti = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/");
//			if(!desti.exists()) {
//				desti.mkdirs();
//				if(OS.indexOf("win") != 0) {
//					String cmd = "chmod 777 " + (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate(""); 
//					Runtime rt = Runtime.getRuntime(); 
//					Process p = rt.exec(cmd); 
//					p.waitFor();
//				};
//			};
//			
//			int idx = 0;
//			while(itor.hasNext()) {
//				listMap = new HashMap<String, Object>();
//				String fileKey = itor.next();//파일 이름
//				MultipartFile mFile = mhsr.getFile(fileKey);//파일이름으로 파일을 받아옴
//				String originalFileName = mFile.getOriginalFilename();
	//
//				//int pos = mFile.getOriginalFilename().lastIndexOf( "." );
//				String fileExtImg = "";
//				BufferedImage buffredI = null;
//				if(originalFileName != null && !originalFileName.equals("")) {
//					fileExtImg =  originalFileName.substring(originalFileName.lastIndexOf("."));
//					if(fileExtImg.toUpperCase().equals(".JPG")||fileExtImg.toUpperCase().equals(".JEPG"))  {//이미지인경우에만 실행
//						//모바일 이미지 옆으로 눞는 현상 체크 시작
//						//오리엔테이션 구하기
//						byte[] imgBytes = mFile.getBytes();
//						BufferedInputStream bufferedIS = new BufferedInputStream(new ByteArrayInputStream(imgBytes));
//						int orientation = getOrientation(bufferedIS);
//						//이미지 돌리기
//						ByteArrayInputStream byteIS = new ByteArrayInputStream(imgBytes);
//						buffredI = rotateImageForMobile(byteIS,orientation);
//						//저장 프로세스
//						//모바일 이미지 옆으로 눞는 현상 체크 끝
//					}
//				}
//			
//				
//				
//				
//				if(originalFileName != null && !originalFileName.equals("")) {
//					String fileExt = originalFileName.substring(originalFileName.lastIndexOf("."));
//					String newFileName = getRandomString()+fileExt;
//					
//					File file = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName);
//					
//					
//					if(fileExtImg.toUpperCase().equals(".JPG")||fileExtImg.toUpperCase().equals(".JEPG")) {
//						//이미지 파일의 경우 
//						ImageIO. write(buffredI, "jpg", file);
//					}else{
//						//일반적인 파일의 경우
//						mFile.transferTo(file);
//					}
	//
//					listMap.put("originalFileName", originalFileName);
//					listMap.put("fileKey", fileKey);
//					listMap.put("fileIndex", idx);
//					listMap.put("file", newFileName);
//					listMap.put("filePath", "/FileRootPath/"+getToDate("")+"/"+newFileName);
//					listMap.put("realFilePath", (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName);
//					log.debug("fileKey : "+fileKey);
//					log.debug("file : "+newFileName);
//					
//					fileInfo.add(listMap);
//					idx++;
//				} else {
//					
//				}
//			}
//			
//			return fileInfo;
		}
	
	
	//20220412 이미지 압축 로직 추가
	//20220506 이미지 압축 유틸과 기존 유틸변경(빈소,종합,영정만 압축로직 사용)
	public List<HashMap<String, Object>> NewMultiFileUploadUtility(MultipartHttpServletRequest mhsr) throws Exception {
		
		
		List<HashMap<String, Object>> fileInfo = new ArrayList<HashMap<String, Object>>();
		
		HashMap<String, Object> listMap = null;
		
		Iterator<String> itor = mhsr.getFileNames();
		
		
		File desti = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/");
		if(!desti.exists()) {
			desti.mkdirs();
			if(OS.indexOf("win") != 0) {
				String cmd = "chmod 777 " + (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate(""); 
				Runtime rt = Runtime.getRuntime(); 
				Process p = rt.exec(cmd); 
				p.waitFor();
			};
		};
		
		
		int idx = 0;
		while(itor.hasNext()) {
			
			listMap = new HashMap<String, Object>();
			
			String fileKey = itor.next();
			
			MultipartFile mFile = mhsr.getFile(fileKey);
			String originalFileName = mFile.getOriginalFilename();
			
			if(originalFileName != null && !originalFileName.equals("")) {
				
				String fileExt = originalFileName.substring(originalFileName.lastIndexOf("."));
				String newFileName = getRandomString()+fileExt;
				
				//File file = new File((OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName);
								
									            	
				String strFilepath = (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName;								
				String strformatName = originalFileName.substring(originalFileName.lastIndexOf(".") + 1).toLowerCase();
								
				int boolSave = resizeImageFile(mFile, strFilepath,strformatName);
																
				if(boolSave == 9999) {
					//log.info("이미지 에러");
					listMap.put("picture", 9999);
					fileInfo.add(listMap);
					return fileInfo;					
				}else {
					
					//log.info("pass");
					listMap.put("picture", "pass");
				}
	
				//mFile.transferTo(file);
				
				//resizeImageFile(mFile, strFilepath,strformatName);				
				
				listMap.put("originalFileName", originalFileName);
				listMap.put("fileKey", fileKey);
				listMap.put("fileIndex", idx);
				listMap.put("file", newFileName);
				listMap.put("filePath", "/FileRootPath/"+getToDate("")+"/"+newFileName);				
				listMap.put("realFilePath", (OS.indexOf("win") == 0 ? fileUploadLoc:fileUploadWas)+getToDate("")+"/"+newFileName);
				log.debug("fileIndex : "+fileKey);
				log.debug("file : "+newFileName);
				
				fileInfo.add(listMap);
				idx++;
			} 
			
		}
		//log.info("업로드 완료");
		return fileInfo;

	}
	
	 private int resizeImageFile(MultipartFile files, String filePath, String formatName) throws Exception {
		 
		 int rlst = 0;
		 			
		    // 이미지 읽어 오기
	        BufferedImage inputImage = ImageIO.read(files.getInputStream());
			// 이미지 세로 가로 측정
	        int originWidth = inputImage.getWidth();
	        int originHeight = inputImage.getHeight();
	        // 변경할 가로 길이
	        int newWidth = 1024;

	        if (originWidth > newWidth) {
	        	
	        	//log.info("resizeImageFile if");
	        	
	            // 기존 이미지 비율을 유지하여 세로 길이 설정
	            int newHeight = (originHeight * newWidth) / originWidth;
	            	
				   // 이미지 품질 설정         
				// Image.SCALE_DEFAULT : 기본 이미지 스케일링 알고리즘 사용
				// Image.SCALE_FAST : 이미지 부드러움보다 속도 우선
				// Image.SCALE_REPLICATE : ReplicateScaleFilter 클래스로 구체화 된 이미지 크기 조절 알고리즘
				// Image.SCALE_SMOOTH : 속도보다 이미지 부드러움을 우선
				// Image.SCALE_AREA_AVERAGING : 평균 알고리즘 사용
	            
	            Image resizeImage = inputImage.getScaledInstance(newWidth, newHeight, Image.SCALE_FAST);
	            BufferedImage newImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
	            Graphics graphics = newImage.getGraphics();
	            graphics.drawImage(resizeImage, 0, 0, null);
	            graphics.dispose();
	       
	            // 이미지 저장
	            File newFile = new File(filePath);
	            	            	            	            	         
	            ImageIO.write(newImage, formatName, newFile);	      

	            //2mb check
	            File testFile = new File(filePath);	            	            
	            double fileSize = Math.ceil(testFile.length()/1024);
	            
	         	//log.info("size:"+fileSize);
	            	          	            
	            if(fileSize > 2000) {
	            //if(fileSize > 3) {	            	
	            	rlst = 9999;
	            	//업로드 하안됩니다.
	            }
	            
	        } else { 	        		           	
	             files.transferTo(new java.io.File(filePath));
	        }	  
	        return rlst;
	    }	
		
		
	
	// Mybatis Result Querty ( i:rownum, d:rownum, u:rownum )
	public HashMap<String, Object> resultMybatis(String kindStr, Integer resultQuery) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put(kindStr, resultQuery);
		return resultMap;
	}
	
	public HashMap<String, Object> resultJsonMap(List<?> list) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		return resultMap;
	}
	
	public boolean isEmptyNull(String getStr) {
		if(getStr == null || getStr.equals("")) return false;
		else return true;
	}
	
	public HashMap<String, Object> jsonStringToHashMap(String jsonString) {
		Gson gson = new Gson();
		HashMap<String, Object> jsonObj = null;
		if(isEmptyNull(jsonString) && !jsonString.equals("[]")) {
			jsonObj = gson.fromJson(jsonString, new TypeToken<HashMap<String, Object>>(){}.getType());
			return jsonObj;
		} else {
			return jsonObj;
		}
	}
	
	public List<HashMap<String, Object>> jsonStringToList(String jsonString) {
		Gson gson = new Gson();
		List<HashMap<String, Object>> list = null;
		if(isEmptyNull(jsonString) && !jsonString.equals("[]")) {
			list = gson.fromJson(jsonString, new TypeToken<List<HashMap<String, Object>>>(){}.getType());
			return list;
		} else {
			return list;
		}
	}
	
	public String getRandomString(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
	
	public String returnDeviceType(HttpServletRequest request) {
		Device device = DeviceUtils.getCurrentDevice(request);
		
		String deviceType = "unknown";
		if(device == null) log.debug("device is null");
		else if(device.isNormal()) deviceType = "nomal";
		else if(device.isMobile()) deviceType = "mobile";
		else if(device.isTablet()) deviceType = "tablet";
		
		log.debug("device is "+deviceType);
		return deviceType;
	}
	
	public Integer sendCloudMessages(List<HashMap<String, Object>> pushUserList, String title, String body, HashMap<String, Object> dataMap) throws Exception {
		if(pushUserList.isEmpty()) {
			log.debug("result : Device User List is Empty");
		} else {
			URL url = new URL("https://fcm.googleapis.com/fcm/send");
			log.debug("firebaseApiKey : "+firebaseApiKey);
			
			
			HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
			httpURLConnection.setRequestMethod("POST");
			httpURLConnection.setRequestProperty("Content-Type", "application/json; UTF-8");
			httpURLConnection.setRequestProperty("Authorization", "key=" + firebaseApiKey.trim());
			httpURLConnection.setDoOutput(true);
			httpURLConnection.connect();
			String result = null;
			
			String sendList = "[";
			for(HashMap<String, Object> userInfo : pushUserList) {
				if(userInfo.get("DEVICE_CODE") != null && !userInfo.get("DEVICE_CODE").equals("") && !userInfo.get("DEVICE_CODE").equals("pythonConnectionSucc")) sendList += "\""+userInfo.get("DEVICE_CODE").toString()+"\", ";
			}
			sendList += "]";
			
			if(!sendList.equals("[]")) {
				JsonObject dataObj = new JsonObject();
				if(dataMap != null) {
					Iterator<String> mapIter = dataMap.keySet().iterator();
			        while(mapIter.hasNext()) {
			        	String key = mapIter.next();
			        	dataObj.addProperty(key, dataMap.get(key).toString());
			        }
				}
				
				String data = "{\"registration_ids\":"+sendList+", "+
					"\"priority\":\"high\","+
					"\"content_available\":true,"+
					"\"mutable_content\":true,"+
					"\"notification\":{\"title\":\""+title+"\", \"body\":\""+body+"\"}"+
					"\"data\":"+dataObj+
				"}";
				
				OutputStream outputStream = httpURLConnection.getOutputStream();
				BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream, "UTF-8"));
				writer.write(data);
				writer.close();
				outputStream.close();
				BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream(), "UTF-8"));
				
				String line = null;
				StringBuilder sb = new StringBuilder();
				
				while ((line = bufferedReader.readLine()) != null) { sb.append(line); }
				bufferedReader.close();
				httpURLConnection.disconnect();
				
				result = sb.toString();
				
				log.debug("Send CloudMessages Result : "+result);
			}
		}
		
		return 1;
	}
	
	public List<HashMap<String, Object>> connectFtpFileServer(List<HashMap<String, Object>> fileList) {
		FTPClient ftp = null;
		String newWorkingDir = fileServerPath+getToDate("");
		List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
		String fileRootPath = "http://"+fileServerUrl+":"+fileServerWebPort;
		
		try {
			log.debug("FTP Connecting..");
			ftp = new FTPClient(); 
			ftp.setControlEncoding("UTF-8"); 
			ftp.connect(fileServerUrl, Integer.parseInt(fileServerPort));
			
			int reply = ftp.getReplyCode();
			boolean replyCompletion = FTPReply.isPositiveCompletion(reply);
			
			if(!replyCompletion) {
				log.debug("Deny connections from server..");
				return null;
			}
			
			ftp.setSoTimeout(1000 * 10);
			ftp.login(fileServerUser, fileServerPassword); 
			ftp.enterLocalPassiveMode();
			
			if(!ftp.changeWorkingDirectory(getToDate(""))) {
				ftp.makeDirectory(getToDate(""));
				ftp.sendSiteCommand("chmod 705 "+getToDate(""));
				ftp.changeWorkingDirectory(getToDate(""));
				log.debug("Create Directory Complete");
			}
			
			for(HashMap<String, Object> fileMap : fileList) {
				FileInputStream fis = null;
				File uploadfile = new File(fileMap.get("realFilePath").toString());
				HashMap<String, Object> ftpFileMap = new HashMap<String, Object>();
				
				if(!uploadfile.exists()) {
					log.debug("File does not exist.");
					return null;
				} else if(fileMap.get("file") == null || fileMap.get("file").toString().equals("")) {
					log.debug("File name is incorrect.");
					return null;
				}
				
				ftp.setFileType(FTP.BINARY_FILE_TYPE);
				
				fis = new FileInputStream(uploadfile);
				boolean isSuccess = ftp.storeFile(fileMap.get("file").toString(), fis);
				
				if(isSuccess) {
					log.debug("File Upload Successful.");
					ftp.sendSiteCommand("chmod 705 "+fileMap.get("file").toString());
					
					log.debug("fileFullPath : "+fileRootPath+newWorkingDir.replace("/home", "")+"/"+fileMap.get("file").toString());
					log.debug("fileKey : "+fileMap.get("fileKey"));
					ftpFileMap.put("fileFullPath", fileRootPath+newWorkingDir.replace("/home", "")+"/"+fileMap.get("file").toString());
					ftpFileMap.put("fileKey", fileMap.get("fileKey"));
					ftpFileMap.put("originalFileName", fileMap.get("originalFileName"));
					result.add(ftpFileMap);
				} else {
					log.debug("Unable to upload file.");
					return null;
				}
				
				if(fis != null) {
					fis.close(); 

					if(uploadfile.delete()) log.debug("File deletion successful.");
					else {
						log.debug("Failed to delete file.");
						return null;
					}
				}
			}
			
			ftp.logout();
			if(ftp != null && ftp.isConnected()) ftp.disconnect();
			return result;
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				if(ftp != null && ftp.isConnected()) ftp.disconnect();
			} catch(Exception e) {
				e.printStackTrace();
				return null;
			}
		}
	}
	
	public String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
//        System.out.println(">>>> X-FORWARDED-FOR : " + ip);
 
        if(ip == null) {
			ip = request.getHeader("Proxy-Client-IP");
//			System.out.println(">>>> Proxy-Client-IP : " + ip);
        }
        
        if(ip == null) {
			ip = request.getHeader("WL-Proxy-Client-IP"); // 웹로직
//			System.out.println(">>>> WL-Proxy-Client-IP : " + ip);
        }
        
        if(ip == null) {
			ip = request.getHeader("HTTP_CLIENT_IP");
//			System.out.println(">>>> HTTP_CLIENT_IP : " + ip);
        }
        
        if(ip == null) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
//            System.out.println(">>>> HTTP_X_FORWARDED_FOR : " + ip);
        } 
        
        if(ip == null) ip = request.getRemoteAddr();
//        System.out.println(">>>> Result : IP Address : "+ip);
        
        return ip;
    }
	
    public int getOrientation(BufferedInputStream is) throws IOException {
        int orientation = 1;
        try {
        	Metadata metadata = ImageMetadataReader.readMetadata(is);
            //Metadata metadata = ImageMetadataReader.readMetadata(is, true);
              Directory directory = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
              //Directory directory = metadata.getDirectory(ExifIFD0Directory.class);
               try {
                    if(directory == null){
                    	orientation = 1;
                    }else {
                        orientation = directory.getInt(ExifIFD0Directory. TAG_ORIENTATION);
                    }
                    
              } catch (MetadataException me) {
                    System. out.println("Could not get orientation" );
              }
       } catch (ImageProcessingException e) {
              e.printStackTrace();
       }
        return orientation;
    }
    public BufferedImage rotateImageForMobile(InputStream is,int orientation) throws IOException {
        BufferedImage bi = ImageIO. read(is);
         if(orientation == 6){ //정위치
                return rotateImage(bi, 90);
        } else if (orientation == 1){ //왼쪽으로 눞였을때
                return bi;
        } else if (orientation == 3){//오른쪽으로 눞였을때
                return rotateImage(bi, 180);
        } else if (orientation == 8){//180도
                return rotateImage(bi, 270);      
        } else{
                return bi;
        }       
    }

    public BufferedImage rotateImage(BufferedImage orgImage,int radians) {
        BufferedImage newImage;
         if(radians==90 || radians==270){
               newImage = new BufferedImage(orgImage.getHeight(),orgImage.getWidth(),orgImage.getType());
        } else if (radians==180){
               newImage = new BufferedImage(orgImage.getWidth(),orgImage.getHeight(),orgImage.getType());
        } else{
                return orgImage;
        }
        Graphics2D graphics = (Graphics2D) newImage.getGraphics();
        graphics.rotate(Math. toRadians(radians), newImage.getWidth() / 2, newImage.getHeight() / 2);
        graphics.translate((newImage.getWidth() - orgImage.getWidth()) / 2, (newImage.getHeight() - orgImage.getHeight()) / 2);
        graphics.drawImage(orgImage, 0, 0, orgImage.getWidth(), orgImage.getHeight(), null );
        
         return newImage;
    }
	
	
	
}
