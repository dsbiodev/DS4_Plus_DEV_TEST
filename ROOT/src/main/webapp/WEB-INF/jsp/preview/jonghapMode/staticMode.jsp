<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
body { background:#fff; width:100%; height:100%; margin: 0px; overflow: hidden; }
.background-wrap {background-color:#fafafa; width:100%; height:100%; }
.backgrond-image-wrap { width:100%; height:100%; }
.title-wrap { height:48px; display:flex; flex-direction: row; }
.preview-wrap { height:984px; }
.bottom-wrap { height:48px; color: #fff; font-size: 36px;  display: flex; justify-content: flex-start; align-items: center; padding-left:10px; }
.funeral-logo { height:100%; width:518px; max-width:553px; background-repeat: no-repeat; }
.title-center { height:100%; width:869px; color: #fff; font-size: 36px; display: flex; justify-content: center; align-items: center; word-spacing: 10vw; }
.title-right { height:100%; width:518px; color: #fff; font-size: 24px; display: flex; justify-content: flex-end; align-items: center; word-spacing: 5px; padding-right:10px; }
.previews { width:100%; height:100%;  position: absolute; z-index: 99; }
.data-previews { width:100%; height:100%;  position: absolute; z-index: 10; }
.bottom-text { width:auto; display: inline-block;white-space: nowrap;position: relative; animation: slideLeft 30s infinite;animation-timing-function: linear;}
</style>
<head>
<script>
	function staticModeInit(data, _p){
		var style = data.style;
		var attr = data.attr;
		var evt = data.evt;
		var funeral = data.funeral;
		
		var evtLen = _p;
		if(evtLen != 0) {
			var division = 'one';
			if(evtLen==2){ division = 'two'; }
			else if(evtLen==3 || evtLen==4){ division = 'four'; }
			else if(evtLen==5 || evtLen==6){ division = 'six'; }
			else if(evtLen==7 || evtLen==8){ division = 'eight'; }
		}
		
		if(style[0].BOTTOM_TEXT != '') {// 하단문구가 있는 경우 //
			var basicLayer = $('<div class="basic-layer" style="width:100%; height:100%; display:flex; flex-direction: column;">');
// 			basicLayer.append('<div class="title-wrap"><div class="funeral-logo"></div></img><div class="title-center">빈 소 안 내</div><div class="title-right">'+new Date().format('MM월 dd일 HH시 mm분')+'</div></div>');
//			basicLayer.append('<div class="title-wrap"><div class="funeral-logo" style="background-position: 0% 50%;"></div></img><div class="title-center">빈 소 안 내</div><div class="title-right"></div></div>');
			basicLayer.append('<div class="title-wrap"><div class="funeral-logo" style="background-position: 0% 50%;"></div></img><div class="title-center">빈 소 안 내</div><div class="title-right">'+new Date().format('MM월 dd일 HH시 mm분')+'</div></div>');
			basicLayer.append('<div class="preview-wrap"></div>');
			basicLayer.append('<div class="bottom-wrap"><div class="bottom-text">'+style[0].BOTTOM_TEXT+'</div></div>');
			basicLayer.append('</div>');
			
			$('.previews').html(basicLayer);
			
			if($('.bottom-text').width() < $('.bottom-wrap').width()){
				$('.bottom-wrap').html(style[0].BOTTOM_TEXT);
			}else{
				var cssAnimation = document.createElement('style');
				cssAnimation.type = 'text/css';
				var rules = document.createTextNode('@keyframes slideLeft{'+
				'from { left: 1920px; }'+
				'to { left:-'+$('.bottom-text').width()+'px; }'+
				'}');
				cssAnimation.appendChild(rules);
				document.getElementsByTagName("head")[0].appendChild(cssAnimation);
			}
			
			if( funeral[0].LOGO_IMAGE != '' ){ 
				$( '.funeral-logo' ).css( "background-image" , "url("+funeral[0].LOGO_IMG+")" );
			}
			$('.funeral-logo').css('max-height','48px');

			if(evtLen == 0){
				// 대기화면 //
				loadWait();
			}else if (evtLen == 1) {
				// 1분할 //
				loadDivOne(data);
			}else if (evtLen == 2) {
				// 2분할 //
				loadDivTwo(data);
			}else if (evtLen <= 4) {
				// 4분할 //
				loadDivFour(data);
			}else if (evtLen <= 6) {
				// 6분할 //
				loadDivSix(data);
			}else if (evtLen >= 7){
				// 8분할, 8개이상 시 스크롤 //
				loadDivEight(data);
			}else{
				//  //
			}
		}else{// 하단 문구가 없는 경우 //
			var basicLayer = $('<div class="basic-layer" style="width:100%; height:100%; display:flex; flex-direction: column;">');
// 			basicLayer.append('<div class="title-wrap"><div class="funeral-logo"></div></img><div class="title-center" style="font-size:57px;">빈 소 안 내</div><div class="title-right">'+new Date().format('MM월 dd일 HH시 mm분')+'</div></div>');
//			basicLayer.append('<div class="title-wrap"><div class="funeral-logo"></div></img><div class="title-center" style="font-size:57px;">빈 소 안 내</div><div class="title-right"></div></div>');
			basicLayer.append('<div class="title-wrap"><div class="funeral-logo"></div></img><div class="title-center" style="font-size:57px;">빈 소 안 내</div><div class="title-right">'+new Date().format('MM월 dd일 HH시 mm분')+'</div></div>');
			basicLayer.append('<div class="preview-wrap"></div>');
			basicLayer.append('<div class="bottom-wrap"><div class="bottom-text">'+style[0].BOTTOM_TEXT+'</div></div>');
			basicLayer.append('</div>');
			
			$('.previews').html(basicLayer);
			
			if($('.bottom-text').width() < $('.bottom-wrap').width()){
				$('.bottom-wrap').html(style[0].BOTTOM_TEXT);
			}else{
				var cssAnimation = document.createElement('style');
				cssAnimation.type = 'text/css';
				var rules = document.createTextNode('@keyframes slideLeft{'+
				'from { left: 1920px; }'+
				'to { left:-'+$('.bottom-text').width()+'px; }'+
				'}');
				cssAnimation.appendChild(rules);
				document.getElementsByTagName("head")[0].appendChild(cssAnimation);
			}
			
			if( funeral[0].LOGO_IMAGE != '' ){ 
				$( '.funeral-logo' ).css( "background-image" , "url("+funeral[0].LOGO_IMG+")" );
			}
			$('.funeral-logo').css('max-height','96px');
			$('.title-wrap').css('height','96px');

			if(evtLen == 0){
				// 대기화면 //
				loadWait();
			}else if (evtLen == 1) {
				// 1분할 //
				loadDivOne(data);
			}else if (evtLen == 2) {
				// 2분할 //
				loadDivTwo(data);
			}else if (evtLen <= 4) {
				// 4분할 //
				loadDivFour(data);
			}else if (evtLen <= 6) {
				// 6분할 //
				loadDivSix(data);
			}else if (evtLen >= 7){
				// 8분할, 8개이상 시 스크롤 //
				loadDivEight(data);
			}else{
				//  //
			}
		}
		
 		var jonghapClock = setInterval(function() {
 			$('.title-right').html(new Date().format('MM월 dd일 HH시 mm분'));
 		}, 1000);
 		
	}
	
	function loadDivOne(data){
		$('.data-previews').pageConnectionHandler('/preview/jonghapMode/component/shared1', { }, function() { initUI(data) });
	}
	function loadDivTwo(data){
		$('.data-previews').pageConnectionHandler('/preview/jonghapMode/component/shared2', { }, function() { initUI(data) });
	}
	function loadDivFour(data){
		$('.data-previews').pageConnectionHandler('/preview/jonghapMode/component/shared4', { }, function() { initUI(data) });
	}
	function loadDivSix(data){
		$('.data-previews').pageConnectionHandler('/preview/jonghapMode/component/shared6', { }, function() { initUI(data) });
	}
	function loadDivEight(data){
		$('.data-previews').pageConnectionHandler('/preview/jonghapMode/component/shared8', { }, function() { initUI(data) });
	}
	function loadWait(){
		$('.previews').pageConnectionHandler('/preview/wait', { }, function() {  });
	}
	
	

		
</script>
</head>

<body>
	<div class="background-wrap">
		<div class="backgrond-image-wrap">
			<div class="previews"></div>
			<div class="data-previews"></div>
		</div>
	</div>
</body>

</html>
