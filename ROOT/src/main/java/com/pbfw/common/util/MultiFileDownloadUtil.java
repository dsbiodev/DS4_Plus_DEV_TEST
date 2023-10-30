package com.pbfw.common.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class MultiFileDownloadUtil extends AbstractView {
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
	@Value("${file.basic.localpath}")
	private String fileUploadLoc;
	
	public MultiFileDownloadUtil() {
		setContentType("apllication/download; charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String fileNames = model.get("fileNames").toString();
		String zipFileName = model.get("zipFileName").toString();
		List<HashMap<String, Object>> fileList = commonUtil.jsonStringToList(fileNames);
		log.debug("------ fileList : "+fileList.toString());
		String zipFilePath = fileUploadLoc+"/tmpZipFile/";
		
		File desti = new File(zipFilePath);
		if(!desti.exists()) desti.mkdirs();
		
		File [] tempFileList = desti.listFiles();
		log.debug("------ tempFileList"+tempFileList.toString());
// 		temp 폴더 비우기
//		if(tempFileList.length > 0) {
//			for(int tmpIdx=0; tmpIdx<tempFileList.length; tmpIdx++) {
//				if(tempFileList[tmpIdx].isFile()) tempFileList[tmpIdx].delete();
//			}
//		}
		
        int size = 1024;
        byte[] buf = new byte[size];
        String outZipNm = zipFilePath+"/"+zipFileName;
        
        FileInputStream fis = null;
        ZipArchiveOutputStream zos = null;
        BufferedInputStream bis = null;
         
        try {
        	// Zip 파일생성
        	zos = new ZipArchiveOutputStream(new BufferedOutputStream(new FileOutputStream(outZipNm)));
        	for(int i=0; i<fileList.size(); i++) {
        		zos.setEncoding("UTF-8");
				
        		String thisFile = fileList.get(i).get("filePath").toString().replaceAll("/FileRootPath", fileUploadLoc);
        		String thisFileName = fileList.get(i).get("fileName").toString();
        		log.debug("------ thisFile : "+thisFile);
        		log.debug("------ thisFileName : "+thisFileName);
        		
        		File getFile = new File(thisFile);
        		fis = new FileInputStream(getFile);
				bis = new BufferedInputStream(fis,size);
				zos.putArchiveEntry(new ZipArchiveEntry(thisFileName));

				int len;
				while((len = bis.read(buf,0,size)) != -1) { zos.write(buf,0,len); }
				 
				bis.close();
				fis.close();
				zos.closeArchiveEntry();
            }
            zos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } finally {
            if( zos != null ) { zos.close(); }
            if( fis != null ) { fis.close(); }
            if( bis != null ) { bis.close(); }
            
            File zipFile = new File(outZipNm);
            if (zipFile.exists()) {
            	log.debug("zipFileName : "+zipFile.getName());
                log.debug("zipFileSize : "+zipFile.length());
                String sendFileName = URLEncoder.encode(zipFile.getName(), "UTF-8");
                
                response.setContentType(getContentType());
                response.setContentLength((int) zipFile.length());
                response.setHeader("Content-Disposition", "attachment; filename=\""+sendFileName+"\";");
                response.setHeader("Content-Transfer-Encoding", "binary");
                
                OutputStream out = response.getOutputStream();
                fis = null;
                
                try {
                    fis = new FileInputStream(zipFile);
                    FileCopyUtils.copy(fis, out);
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if(fis != null) { fis.close(); }
                    zipFile.delete();
                }
                out.flush();
            }
        }
    }
}
