<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		// 입관 음원 전달
		var createPage = function() {
			$.pb.ajaxCallHandler('/admin/selectIpGwanPreview.do', { raspberryConnectionNo:_param.raspberryConnectionNo }, function(data) {
				if(data.list) {
					//입관 데이터 있을 때 뮤직 다운로드
					$.pb.ajaxCallHandler('/admin/selectPreviewMusic.do', { raspberryConnectionNo:_param.raspberryConnectionNo }, function(data) { })
					var _data = data.list[0];
					var goinString = '故 '+ _data.DM_NAME + " " + (_data.DM_POSITION ? _data.DM_POSITION : "");
					
					
					/* 										
					if( _data.DM_GENDER==1 || _data.DM_GENDER==3 ){
						if(_data.DM_AGE != '') { goinString += ' (남,'+_data.DM_AGE+'세)'; }
						else { goinString += ' (남)'; }
					}else{
						if(_data.DM_AGE != '') { goinString += ' (여,'+_data.DM_AGE+'세)'; }
						else { goinString += ' (여)'; }
					} */
					
					
					if( _data.DM_GENDER==0 ){
						if(_data.DM_AGE != '') {
							goinString += ' ('+_data.DM_AGE+'세)'; 
						}else { 
							goinString += ''; 
						}
					}else if(_data.DM_GENDER==1){
						if(_data.DM_AGE != '') {
							goinString += ' (남, '+_data.DM_AGE+'세)'; 
						}else { 
							goinString += ' (남)'; 
						}
					}else if(_data.DM_GENDER==2){
						if(_data.DM_AGE != '') {
							goinString += ' (여, '+_data.DM_AGE+'세)'; 
						}else { 
							goinString += ' (여)'; 
						}
					}else if(_data.DM_GENDER==3){
						if(_data.DM_AGE != '') {
							goinString += ' (男, '+_data.DM_AGE+'세)'; 
						}else { 
							goinString += ' (男)'; 
						}
					}else if(_data.DM_GENDER==4){
						if(_data.DM_AGE != '') {
							goinString += ' (女, '+_data.DM_AGE+'세)'; 
						}else { 
							goinString += ' (女)'; 
						}
					}
					
					
					$('.dm-name').html( goinString );
					
					if(_data.DM_PHOTO)
						$('.dm-photo').css('background-image', 'url('+_data.DM_PHOTO+')')
					else
						$('.dm-photo').css('background-image', 'url(/resources/img/img_dm.png)')
						
					
					if(_data.CARRYING_YN == 1) $('.carrying-dt').text(_data.CARRYING_DT);
					else $('.carrying-dt').text('-');
					
					$('.burial-name').text(_data.BURIAL_PLOT_NAME ? _data.BURIAL_PLOT_NAME : "미정")
					
					
					// 입관 마감시간 조정
					var isPause = false;
					var timer = setInterval(function() {
						if(isPause == false && new Date() > new Date(_data.ENTRANCE_ROOM_END_DT)) {
							isPause = true;
							createPage();
						}
						if(isPause) clearInterval(timer);
					}, 10000);
					
					// 폰트적용안해서 따로 interval없음
					setTimeout(function() {
						$('.chief-mourner').previewFnBinsoFamily(data.eventNo, data.eventFamilyInfo);
						setName(goinString);
						autoFontSize( $('.burial-name'), $('.burial-wrap'));
					}, 1000);
				}else {
					$('.control-warp').pageConnectionHandler('/preview/wait', { funeralNo: _param.funeralNo, raspberryConnectionNo:_param.raspberryConnectionNo }, function() { });
				}
			})
		}
		createPage();
		
	})
</script>
</head>
<style>
	body { width: 100%; height:100%; }
	.ibgwan-wrap { width: 100%; height: 100%; background-image: url('/resources/img/bg_ibgwan-min.png'); background-size: 100% 100%; background-color: #000; position: relative; }
	.dm-name-wrap { position: absolute; color: #FFF; font-size: 60px; font-weight: bold; top: 12%; left: 7%; width: 28%; text-align: center; height: 8.9%; display: flex; justify-content: center; align-items: center; }
	.text01 { position: absolute; color: #FFF; font-size: 60px; font-weight: bold; top: 12%; left: 61%; }
	.dm-photo { position: absolute; background-size: 100% 100%; width: 25.6%; height: 61.3%; top: 24.3%; left: 8.2%; }
	.family { position: absolute; color: #FFF; top: 23.1%; left: 36.8%; width: 55.6%; height: 46.5%; display: flex; justify-content: center; align-items: center; }
	.carrying-text { position: absolute; font-size: 40px; font-weight: bold; color: #000; top: 73.5%; left: 39.2%; }
	.carrying-dt { position: absolute; font-size: 40px; font-weight: bold; color: #000; top: 73.2%; left: 48%; width: 44%; height: 6%; display: flex; justify-content: center; align-items: center; }
	.burial-text { position: absolute; font-size: 40px; font-weight: bold; color: #000; top: 81.9%; left: 39.2%; }
	.burial-wrap { position: absolute; font-size: 40px; font-weight: bold; color: #000; top: 80.7%; left: 48%; width: 44%; height: 7.1%; display: flex; justify-content: center; align-items: center; }
	.burial-wrap .burial-name { white-space: pre-wrap; }
	.gNameContainer { text-align: center; }
</style>
<body>
	<div class="ibgwan-wrap">
		<div class="dm-name-wrap gNameRoot">
			<div class="gNameContainer dm-name">
           		<p class="col2"></p>
			</div>
		</div>
		
		<div class="text01">입관중</div>
		<div class="dm-photo"></div>

		<div class="family chief-mourner sangjuRoot">
        	<div class="sangjuContainer">
            	<p class="col3"></p>
        	</div>
		</div>
		<div class="carrying-text">발인</div>
		<div class="carrying-dt"></div>
		<div class="burial-text">장지</div>
		<div class="burial-wrap">
			<div class="burial-name"></div>
		</div>
	</div>
</body>
</html>