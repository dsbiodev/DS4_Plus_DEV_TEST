<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<head>
	<jsp:include page="/WEB-INF/jsp/common/title.jsp"></jsp:include>
	<script src="https://web.nicepay.co.kr/v3/webstd/js/nicepay-2.0.js" language="javascript"></script>
</head>
<script>
	$(function() {
		var _goods = getParameterByName('goods');
		$('input[name=goods]').val(_goods);
		$('.phone').phoneFomatter();
		
		if(atob(_goods) == 190) {
			$('.goods').text("프리미엄 190");
			$('.goods-price').text("1,900,000원");
			$('.vat').text("190,000원");
			$('.total-price').text("2,090,000원");
			

			$('input[name=GoodsName]').val("프리미엄 190");
			$('input[name=Amt]').val("2090000");
			
		}else if(atob(_goods) == 290) {
			$('.goods').text("프리미엄 290");
			$('.goods-price').text("2,900,000원");
			$('.vat').text("290,000원");
			$('.total-price').text("3,190,000원");
			
			$('input[name=GoodsName]').val("프리미엄 290");
			$('input[name=Amt]').val("3190000");
			
		}else {
			$('.goods').text("프리미엄 390");
			$('.goods-price').text("3,900,000원");
			$('.vat').text("390,000원");
			$('.total-price').text("4,290,000원");
			
			$('input[name=GoodsName]').val("프리미엄 390");
			$('input[name=Amt]').val("4290000");
		}
		
		$('input[name=check]').pbCheckbox({ color:'orange' });
		$('.btn-can').on('click', function() { history.go(-1); })
		$('.btn-pay').on('click', function() { 
			if(!$('input[name=check]:checked').val()) return alert("약관에 동의해 주세요.");
// 			$('input[name=Amt]').val("100");
			$.pb.ajaxCallHandler('/payment/payStart.do', { Amt:$('input[name=Amt]').val() }, function(data) {
				$('input[name=BuyerName]').val($('.name').val());
				$('input[name=BuyerTel]').val($('.phone').val());
				$('input[name=MallIP]').val(data.MallIP);
				$('input[name=EncryptData]').val(data.EncryptData);
				$('input[name=EdiDate]').val(data.EdiDate);
				$('input[name=MID]').val(data.MID);
	         	nicepayStart();
			});
		});
		
	});
	
	function nicepayStart() {
		goPay(document.payForm);
	}
	
	// 결제 취소시 호출하게 되는 함수
	function nicepayClose() {
		alert("결제가 취소 되었습니다");
	}
	
	// 카드사 인증후 결제 요청시 호출되는 함수
	function nicepaySubmit() {
    	var _formData = new FormData($('form')[0]);
		$.pb.ajaxUploadForm('/payment/payFinish.do', _formData, function(result) {
			if(result.paySuccess) document.payForm.submit();
			else nicepayClose();
		}, true);
	}
		
</script>
<style>
	.contents-wrap { display: flex; justify-content: center; align-items: center; flex-direction: column; overflow-x: hidden; font-family: NotoSansCJKkr; }
	.head { background-image: url("/resources/img/img_payment.png"); background-size: 100% 100%; width: 1920px; height: 400px; }
	.wrap { width: 1000px; margin: 25px 0 40px; padding: 40px 0px 40px 40px; border: solid 1px #e1e1e1; background-color: #ffffff; }
	.wrap .title { height: 29px; margin: 0 47px 20px 0; font-size: 20px; font-weight: bold;  line-height: 1.45; text-align: left; color: #000000; }
	.wrap .box { display: flex; width:100%; }
	.wrap .box .text { width: 100px; height: 27px; font-size: 18px; margin: 11px 20px; font-weight: 500; text-align: left; color: #000000; }
	.wrap .box .text.colon { width: 143px; position: relative; }
	.wrap .box .text.colon:after { content: ":"; position: absolute; left: 150px; }
	.wrap .box input { width: 551px; height: 50px; margin: 0px 0 20px 47px; padding: 12px 5px 11px 16px; border: solid 1px #b1b1b1; background-color: #ffffff; font-size: 18px; }
	.wrap .box .select { margin: 11px 20px; font-size: 18px; font-weight: 500; color: #ff730f; }
	.text2 { margin: 0px 0 0px 17px; font-size: 18px; text-align: left; color: #000000; }
  	.btn-box { display: flex; justify-content: center; align-items: center; }
  	.btn-box .btn-pay { width: 296px; height: 57px; margin: 40px 25px 0 0px; border-radius: 4px; background-color: #ff730f; color:#FFF; font-size: 18px; }
  	.btn-box .btn-can { width: 296px; height: 57px; margin: 40px 0 0 25px; border-radius: 4px; background-color: #b1b1b1; color:#FFF; font-size: 18px; }
</style>


<form name="payForm" action="/paymentFinish">
	<input type="hidden" name="goods" value="">
	
	<input type="hidden" name="PayMethod" value="CARD,BANK">
	<input type="hidden" name="BuyerName" value="">
	<input type="hidden" name="BuyerTel" value="">
	<input type="hidden" name="GoodsName" value="" placeholder="필수 상품명">
	<input type="hidden" name="GoodsCnt" value="1" placeholder="필수 1개로 고정">
	<input type="hidden" name="VbankExpDate" value="" placeholder="가상계좌 결제 시 필수 값입니다.">
	<input type="hidden" name="Amt" value="">
	<input type="hidden" name="MID" value="">
	<!-- IP -->
	<input type="hidden" name="MallIP" value="">     		<!-- 상점서버IP-->
	<!-- 옵션 -->
	<input type="hidden" name="CharSet" value="utf-8">		<!-- 인코딩 설정 -->
	<input type="hidden" name="BuyerEmail" value="">		<!-- 구매자 이메일 -->
	<input type="hidden" name="GoodsCl" value="1">         <!-- 상품구분(실물(1),컨텐츠(0))-->
	<input type="hidden" name="TransType" value="0">      	<!-- 일반(0)/에스크로(1)-->
	<!-- 변경 불가능 -->
	<input type="hidden" name="EdiDate" value="">         	<!-- 전문 생성일시-->
	<input type="hidden" name="EncryptData" value="">      <!-- 해쉬값	 -->
 	<input type="hidden" name="TrKey" value="">        	<!-- 필드만 필요   -->
 	
 	
 	<input type="hidden" name="AuthResultCode" value="">
 	<input type="hidden" name="AuthResultMsg" value="">
 	<input type="hidden" name="TID" value="">

</form>
<div class="contents-wrap">
	<div class="head"></div>

	<div class="wrap">
		<div class="title">신청자 정보 입력</div>
		<div class="box">
			<div class="text">신청자</div>
			<input type="text" class="name" maxlength="20" value="">
		</div>
		<div class="box">
			<div class="text">전화번호</div>
			<input type="text" class="phone" value="">
		</div> 
	</div>

	<div class="wrap">
		<div class="title">결제상품</div>
		
		<div class="box">
			<div class="text colon">상품명</div>
			<div class="select goods"></div>
		</div>
	
		<div class="box">
			<div class="text colon">상품가격</div>
			<div class="select goods-price"></div>
		</div>
		
		<div class="box">
			<div class="text colon">부가세</div>
			<div class="select vat"></div>
		</div>
		
		<div class="box">
			<div class="text colon">총 결제금액</div>
			<div class="select total-price"></div>
		</div>
		
		<div class="title" style="margin-top: 39px;" >규정 및 약관 동의</div>
		<div class="box">
			<input type="checkbox" name="check"/>
			<div class="text2">결제할 서비스 내용을 확인하였으며 구매에동의 하시겠습니까?</div>
		</div>
		
		
		<div class="btn-box">
			<button type="button" class="btn-pay">결제하기</button>
			<button type="button" class="btn-can">취소하기</button>
		</div>
	</div>
</div>


