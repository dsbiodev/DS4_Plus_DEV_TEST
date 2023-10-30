<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="/resources/playbench/css/pb-common.css">
	<jsp:include page="/WEB-INF/jsp/common/meta.jsp"></jsp:include>
	<script type="text/javascript" src="/resources/js/jquery-3.2.1.min.js"></script>
	<script type="text/javascript" src="/resources/playbench/playbench.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/resources/room/room.css">
	<script type="text/javascript" src="/resources/room/room.js"></script>
	
	<title>빈소 정보</title>
<script>
	window.onload = function() { onLoad(); };
	function onLoad() {
		var _raspberryConnectionNo = getParameterByName('raspberryConnectionNo');
		$.pb.ajaxCallHandler('/admin/selectPreviewWhoIAm.do', { raspberryConnectionNo : _raspberryConnectionNo }, function(data) {
			// 영정일 경우 클릭시 팝업으로
			if(data.list[0].CLASSIFICATION == 20) {
				$('.preview-hover-wrap').removeClass('ac');
				var _div = $('<div class="yj-popup-wrap">');
				_div.append('<div class="rasp-id"></div>');
				_div.append('<div class="auto-ip"></div>');
				_div.append('<div class="ip"></div>');
				$('body').append(_div);
				$('body').on('click', function() {
					$('.yj-popup-wrap').css('display') == 'none' ? $('.yj-popup-wrap').css('display', 'flex') : $('.yj-popup-wrap').css('display', 'none');
				});
			}
			
			// 화면 분기 //
			try{
				$('.ip').text("localIp : " + (data.list[0].PRIVATE_IP ? data.list[0].PRIVATE_IP : ''))
				$('.auto-ip').text("publicIp : " + (data.list[0].AUTORIZED_IP ? data.list[0].AUTORIZED_IP : ''))
				$('.rasp-id').text("ID : " + (data.list[0].RASPBERRY_ID ? data.list[0].RASPBERRY_ID : ''))
				mode = data.list[0].CLASSIFICATION;
				if(data.list[0].FUNERAL_FLAG == 1) {
					if(mode == "10"){// 빈소 //
						$.pb.ajaxCallHandler('/admin/selectPreviewFindBinsoEvent.do', { raspberryConnectionNo:_raspberryConnectionNo }, function(result) {
							if(result.list.length > 0) {
								$('.control-warp').pageConnectionHandler('/preview/binso', { }, function(){ 
									binsoInit(result.list[0].EVENT_NO, result.list[0].FUNERAL_NO, result.list[0].RASPBERRY_CONNECTION_NO, result.list[0].RASPBERRY_ID ) 
								});
							}else { //행사없을시 대기화면
								if(data.list[0].FUNERAL_NO == 1207) { // 삼육은 행사 없을때 대기화면 말고 검은화면 적용
			 						$('html').addClass('port').css('background', "url('/resources/img/sy-binso-img.png')");
								}else {
									$('.control-warp').pageConnectionHandler('/preview/wait', { raspberryConnectionNo: _raspberryConnectionNo, funeralNo: data.list[0].FUNERAL_NO }, function() { });
								}
							}
						});
					}else if(mode == "20"){// 영정 //
						$('.control-warp').pageConnectionHandler('/preview/youngJeong', { raspberryConnectionNo:_raspberryConnectionNo }, function() { });
					}else if(mode == "30"){// 종합 //
						$('.control-warp').pageConnectionHandler('/preview/jonghap', { }, function() { JInit(data.list[0].FUNERAL_NO) });
					}else if(mode == "40"){// 입관 //
						if(data.list[0].FUNERAL_NO == 1207) {
							$.pb.ajaxCallHandler('/admin/selectPreviewSYIPEvent.do', { raspberryConnectionNo:_raspberryConnectionNo }, function(result) {
								if(result.list.length > 0) {
									$('.control-warp').pageConnectionHandler('/preview/binso', { }, function(){ 
										var syIpFlag = true
										binsoInit(result.list[0].EVENT_NO, result.list[0].FUNERAL_NO, result.list[0].RASPBERRY_CONNECTION_NO, result.list[0].RASPBERRY_ID, syIpFlag) 
									});
								}else { //행사없을시 대기화면
			 						$('html').addClass('port').css('background', "url('/resources/img/sy-binso-img.png')");
								}
							})
						}else {
							$('.control-warp').pageConnectionHandler('/preview/ibgwan', { raspberryConnectionNo:_raspberryConnectionNo, funeralNo: data.list[0].FUNERAL_NO }, function() { });
						}
					}else if(mode == "50"){// 특수 //
						$('.control-warp').pageConnectionHandler('/preview/special', { raspberryConnectionNo: _raspberryConnectionNo, funeralNo: data.list[0].FUNERAL_NO }, function() { });
					}else if(mode == "60"){// 상가 //
						
						if(data.list[0].FUNERAL_NO == 1207) { // 삼육 상가화면
							$('.control-warp').pageConnectionHandler('/preview/sanggaSY', { funeralNo: data.list[0].FUNERAL_NO }, function() { });
						}
						else if(data.list[0].FUNERAL_NO == 523) { // 대구의료원 상가화면
							$('.control-warp').pageConnectionHandler('/preview/sanggaSY', { funeralNo: data.list[0].FUNERAL_NO }, function() { });
						}
						//상주 리스트
						/* else if(data.list[0].FUNERAL_NO == 1365 ||data.list[0].FUNERAL_NO == 1005) { // 운영(착한전문 : 1366 / 배방 : 1005) 개발(착한전문 :   / 배방 : )
							$('.control-warp').pageConnectionHandler('/preview/sanggaBusan', { }, function() { sanggaInit(data.list[0].FUNERAL_NO) });
						} */
						else if(data.list[0].FUNERAL_NO == 1366 ) { // 착한전문 운영 : 1366 / 개발 : 1365
							$('.control-warp').pageConnectionHandler('/preview/sanggaChackhan', { }, function() { sanggaInit(data.list[0].FUNERAL_NO) });
						}
						else if(data.list[0].FUNERAL_NO == 758) {  	//인천의료원(개발 & 운영: 758 )
							$('.control-warp').pageConnectionHandler('/preview/sanggaIC', { }, function() { sanggaInit(data.list[0].FUNERAL_NO) });
						}
						else if(data.list[0].FUNERAL_NO == 105 ){ //의정부백뱅원(개발 & 운영 : 105)
							$('.control-warp').pageConnectionHandler('/preview/sanggaBaeckHospital', { }, function() { sanggaInit(data.list[0].FUNERAL_NO) });
						}
						else if(data.list[0].FUNERAL_NO == 225 || data.list[0].FUNERAL_NO == 620) { // (양주회천농협장례문화원 운영, 개발 : 225 / 부산 (주)수장례식장 운영, 개발: 620 )
							$('.control-warp').pageConnectionHandler('/preview/sanggaYangju', { }, function() { sanggaInit(data.list[0].FUNERAL_NO) });
						}					
						else {
							$('.control-warp').pageConnectionHandler('/preview/sangga', { }, function() { sanggaInit(data.list[0].FUNERAL_NO) });
						}
					}else if(mode == "70"){//  //
						
					}else if(mode == "80"){//  //
						
					}else if(mode == "90"){// 대기 //
						$('.control-warp').pageConnectionHandler('/preview/wait', { raspberryConnectionNo: _raspberryConnectionNo, funeralNo: data.list[0].FUNERAL_NO }, function() { });
					}
				}else {
					$('.control-warp').css("width", "1920px").css("height", "1080px").css("background", "#000");
				}
			}catch(e){
				console.log('ERR', e);
			}
		});
	}
</script>
</head>
<style>
	html { width:1920px;height:1080px;min-width:0px; }
	html.port { transform: rotate(90deg); transform-origin: top right; position: absolute; top: 100%; left: calc(100% - 1080px); width: 100vh; height: 100vw; }

	.preview-hover-wrap { position: absolute; height: 100px; width: 100%; z-index: 100000; background: rgb(0 0 0 / 0%); color: transparent; display: flex; flex-direction: column; justify-content: center; align-items: flex-start; font-size: 20px; padding-left: 20px; box-sizing: border-box; }
	.preview-hover-wrap.ac:hover { background: rgb(0 0 0 / 80%); }
	.preview-hover-wrap.ac:hover div { color: #FFF; }
	.yj-popup-wrap { position: absolute; height: 160px; width: 300px; z-index: 100000; background: #FFF; color: #000; display: none; flex-direction: column; justify-content: center; align-items: center; font-size: 20px; top: calc(50% - 160px); left: calc(50% - 150px); border-radius: 5px; }
	.yj-popup-wrap
</style>
<body>
	<div class="preview-hover-wrap ac">
		<div class="rasp-id"></div>
		<div class="auto-ip"></div>
		<div class="ip"></div>
	</div>

	<div class="control-warp" style="width:100%;height:100%"></div>
</body>
</html>