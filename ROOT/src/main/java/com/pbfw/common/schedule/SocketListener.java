package com.pbfw.common.schedule;

import java.net.Socket;

// 리스너 방문자 패턴을 위한 인터페이스
public interface SocketListener {
	public void run(Socket socket, String message);
}
