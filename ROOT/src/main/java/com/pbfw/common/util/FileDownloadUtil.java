package com.pbfw.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;


public class FileDownloadUtil extends AbstractView {
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	public FileDownloadUtil() {
		setContentType("apllication/download; charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
        File file = (File) model.get("downloadFile");
        String fileName = model.get("fileName").toString();
        
        log.debug("[ FileName ] : " + fileName);
        response.setContentType(getContentType());
        response.setContentLength((int) file.length());
        
        fileName = URLEncoder.encode(fileName, "UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\""+fileName+"\";");
        response.setHeader("Content-Transfer-Encoding", "binary");

        OutputStream out = response.getOutputStream();
        FileInputStream fis = null;
        
        try {
            fis = new FileInputStream(file);
            FileCopyUtils.copy(fis, out);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(fis != null) {
                try {
                    fis.close();
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
            }
        }
        out.flush();
	}
}
