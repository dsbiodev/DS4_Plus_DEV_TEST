<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
	<jsp:include page="/WEB-INF/jsp/common/title.jsp"></jsp:include>
</head>
<script>
	$(function() {
		var _goods = getParameterByName('goods');
		
		if(atob(_goods) == 190) {
			$('.goods').text("프리미엄 190");
			$('.goods-price').text("1,900,000원");
			$('.vat').text("190,000원");
			$('.total-price').text("2,090,000원");			
		}else if(atob(_goods) == 290) {
			$('.goods').text("프리미엄 290");
			$('.goods-price').text("2,900,000원");
			$('.vat').text("290,000원");
			$('.total-price').text("3,190,000원");
		}else {
			$('.goods').text("프리미엄 390");
			$('.goods-price').text("3,900,000원");
			$('.vat').text("390,000원");
			$('.total-price').text("4,290,000원");
		}

		
		$('.name').val(getParameterByName('BuyerName'));
		$('.phone').val($.pb.phoneFomatter(getParameterByName('BuyerTel')));
		
		$('.btn-confirm').on('click', function() { 
			
		})
		
		
	});
	
		
</script>
<style>
	.contents-wrap { display: flex; justify-content: center; align-items: center; flex-direction: column; overflow-x: hidden; font-family: NotoSansCJKkr; }
	.head { background-image: url("/resources/img/img_payment_finish.png"); background-size: 100% 100%; width: 1920px; height: 400px; }
	.wrap { width: 1000px; margin: 25px 0 40px; padding: 40px 0px 40px 40px; border: solid 1px #e1e1e1; background-color: #ffffff; }
	.wrap .title { height: 29px; margin: 0 47px 20px 0; font-size: 20px; font-weight: bold;  line-height: 1.45; text-align: left; color: #000000; }
	.wrap .box { display: flex; width:100%; }
	.wrap .box .text { width: 100px; height: 27px; font-size: 18px; margin: 11px 20px; font-weight: 500; text-align: left; color: #000000; }
	.wrap .box .text.colon { width: 143px; position: relative; }
	.wrap .box .text.colon:after { content: ":"; position: absolute; left: 150px; }
	.wrap .box input { width: 551px; height: 50px; margin: 0px 0 20px 47px; padding: 12px 5px 11px 16px; border: solid 1px #b1b1b1; background-color: #ffffff; font-size: 18px; }
	.wrap .box input[readonly] { background-color: #ffefef; }
	.wrap .box .select { margin: 11px 20px; font-size: 18px; font-weight: 500; color: #ff730f; }
	.text2 { margin: 0px 0 0px 17px; font-size: 18px; text-align: left; color: #000000; }
  	.btn-box { margin-bottom: 30px; }
  	.btn-box .btn-confirm { width: 296px; height: 57px; border-radius: 4px; background-color: #ff730f; color:#FFF; font-size: 18px; }
</style>
<div class="contents-wrap">
	<div class="head"></div>

	<div class="wrap">
		<div class="title">신청자 정보 입력</div>
		<div class="box">
			<div class="text">신청자</div>
			<input type="text" class="name" maxlength="20" readonly="readonly">
		</div>
		<div class="box">
			<div class="text">전화번호</div>
			<input type="text" class="phone" readonly="readonly">
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
	</div>
	
	<div class="btn-box">
		<button type="button" class="btn-confirm">확인</button>
	</div>
	
</div>