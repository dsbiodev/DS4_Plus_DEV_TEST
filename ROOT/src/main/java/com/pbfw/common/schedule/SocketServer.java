package com.pbfw.common.schedule;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;


@Service("SocketServer")
public class SocketServer extends ServerSocket {
	Logger log = LoggerFactory.getLogger(this.getClass());
	
	// 	싱글톤 패턴으로 구현한다.
	private static SocketServer instance = null;
	public static SocketServer getInstance() throws IOException {
		if (instance == null) {
			instance = new SocketServer();
		}
		return instance;
	}

	static SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
	
	// 다중 접속을 위한 client 관리를 한다.
//	public static List<Socket> clients = new ArrayList<>();
	public static List<HashMap<String, Object>> clientsRaspList= new ArrayList<HashMap<String, Object>>();
	
	// 소켓 메시지 대기를 위한 스레드 풀이다.
	// ExecutorService는 병렬작업 시 여러개의 작업을 효율적으로 처리하기 위해 제공되는 JAVA의 라이브러리이다.
	private final static ExecutorService receivePool = Executors.newCachedThreadPool();
	private final static ExecutorService serverPool = Executors.newSingleThreadExecutor();
	
	// 외부에서 방문자 패턴으로 리스너를 등록할 수 있게 한다.
//	private final List<SocketListener> listeners = new ArrayList<>();
	private static ObjectMapper mapper = new ObjectMapper();
	
	private SocketServer() throws IOException {
		super();
		// 소켓은 9999포트로 오픈한다.(만약 9999포트를 사용하게 된다면 다른 포트로 수정하면 된다.)
		InetSocketAddress ipep = new InetSocketAddress(9999);
		//소켓에 포트번호를 부여한다.
		super.bind(ipep);
		
		// 싱글 스레드 풀이다. 서버는 하나이기 때문에 싱글 스레드 풀을 사용한다.
		serverPool.execute(() -> {
			try {
				// 무한 루프로 클라이언트를 대기를 한다.
				while (true) {
					// accept()함수를 호출해 클라이언트 연결에 대한 새로운 소켓을 생성
					Socket client = super.accept(); 
					// 메시지 대기를 한다.
					receive(client);
				}
			} catch (Throwable e) {
				System.out.println("socket Connection Error" + ", Con Date = " + date.format(new Date()));
				serverPool.shutdownNow();
				e.printStackTrace();
			}
		});
	}
	
	private void receive(Socket client) {
		System.out.println("Cleint Connection = " + client + ", Con Date = " + date.format(new Date()));
		// 위 캐쉬 스레드 풀을 사용한다.
		// execute() ->
		// - 작업 처리 결과를 반환하지 않는다.
		// - 작업 처리 도중 예외가 발생하면 스레드가 종료되고 해당 스레드는 스레드 풀에서 제거된다. 
		// - 다른 작업을 처리하기 위해 새로운 스레드를 생성한다.
		receivePool.execute(() -> {
			// 클라이언트와 메시지 구조은 먼저 4byte의 문자사이즈를 받고 그 크기만큼 문자 메시지가 오는 것이다.
			ByteBuffer byteBuffer = ByteBuffer.allocate(4);
			try (InputStream receiver = client.getInputStream()) {
				while (!Thread.interrupted()) {
					// 메시지 길이를 받는다. (리틀 엔디언)
					receiver.read(byteBuffer.array(), 0, 4);
					// 메시지 길이 만큼 배열을 선언하고 받는다.
					byte[] data = new byte[byteBuffer.getInt()];
					// receiver.read 이후 data 메세지를 읽을 수 있음
					receiver.read(data, 0, data.length);
					String msg = new String(data, "UTF-8");
					HashMap<String, Object> tmp = new HashMap<String, Object>();
					tmp.put("raspNo", msg);
					tmp.put("client", client);
					clientsRaspList.add(tmp);
					System.out.println("Client Add Succ = " + client + " , RaspNo = " + msg + ", Con Date = " + date.format(new Date()));
				}
			} catch (Throwable e) {
//				System.out.println("ReceivePool Error" + ", Con Date = " + date.format(new Date()));
//				e.printStackTrace();
				try {
					System.out.println("Client End = " + client + ", Con Date = " + date.format(new Date()));
					removeRaspSocket(client);
					
					client.close();
					byteBuffer.clear();
				} catch (IOException x) {
					System.out.println("Socket InputStream Error" + x + ", Con Date = " + date.format(new Date()));
					receivePool.shutdownNow();
				}
			}
		});
	}
		

	// rasp_client socket 삭제
	// remove바로 못하는 이유가 socket object로 map을 찾아서 삭제해줘야해
	public void removeRaspSocket(Socket socket) throws IOException {
		System.out.println("\n**************** Socket removeRaspSocket Start ****************");
		System.out.println(socket);
		System.out.println("*****************************************************");
		
		// 라즈베리 리스트 복사
		List<HashMap<String, Object>> clientsCopy = new ArrayList<>();
		clientsCopy.addAll(clientsRaspList);
		Iterator<HashMap<String, Object>> raspList = clientsCopy.iterator();
		try {
//			throw new NullPointerException("text");
			while (raspList.hasNext()) {
				HashMap<String, Object> map = raspList.next();
				Socket tmpClient = (Socket) map.get("client");
				if(socket.getPort() == tmpClient.getPort()) {
					raspList.remove();
					System.out.println("Socket Remove Succ = " + socket + ", Con Date = " + date.format(new Date()));
				}
			}
			clientsRaspList.clear();
			clientsRaspList.addAll(clientsCopy);
		} catch(Exception e) {
			System.out.println("\nSocket Fail to Remove = "+ e +", Exception Socket = " + socket + "\n");
			removeRaspSocket2(socket, 3);
		}
		
		System.out.println("**************** Socket removeRaspSocket End ****************\n");
	}
	
	public void removeRaspSocket2(Socket socket, int num) throws IOException {
		
		// 탈출
		if(num <= 0) return ;

		System.out.println("\n**************** Recursive Socket removeRaspSocket2 Start, num = "+ num +" ****************");
		System.out.println(socket);
		System.out.println("*****************************************************\n");
		

		// 라즈베리 리스트 복사
		List<HashMap<String, Object>> clientsCopy = new ArrayList<>();
		clientsCopy.addAll(clientsRaspList);
		
		Iterator<HashMap<String, Object>> raspList = clientsCopy.iterator();
		try {
			while (raspList.hasNext()) {
				HashMap<String, Object> map = raspList.next();
				Socket tmpClient = (Socket) map.get("client");
				if(socket.getPort() == tmpClient.getPort()) {
					raspList.remove();
					System.out.println("Socket Remove Succ = " + socket + ", Con Date = " + date.format(new Date()));
				}
			}
			
			clientsRaspList.clear();
			clientsRaspList.addAll(clientsCopy);
			System.out.println("\n**************** Recursive Socket removeRaspSocket2 End, num = "+ num +" ****************");
		}  catch(Exception e) {
			System.out.println("\nSocket Fail to Remove = "+ e +", Exception Socket = " + socket + "\n");
			System.out.println("\n**************** Recursive Socket removeRaspSocket2 End, num = "+ num +" ****************");
			if(setTimeout(1000)) removeRaspSocket2(socket, num-1);
		}
	}
	
	
	// 전체 클라이언트에게 메시지를 보낸다.
	public void send(HashMap<String, Object> list) throws JsonProcessingException {
		System.out.println("\n**************** Socket Send Start ****************");
		System.out.println(list);
		System.out.println("***************************************************");
		
		List<Socket> rmClients = new ArrayList<>();
		List<HashMap<String, Object>> tmpList = (List<HashMap<String, Object>>) list.get("list");

		
		// 라즈베리 리스트 복사
		List<HashMap<String, Object>> clientsCopy = new ArrayList<>();
		clientsCopy.addAll(clientsRaspList);
		
		
		try {
			if(!list.get("list").toString().equals("[]") && clientsCopy.size() > 0) {
				for(HashMap<String, Object> selMap : tmpList) {
					Iterator<HashMap<String, Object>> raspList = clientsCopy.iterator();
					while (raspList.hasNext()) {
						HashMap<String, Object> map = raspList.next();
						if(map != null) {
							if(map.get("raspNo") != null && selMap.get("RASPBERRY_CONNECTION_NO") != null && map.get("raspNo").toString().equals(selMap.get("RASPBERRY_CONNECTION_NO").toString())) {
								Socket tmpClient = (Socket) map.get("client");
								if(send(tmpClient, mapper.writeValueAsString(selMap)) == 0) {
									System.out.println("Socket Send IOException Error" + ", Con Date = " + date.format(new Date()));
									rmClients.add(tmpClient);
								}else {
									System.out.println("Socket Send Succ = " + tmpClient + ", Con Date = " + date.format(new Date()));
								}
							}
						}
					}
				}
			}
		} catch(Exception e) {
			System.out.println("Socket Fail to Send = "+ e +", Exception List = " + list + "\n");
			if(setTimeout(1000)) send2(list,3);
		}
				
		if(rmClients.size() > 0) {
			try {
				for(Socket socket : rmClients) {
					removeRaspSocket(socket);
				}
			} catch (IOException e) {
				System.out.println("Socket Send rmClients Error = " + e + ", Date = " + date.format(new Date()));
			}
			
		}

		System.out.println("\n**************** Socket Send End ******************");
	}
	
	
	
	// 전체 클라이언트에게 메시지를 보낸다.
	public void send2(HashMap<String, Object> list, int num) throws JsonProcessingException {
		
		// 탈출
		if(num <= 0) return ;
		
		System.out.println("\n**************** Recursive Socket Send Start, Num = "+ num +" ****************");
		List<Socket> rmClients = new ArrayList<>();
		List<HashMap<String, Object>> tmpList = (List<HashMap<String, Object>>) list.get("list");	
		

		// 라즈베리 리스트 복사
		List<HashMap<String, Object>> clientsCopy = new ArrayList<>();
		clientsCopy.addAll(clientsRaspList);
		try {
			if(!list.get("list").toString().equals("[]") && clientsCopy.size() > 0) {
//				throw new ConcurrentModificationException("text");
				for(HashMap<String, Object> selMap : tmpList) {
					Iterator<HashMap<String, Object>> raspList = clientsCopy.iterator();
					while (raspList.hasNext()) {
						HashMap<String, Object> map = raspList.next();
						if(map != null) {
							if(map.get("raspNo") != null && selMap.get("RASPBERRY_CONNECTION_NO") != null && map.get("raspNo").toString().equals(selMap.get("RASPBERRY_CONNECTION_NO").toString())) {
								Socket tmpClient = (Socket) map.get("client");
								if(send(tmpClient, mapper.writeValueAsString(selMap)) == 0) {
									System.out.println("Socket Send IOException Error" + ", Con Date = " + date.format(new Date()));
									rmClients.add(tmpClient);
								}else {
									System.out.println("Socket Send Succ = " + tmpClient + ", Con Date = " + date.format(new Date()));
								}
							}
						}
					}
				}
			}
			System.out.println("\n**************** Recursive Socket Send End, Num = "+ num+" ******************");
		} catch(Exception e) {
			System.out.println("\nRecursive Socket Fail to Send = "+ e +", Exception List = " + list + "\n");
			System.out.println("\n**************** Recursive Socket Send End, Num = "+ num+" ******************");
			if(setTimeout(1000)) send2(list, num-1);
		}
		
		if(rmClients.size() > 0) {
			try {
				for(Socket socket : rmClients) {
					removeRaspSocket(socket);
				}
			} catch (IOException e) {
				System.out.println("Recursive Socket Send rmClients Error = " + e + ", Date = " + date.format(new Date()));
			}
		}
	}
	
	
	// socket 특정 클라이언트에게 메시지를 보낸다.
	public int send(Socket client, String msg) {
		System.out.println("Socket Send Client = " + client + " ,Msg = " + msg + ", Con Date = " + date.format(new Date()));
		byte[] data = msg.getBytes();
		ByteBuffer buf = ByteBuffer.allocate(4);
		buf.putInt(data.length);
		OutputStream sender = null;
		try {
			sender = client.getOutputStream();
			sender.write(buf.array());
			sender.write(data);
			sender.flush();
			return 1;
		} catch (IOException e) {
			System.out.println("Socket Fail to Send Msg = " + e + ", Con Date = " + date.format(new Date()));
			return 0;
		} 
	}
	
	
	
	// 소켓 핑퐁
	public void sendPingPong() throws JsonProcessingException {
//		System.out.println("\n**************** Socket PingPong Start " + date.format(new Date()) + "****************\n");
//		List<HashMap<String, Object>> clientsCopy = new ArrayList<>();
//		clientsCopy.addAll(clientsRaspList);
//		List<HashMap<String, Object>> clientsNewList = new ArrayList<>();
//		if(clientsCopy.size() > 0) {
//			System.out.println("List clientsRaspList = " + clientsCopy.size());
//			Iterator<HashMap<String, Object>> raspList = clientsCopy.iterator();
//			int index = 0;
//			while (raspList.hasNext()) {
//				try {
//					HashMap<String, Object> map = raspList.next();
//					Socket tmpClient = (Socket) map.get("client");
//					HashMap<String, Object> tmpMap = new HashMap<String, Object>();
//					tmpMap.put("RASPBERRY_CONNECTION_NO", map.get("raspNo").toString());
//					tmpMap.put("FLAG", "11");
//					if(send(tmpClient, mapper.writeValueAsString(tmpMap)) == 0) {
//						System.out.println("PingPong Send IOException Error = " + tmpClient + ", Con Date = " + date.format(new Date()));
//					}else {
//						System.out.println("PingPong Send Succ tmpClient = " + tmpClient + ", Index = " + (++index) + " Con Date = " + date.format(new Date()));
//						clientsNewList.add(map);
//					}
//				} catch(Exception e) {
//					System.out.println("\nSocket Fail to PingPong = " + e);
//				}
//			}
//		}
//		clientsRaspList.clear();
//		clientsRaspList.addAll(clientsNewList);
//		System.out.println("PingPong clientsCopy = " + clientsCopy.size());
//		System.out.println("PingPong clientsNewList = " + clientsNewList.size());
//		System.out.println("\n**************** Socket PingPong End ****************\n");
		
		

		

		System.out.println("\n**************** Socket PingPong Start " + date.format(new Date()) + "****************\n");
		List<HashMap<String, Object>> clientsCopy = new ArrayList<>();
		clientsCopy.addAll(clientsRaspList);
		List<HashMap<String, Object>> clientsDupList = new ArrayList<>();
		List<HashMap<String, Object>> clientsNewList = new ArrayList<>();
		
		

		if(clientsCopy.size() > 0) {
			System.out.println("List clientsRaspList = " + clientsCopy.size());
			Iterator<HashMap<String, Object>> raspList = clientsCopy.iterator();
			while (raspList.hasNext()) {
				HashMap<String, Object> map = raspList.next();
				if(!clientsDupList.contains(map)) {
					clientsDupList.add(map);
				}
			}
			System.out.println("***** End Dup remove *****");
		}
		
		
		
		if(clientsDupList.size() > 0) {
			System.out.println("List clientsDupList = " + clientsDupList.size());
			Iterator<HashMap<String, Object>> raspList = clientsDupList.iterator();
			int index = 0;
			while (raspList.hasNext()) {
				try {
					HashMap<String, Object> map = raspList.next();
					Socket tmpClient = (Socket) map.get("client");
					HashMap<String, Object> tmpMap = new HashMap<String, Object>();
					tmpMap.put("RASPBERRY_CONNECTION_NO", map.get("raspNo").toString());
					tmpMap.put("FLAG", "11");
					if(send(tmpClient, mapper.writeValueAsString(tmpMap)) == 0) {
						System.out.println("PingPong Send IOException Error = " + tmpClient + ", Con Date = " + date.format(new Date()));
					}else {
						System.out.println("PingPong Send Succ tmpClient = " + tmpClient + ", Index = " + (++index) + " Con Date = " + date.format(new Date()));
						clientsNewList.add(map);
					}
				} catch(Exception e) {
					System.out.println("\nSocket Fail to PingPong = " + e);
				}
			}
		}
		

		clientsRaspList.clear();
		clientsRaspList.addAll(clientsNewList);
		System.out.println("PingPong clientsCopy = " + clientsCopy.size());
		System.out.println("PingPong clientsNewList = " + clientsNewList.size());
		System.out.println("\n**************** Socket PingPong End ****************\n");
		
	}
	
	
	
	public void sendSocketTest() {
		System.out.println("\n**************** sendSocketTest " + date.format(new Date()) + "****************\n");
		
		
	}
	
	

	// 서버 종료시 소켓 종료하기
	public void tomcatClose() throws IOException {
		System.out.println("close");
	}
	
	// setTimeout 
	public Boolean setTimeout(int delayTime) {
		long now = System.currentTimeMillis();
       	long currentTime = 0;
       	while( currentTime - now< delayTime) { currentTime  = System.currentTimeMillis(); }
       	return true;
	}
		
 }

