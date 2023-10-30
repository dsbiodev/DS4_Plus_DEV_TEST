//package com.pbfw.common.schedule;
//
//import java.io.IOException;
//
//import javax.servlet.ServletConfig;
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServlet;
//
//
//public class InitServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//
//	public InitServlet() {
//
//	}
//
//	public void init(ServletConfig config) throws ServletException {
//		super.init(config);
//		try {
//			// 서버가 기동되면 소켓 서버를 기동한다.
//			SocketServer server = SocketServer.getInstance();
//			
//			// 리스너를 등록한다.
//			server.addListener((client, msg) -> {
//				
//				System.out.println("server.addListener");
////				 메시지를 받으면 echo를 붙혀서 재전송한다.
//				String sendmsg = "echo : " + msg;
//				server.send(client, sendmsg);
//			});
//			
//		} catch (IOException e) {
//			throw new ServletException(e);
//		}
//	}
//}
