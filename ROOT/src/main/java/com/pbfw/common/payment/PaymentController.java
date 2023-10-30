package com.pbfw.common.payment;

import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Hex;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.pbfw.common.service.CommonService;
import com.pbfw.common.util.CommonUtil;

import kr.co.nicepay.module.lite.NicePayWebConnector;


@Controller
public class PaymentController{
	Logger log = LoggerFactory.getLogger(this.getClass());

	@Resource(name="commonService")
	CommonService commonService;
	
	@Resource(name="commonUtil")
	CommonUtil commonUtil;
	
	String merchantKey      = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==";   // 상점키
	String merchantID       = "nicepay00m";    
	SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");
	

//	String logPath = "C:/project/Dongsung/src/main/webapp/WEB-INF/";   		// 모듈 WEB-INF Path 설정
	String logPath = "/root/apache-tomcat-8.5.60/webapps/ROOT/WEB-INF";   	// 모듈 WEB-INF Path 설정
	
	// SHA-256 형식으로 암호화
	public class DataEncrypt{
		MessageDigest md;
		String strSRCData = "";
		String strENCData = "";
		String strOUTData = "";

		public DataEncrypt(){ }
		public String encrypt(String strData){
			String passACL = null;
			MessageDigest md = null;
			try{
				md = MessageDigest.getInstance("SHA-256");
				md.reset();
				md.update(strData.getBytes());
				byte[] raw = md.digest();
				passACL = encodeHex(raw);
			}catch(Exception e){
				System.out.print("암호화 에러" + e.toString());
		    }
			return passACL;
		}
		
		public String encodeHex(byte [] b){
			char [] c = Hex.encodeHex(b);
			return new String(c);
		}
	}
	
	@RequestMapping(value="/payment/payStart.do")
	public @ResponseBody HashMap<String, Object> payStart(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		DataEncrypt sha256Enc 	  = new DataEncrypt();
		String encryptData    	  = sha256Enc.encrypt(yyyyMMddHHmmss.format(new Date()) + merchantID + requestMap.get("Amt") + merchantKey);
		requestMap.put("MallIP", commonUtil.getIpAddress(request));
		requestMap.put("EdiDate", yyyyMMddHHmmss.format(new Date()));
		requestMap.put("EncryptData", encryptData);
		requestMap.put("MID", merchantID);
		return requestMap;
	}
	

	@RequestMapping(value="/payment/payFinish.do")
	public @ResponseBody HashMap<String, Object> payFinish(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		NicePayWebConnector connector = new NicePayWebConnector();
		connector.setNicePayHome(logPath);                                  // 로그 디렉토리 생성
		connector.setRequestData(request);                                  // 요청 페이지 파라메터 셋팅
		connector.addRequestData("MID", merchantID);                      	// 상점아이디
		connector.addRequestData("actionType", "PY0");                      // 서비스모드 설정(결제 서비스 : PY0 , 취소 서비스 : CL0)
		connector.addRequestData("MallIP", request.getRemoteAddr());        // 상점 고유 ip
		connector.requestAction();
		
		String resultCode    = connector.getResultData("ResultCode");       // 결과코드 (정상 결과코드:3001)
		String resultMsg     = connector.getResultData("ResultMsg");        // 결과메시지
		String authDate      = connector.getResultData("AuthDate");         // 승인일시 (YYMMDDHH24mmss)
		String authCode      = connector.getResultData("AuthCode");         // 승인번호
		String buyerName     = connector.getResultData("BuyerName");        // 구매자명
		String mallUserID    = connector.getResultData("MallUserID");       // 회원사고객ID
		String payMethod     = connector.getResultData("PayMethod");        // 결제수단
		String mid           = connector.getResultData("MID");              // 상점ID
		String tid           = connector.getResultData("TID");              // 거래ID
		String moid          = connector.getResultData("Moid");             // 주문번호
		String amt           = connector.getResultData("Amt");              // 금액
		String goodsName     = connector.getResultData("GoodsName");        // 금액
		String cardCode      = connector.getResultData("CardCode");         // 카드사 코드
		String cardName      = connector.getResultData("CardName");         // 결제카드사명
		String cardQuota     = connector.getResultData("CardQuota");        // 카드 할부개월 (00:일시불,02:2개월)
		String bankCode      = connector.getResultData("BankCode");         // 은행 코드
		String bankName      = connector.getResultData("BankName");         // 은행명
		String rcptType      = connector.getResultData("RcptType");         // 현금 영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
		String rcptAuthCode  = connector.getResultData("RcptAuthCode");     // 현금영수증 승인 번호
		String rcptTID       = connector.getResultData("RcptTID");          // 현금 영수증 TID   
		String carrier       = connector.getResultData("Carrier");          // 이통사구분
		String dstAddr       = connector.getResultData("DstAddr");          // 휴대폰번호
		String vbankBankCode = connector.getResultData("VbankBankCode");    // 가상계좌은행코드
		String vbankBankName = connector.getResultData("VbankBankName");    // 가상계좌은행명
		String vbankNum      = connector.getResultData("VbankNum");         // 가상계좌번호
		String vbankExpDate  = connector.getResultData("VbankExpDate");     // 가상계좌입금예정일
		
		boolean paySuccess = false;
		if(payMethod.equals("CARD")){
			if(resultCode.equals("3001")) paySuccess = true;	                // 신용카드(정상 결과코드:3001)
		}else if(payMethod.equals("BANK")){
			if(resultCode.equals("4000")) paySuccess = true;	                // 계좌이체(정상 결과코드:4000)	
		}else if(payMethod.equals("CELLPHONE")){
			if(resultCode.equals("A000")) paySuccess = true;	                // 휴대폰(정상 결과코드:A000)
		}else if(payMethod.equals("VBANK")){	
			if(resultCode.equals("4100")) paySuccess = true;	                // 가상계좌(정상 결과코드:4100)
		}else if(payMethod.equals("SSG_BANK")){										
			if(resultCode.equals("0000")) paySuccess = true;						// SSG은행계좌(정상 결과코드:0000)
		}
		
		if(paySuccess) {
	    	requestMap.put("resultCode", resultCode);
			requestMap.put("resultMsg", resultMsg);
			requestMap.put("authDate", authDate);
			requestMap.put("authCode", authCode);
			requestMap.put("buyerName", buyerName);
			requestMap.put("buyerTel", requestMap.get("BuyerTel"));
			requestMap.put("mallUserID", mallUserID);
			requestMap.put("goodsName", goodsName);
			requestMap.put("mid", mid);
			requestMap.put("tid", tid);
			requestMap.put("moid", moid);
			requestMap.put("amt", amt);
			requestMap.put("cardCode", cardCode);
			requestMap.put("cardName", cardName);
			requestMap.put("cardQuota", cardQuota);
			requestMap.put("bankCode", bankCode);
			requestMap.put("bankName", bankName);
			requestMap.put("rcptType", rcptType);
			requestMap.put("rcptAuthCode", rcptAuthCode);
			requestMap.put("rcptTID", rcptTID);
			requestMap.put("carrier", carrier);
			requestMap.put("dstAddr", dstAddr);
			requestMap.put("vbankBankCode", vbankBankCode);
			requestMap.put("vbankBankName", vbankBankName);
			requestMap.put("vbankNum", vbankNum);
			requestMap.put("vbankExpDate", vbankExpDate);
	    	requestMap.put("resultCode", resultCode);
			requestMap.put("resultMsg", resultMsg);
			requestMap.put("paySuccess", paySuccess);
		}else {
	    	requestMap.put("resultCode", resultCode);
			requestMap.put("resultMsg", resultMsg);
			requestMap.put("paySuccess", paySuccess);
		}
		
		return requestMap;
	}

}