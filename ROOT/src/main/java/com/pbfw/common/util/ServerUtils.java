package com.pbfw.common.util;


import java.io.IOException;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.pbfw.common.schedule.SocketServer;

public class ServerUtils implements ServletContextListener {
	
	
    // 웹 어플리케이션 종료 메소드
    public void contextDestroyed(ServletContextEvent arg0){
        // 웹 어플리케이션 종료 시 처리할 로직
//		try {
//			SocketServer.tomcatClose();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			System.out.println("server down");
//			e.printStackTrace();
//		}
		
    }

	public void contextInitialized(ServletContextEvent sce) {
//      // 웹 어플리케이션 시작 시 처리할 로직
	}
 
}


