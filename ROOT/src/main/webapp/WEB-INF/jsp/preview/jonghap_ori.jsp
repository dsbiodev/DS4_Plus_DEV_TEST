<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="/resources/js/swiper.min.css">
	<script type="text/javascript" src="/resources/js/swiper.min.js"></script>
	<title>종합현황</title>
<script>
	function JInit(_funeralNo) {
		var _raspberryConnectionNo = getParameterByName('raspberryConnectionNo');
		$.pb.ajaxCallHandler('/admin/selectJonghapPreview.do', { raspberryConnectionNo:_raspberryConnectionNo, funeralNo:_funeralNo }, function(data) {
			var rs = data;
			var style = rs.style;

			// 종합 모드별 분기 시작 //
			// 멀티모드인 경우 //
			if(style[0].MULTI_MODE==1) {
				// FUNERAL_NO,MULTI_NAME 을 인자로 넘김 - 스타일과 포한되는 빈소는 첫번째 종합화면을 따르는것을 규칙으로 한다.
				$.pb.ajaxCallHandler('/admin/selectPreviewFindMultiMode.do', {funeralNo:rs.funeral[0].FUNERAL_NO, multiName:style[0].MULTI_NAME }, function(rsMulti) {
					// rsMulti = 멀티화면에 포함된 종합현황 // funeralNo 추가 -> 행사없을때이미지가져오기
					$.pb.ajaxCallHandler('/admin/selectJonghapPreview.do', { raspberryConnectionNo : rsMulti.list[0].RASPBERRY_CONNECTION_NO, funeralNo:_funeralNo }, function(rsFirstJ) {
			 			$('body').css('font-family', rsFirstJ.style[0].FONT_TYPE);
						var _evt = [];
						
						
						$.each(rsFirstJ.evt, function(idx, value) {
							var tmp = _evt.filter(function(o){ return o.EVENT_NO == value.EVENT_NO || o.RASPBERRY_CONNECTION_NO == value.RASPBERRY_CONNECTION_NO  })
						    if(tmp.length == 0) _evt.push(value);
						});
						rsFirstJ.evt = _evt;
						
						//첫번째 항목(대표항목)의 빈소정보와 스타일 정보를 받아오기 위해 이 부분을 작성
						var multiLen = rsMulti.list.length;		// 멀티화면에 포함된 종합현황의 총 개수 //
						var binsoLen = rsFirstJ.evt.length;		// 현재 행사중인 빈소의 총 개수(멀티모드에 포함된 첫번째 종합현황 기준) //
						var divide = 1;							// 초기값은 1분할 //
						// 분할 결정 //
						if( binsoLen/multiLen <= 1 ){
							divide = 1;
						}else if( binsoLen/multiLen <= 2 ){
							divide = 2;
						}else if( binsoLen/multiLen <= 4 ){
							divide = 4;
						}else if( binsoLen/multiLen <= 6 ){
							divide = 6;
						}else if( binsoLen/multiLen <= 8 ){
							divide = 8;
						}else {
							divide = 8;
						}
						
						//멀티개수 새서 배열생성 2차원배열로 생성
						var arr = new Array();
						$.each(rsMulti.list, function(idx){
							var arr_sub = new Array();
							arr.push(arr_sub);
						});
						
						//멀티에 들어가는 행사 갯수 새기, 배열에 종합넘버 넣기
						$.each(rsFirstJ.evt, function(idx) {
							arr[idx%rsMulti.list.length].push(rsMulti.list[idx%rsMulti.list.length]);
						});
						
						//2차원배열 1차원으로 만들기 = 멀티모드 행사 순차적으로 넣기
						var _tmp = [];
						$.each(arr, function(idx, value){
							$.each(value, function(){
								_tmp.push(this);
							});
						});

						$.each(rsFirstJ.evt, function(idx){
							this.RASPBERRY_CONNECTION_NO = _tmp[idx].RASPBERRY_CONNECTION_NO
						})
						
						var tempRs = rsFirstJ;						
						var _evt = $.grep(rsFirstJ.evt, function(o){ return o.RASPBERRY_CONNECTION_NO == _raspberryConnectionNo })
						tempRs.evt = _evt
						
						
						console.log("tempRs", tempRs)
						
						
						if(tempRs.evt.length > 0) {
							// 분할 결정 //
							if( divide == 1 ){
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(tempRs,1) });
							}else if( divide == 2 ){
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(tempRs,2) });
							}else if( divide == 4 ){
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(tempRs,4) });
							}else if( divide == 6 ){
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(tempRs,6) });
							}else if( divide == 8 ){
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(tempRs,8) });
							}else {
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(tempRs,8) });
							}
						}else
							$('.control-warp').pageConnectionHandler('/preview/wait', { raspberryConnectionNo:_raspberryConnectionNo, funeralNo:_funeralNo }, function() { });
						
					});
				
				});
			}
			else {
	 			$('body').css('font-family', style[0].FONT_TYPE);
				// 멀티 아닐경우
				// 행사 등록 후 예약행사 시간됬을 때 행사 2개 가져옴 - 행사 중복처리 부분
				var _evt = [];
				$.each(data.evt, function(idx, value) {
					var tmp = _evt.filter(function(o){ return o.EVENT_NO == value.EVENT_NO || o.RASPBERRY_CONNECTION_NO == value.RASPBERRY_CONNECTION_NO })
				    if(tmp.length == 0) _evt.push(value);
				});
				rs.evt = _evt
				
				if(rs.evt.length > 0) {
					// 멀티모드가 아닌 경우 (자동분할모드, 고정분할모드) //
					// 하위에서 가져오는 데이터에 공통으로 폰트에 반영 //
					if(style[0].DIVISION_MODE==1){
					// 자동분할모드인 경우 //
						$('.main').pageConnectionHandler('/preview/jonghapMode/autoMode', { }, function() { autoModeInit(rs) });
					}else{
					// 고정분할모드인 경우 //
				 		switch (style[0].DIVISION){
							case 1:
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(rs,1) });
							break;
							case 2:
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(rs,2) });
							break;
							case 4:
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(rs,4) });
							break;
							case 6:
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(rs,6) });
							break;
							case 8:
								$('.main').pageConnectionHandler('/preview/jonghapMode/staticMode', { }, function() { staticModeInit(rs,8) });
							break;
							default:
							break;
						} 
					}
				}else $('.control-warp').pageConnectionHandler('/preview/wait', { raspberryConnectionNo:_raspberryConnectionNo, funeralNo:_funeralNo }, function() { });
			}
		});
	}
</script>
</head>
<style>
html { width:1920px;height:1080px;min-width:0px; }
</style>
<body>
	<div class="main" style="width:100%;height:100%"></div>
</body>
</html>