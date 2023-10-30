<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<head>
	<jsp:include page="/WEB-INF/jsp/common/title.jsp"></jsp:include>
</head>
<script>
	$(function() {
		var _funeralNo = getParameterByName('funeralNo');
		$.pb.ajaxCallHandler('/adminSec/selectFuneralInfo.do', { funeralNo : _funeralNo }, function(data) {
			var _data = data.infoList
			$('.funeral-name').text(_data.FUNERAL_NAME);
			$('.contact').text("상호명 : "+_data.SANGHO_NAME +" ㅣ 사업자 등록번호 : "+_data.BUS_NO+" ㅣ 장례식장 주소 : "+_data.ADDRESS+" ㅣ 대표 : "+_data.BOSS_NAME+" ㅣ 전화 : "+_data.CONTACT +" ㅣ ARS결제 : "+_data.CONTACT );

			
			$('.pay-01').on('click', function(){
				$(location).attr('href', '/payment?goods='+btoa(190));
			});
			
			$('.pay-02').on('click', function(){
				$(location).attr('href', '/payment?goods='+btoa(290));
			});
			
			$('.pay-03').on('click', function(){
				$(location).attr('href', '/payment?goods='+btoa(390));
			});
		});
	});
</script>

<style>
	.contents-wrap { background-image: url("/resources/img/img_payment_sel.png"); background-size: 100% 100%; width: 1903px; height: 3631px; }
	.funeral-name { font-size: 33px; font-weight: 500; box-sizing: border-box; display: flex; justify-content: center; align-items: center; height: 100px; }
	.funeral-contact { position: absolute; bottom: 0px; height: 120px; width: 100%; font-size: 18px; display: flex; justify-content: center; align-items: center; flex-direction: column; line-height: 28px; font-weight: 500; }

	.pay-01 { position: absolute; top: 1044px; left: 327px; width: 294px; height: 57px; border: none; background: transparent; }
	.pay-02 { position: absolute; top: 1044px; left: 802px; width: 294px; height: 57px; border: none; background: transparent; }
	.pay-03 { position: absolute; top: 1044px; left: 1279px; width: 294px; height: 57px; border: none; background: transparent; }
	
</style>
<div class="contents-wrap">
	<div class="funeral-name"></div>
	<div class="funeral-contact">
		<div class="contact"></div>
		<div>© 2020. Playbench, Inc. All Rights Reserved.</div>
	</div>
	
	<button class="pay-01"></button>
	<button class="pay-02"></button>
	<button class="pay-03"></button>
</div>