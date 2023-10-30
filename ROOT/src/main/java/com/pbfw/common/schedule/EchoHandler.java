package com.pbfw.common.schedule;

import java.util.ArrayList;
import java.util.List;

import javax.websocket.server.ServerEndpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;


//@Controller
//@ServerEndpoint(value="/websocket")
public class EchoHandler extends TextWebSocketHandler {

	// 세션을 모두 저장한다.
	// 방법 1 : 1:1 채팅
	// private Map<String, WebSocketSession> sessions = new HashMap<String,
	// WebSocketSession>();
	// 방법 2 : 전체 채팅
	private List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	Logger log = LoggerFactory.getLogger(this.getClass());
	
//	public EchoHandler() {
//        System.out.println("create SocketHandler instance!");
//	}

	/**
	 * 클라이언트 연결 이후에 실행되는 메소드
	 * WebSocket 연결이 열리고 사용이 준비될 때 호출
	 */
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// 맵을 쓸때 방법
		// sessions.put(session.getId(), session);
		// List쓸때 방법
		System.out.println("afterConnectionEstablished");
		sessionList.add(session);
		// 0번째 중괄호에 session.getId()을 넣으라는뜻
//		System.out.println("{} 연결됨" + session.getId());
	}

	/**
	 * 클라이언트가 웹소켓 서버로 메시지를 전송했을 때 실행되는 메소드
	 * 클라이언트로부터 메시지가 도착했을 때 호출
	 */
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

		// 0번째에 session.getId() 1번째에 message.getPayload() 넣음
		System.out.println("{}로 부터 {} 받음" + session.getId() + message.getPayload());
		// 연결된 모든 클라이언트에게 메시지 전송 : 리스트 방법
		for (WebSocketSession sess : sessionList) {
			sess.sendMessage(new TextMessage("echo:" + message.getPayload()));
		}

	}
	
	/**
	 * WebSocketHandler가 부분 메시지를 처리할 때 호출
	 */
	public boolean supportsPartialMessages() {
		// TODO Auto-generated method stub
		return super.supportsPartialMessages();
	}

	public void onChangeSensorState() {
		EchoHandler echo = new EchoHandler();

	}

	/**
	 * 클라이언트 연결을 끊었을 때 실행되는 메소드
	 */
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// List 삭제
		sessionList.remove(session);
		// Map 삭제
		System.out.println("{} 연결 끊김." + session.getId());
	}

}
