<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$.getScript('//dapi.kakao.com/v2/maps/sdk.js?appkey=f7e1fd09c3c8eb31bab7abf293fe6bea&autoload=false&libraries=services', function(data, textStatus, jqxhr) {	//운영
		//$.getScript('//dapi.kakao.com/v2/maps/sdk.js?appkey=1c7c17859fd5b1a0e7c28e96e4192da5&autoload=false&libraries=services', function(data, textStatus, jqxhr) {	//개발
			daum.maps.load(function() { 
				
				var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
			    mapOption = { 
			        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
			        level: 3 // 지도의 확대 레벨
			    };
				// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
				var map = new kakao.maps.Map(mapContainer, mapOption); 
				var marker = new kakao.maps.Marker({ 
					    // 지도 중심좌표에 마커를 생성합니다 
					    position: map.getCenter() 
					});marker.setMap(map);
				map.setDraggable(false);
				map.setZoomable(false);
				
				
				$('input[type=radio][name=disabledPersonFacility]').siteRadio({ addText:['유', '무'], fontSize:'16px', matchParent:false });
				$('input[type=radio][name=waitingRoom]').siteRadio({ addText:['유', '무'], fontSize:'16px', matchParent:false });
				$('input[type=radio][name=operationKind]').siteRadio({ addText:['병원장례식장', '전문장례식장'], fontSize:'16px', matchParent:false });
				$('input[type=radio][name=allianceFlag]').siteRadio({ addText:['미제휴', '제휴'], fontSize:'16px', matchParent:false });
				$('input[name=contact]').phoneFomatter();
				$('input[name=calculateContact]').phoneFomatter();
				
				//이미지 업로드 
				$('.funeral-img').bind('click', function() {
					if($(this).hasClass('add')){
						$(this).siblings('input[type=file][name=funeralImg]').val("");
						$(this).removeClass('add').html("");
					}else $(this).siblings('input[type=file][name=funeralImg]').click();	
				});
				$("input[type=file][name=funeralImg]").bind("change", function() {
					var $this = $(this);
					var $files = $this[0].files;
					$.each($files, function() {
						var reader = new FileReader();
						var f = this;
						reader.onload = function(rst) {
							$this.siblings('.funeral-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
						};
						reader.readAsDataURL(f);
					});
				});
				
				$('.logo-img').bind('click', function() {
					if($(this).hasClass('add')){
						$(this).siblings('input[type=file][name=logoImg]').val("");
						$(this).removeClass('add').html("");
					}else $(this).siblings('input[type=file][name=logoImg]').click();
				});
				$("input[type=file][name=logoImg]").bind("change", function() {
					var $this = $(this);
					var $files = $this[0].files;
					$.each($files, function() {
						var reader = new FileReader();
						var f = this;
						reader.onload = function(rst) {
							$this.siblings('.logo-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
						};
						reader.readAsDataURL(f);
					});
				});
				
				
				// seal image
				$('.seal-img').bind('click', function() {
					if($(this).hasClass('add')){
						$(this).siblings('input[type=file][name=sealImg]').val("");
						$(this).removeClass('add').html("");
					}else $(this).siblings('input[type=file][name=sealImg]').click();	
				});
				$("input[type=file][name=sealImg]").bind("change", function() {
					var $this = $(this);
					var $files = $this[0].files;
					$.each($files, function() {
						var reader = new FileReader();
						var f = this;
						reader.onload = function(rst) {
							$this.siblings('.seal-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
						};
						reader.readAsDataURL(f);
					});
				});
				
				
				
				/// 분할 이미지
				$('.divide-img').bind('click', function() {
					if($(this).hasClass('add')){
						$(this).prev('input[type=file]').val("");
						$(this).removeClass('add').html("");
					}else $(this).prev('input[type=file]').click();
				});
				$("input[type=file]").bind("change", function() {
					var $this = $(this);
					var $files = $this[0].files;
					$.each($files, function() {
						var reader = new FileReader();
						var f = this;
						reader.onload = function(rst) {
							$this.next('.divide-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
						};
						reader.readAsDataURL(f);
					});
				});
				
				$.pb.ajaxCallHandler('/adminSec/selectFuneralInfo.do', { funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) {
					layerInit($('.contents-body-wrap'), data.infoList);
					if(data.infoList.FUNERAL_IMG) $('.funeral-img').addClass('add').html('<img src='+data.infoList.FUNERAL_IMG+' class="images"/>');
					if(data.infoList.LOGO_IMG) $('.logo-img').addClass('add').html('<img src='+data.infoList.LOGO_IMG+' class="images"/>');

					//seal image
					if(data.infoList.SEAL_IMG) $('.seal-img').addClass('add').html('<img src='+data.infoList.SEAL_IMG+' class="images"/>');
					
					
					
					$.each(data.divideImg, function(idx, value){
						$('.div-divide').find('input[name='+this.DIVIDE+']').next().addClass('add').html('<img src='+this.PATH+' class="images"/>');
					});
					
					var geocoder = new daum.maps.services.Geocoder();
					geocoder.addressSearch(data.infoList.ADDRESS, function(result, status) {
				        if(status === daum.maps.services.Status.OK) {
				            var coords = new daum.maps.LatLng(result[0].y, result[0].x);
				 			map.relayout();
							var moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
				 		    map.setCenter(moveLatLon);
				 		   	var marker = new kakao.maps.Marker({ 
				 			    // 지도 중심좌표에 마커를 생성합니다 
				 			    position: map.getCenter() 
			 				});marker.setMap(map);
				        } 
				    });
					
					//관리자 번호 display
					var arrMgrNm = new Array();
					var arrMgrPhone = new Array();
					
					if(data.infoList.MGR_NM_2){
						arrMgrNm.push(data.infoList.MGR_NM_2);
						arrMgrPhone.push(data.infoList.MGR_PHONE_2);	
					}
					
					if(data.infoList.MGR_NM_3){
						arrMgrNm.push(data.infoList.MGR_NM_3);
						arrMgrPhone.push(data.infoList.MGR_PHONE_3);
					}
					
					if(data.infoList.MGR_NM_4){
						arrMgrNm.push(data.infoList.MGR_NM_4);
						arrMgrPhone.push(data.infoList.MGR_PHONE_4);
					}
					
					if(data.infoList.MGR_NM_5){
						arrMgrNm.push(data.infoList.MGR_NM_5);
						arrMgrPhone.push(data.infoList.MGR_PHONE_5);
					}
												
					for(var i=0; i<arrMgrNm.length; i++){											
						if(arrMgrNm[i]){
							
							addMgrDiv(i)												
							
							$('#mgrDivNm'+i).find('input[name=mgrNm]').val(arrMgrNm[i]);
							$('#mgrDivPhone'+i).find('input[name=mgrPhone]').val(arrMgrPhone[i]);		
						}																							
					}
					
		 			$('#mgrBtn0').unbind('click').bind('click',function(){
						$('#mgrDivNm0').remove();
						$('#mgrDivPhone0').remove();		
					}); 			
						
					$('#mgrBtn1').unbind('click').bind('click',function(){
						$('#mgrDivNm1').remove();
						$('#mgrDivPhone1').remove();		
						});
					
					$('#mgrBtn2').unbind('click').bind('click',function(){
						$('#mgrDivNm2').remove();
						$('#mgrDivPhone2').remove();		
						});
					
					$('#mgrBtn3').unbind('click').bind('click',function(){
						$('#mgrDivNm3').remove();
						$('#mgrDivPhone3').remove();		
					});																
					
					
				});
				
				$('.right-button.upd').on('click', function(){
					if(!necessaryChecked($('#dataForm'))) {
						var _formData = new FormData($('#dataForm')[0]);
						_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
						_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
						if(!$('input[name=funeralImg]').val() && typeof $('.funeral-img').find('img').prop('src') != "undefined")
							_formData.append('funeralImg', $('.funeral-img').find('img').prop('src'));
						if(!$('input[name=logoImg]').val() && typeof $('.logo-img').find('img').prop('src') != "undefined")
							_formData.append('logoImg', $('.logo-img').find('img').prop('src'));
						
						/* 직인이미지 */
						if(!$('input[name=sealImg]').val() && typeof $('.seal-img').find('img').prop('src') != "undefined")
							_formData.append('sealImg', $('.seal-img').find('img').prop('src'));
						
						
						var arr_list = [];
						$('.div-divide > input[type=file]').each(function(idx){
							if(!$(this).val()){
								if($(this).next().find('img').attr('src')){
									var $list = {
											divide : $(this).attr('name'),
											path : $(this).next().find('img').attr('src')
									};
									arr_list.push($list);
								}
							}
						});
						_formData.append('divideList', JSON.stringify(arr_list));
						
						//mgrname
						var colNo = 2;
						
							$('#rowMgrNm').find('input[name=mgrNm]').each(function(i, obj) {
																																																
							_formData.append('MGR_NM_'+colNo,$(this).val());
																
							colNo++															    							    							    
						}); 
							
						var colPNo = 2;
							//mgrPhone
							$('#rowMgrPhone').find('input[name=mgrPhone]').each(function(i, obj) {
							
							_formData.append('MGR_PHONE_'+colPNo,$(this).val());
																
							colPNo++															    							    							    
						});  							
						
						$.pb.ajaxUploadForm('/adminSec/updateFuneralInfo.do', _formData, function(result) {
							if(result != 0) {
							} else alert('저장 실패 관리자에게 문의하세요');
							alert("저장되었습니다.")
						}, '${sessionScope.loginProcess}');
					}else{
						if(!$('input[name=funeralName]').val()) return alert("장례식장명을 입력해 주세요.");
						if(!$('input[name=bossName]').val()) return alert("대표자명을 입력해 주세요.");
						if(!$('input[name=calculateName]').val()) return alert("관리자명을 입력해 주세요.");
						if(!$('input[name=calculateContact]').val()) return alert("관리자연락처를 입력해 주세요.");
						if(!$('input[name=parkingCnt]').val()) return alert("주차가능대수를 입력해 주세요.");
					}
				});
			});
		});
		
		function addMgrDiv(mgrCnt){
			
			//관리자 이름
			var divMgrNM = $('#rowMgrNm');
			
			var mgrNmWrap = $('<div class="row-box" id="mgrDivNm'+mgrCnt+'">');
			mgrNmWrap.append('<label class="title" ></label>');
			mgrNmWrap.append('<input type="text" class="form-text MgrName" name="mgrNm" placeholder="관리자명" />');				
			mgrNmWrap.append('</div>');
								
			divMgrNM.append(mgrNmWrap);
			
			//관리자 연락처
			var divMgrPhone = $('#rowMgrPhone');
			
 			var mgrPhoneWrap = $('<div class="row-box" id="mgrDivPhone'+mgrCnt+'">');
			mgrPhoneWrap.append('<label class="title" ></label>');
			mgrPhoneWrap.append('<input type="text" class="form-text MgrPhone" name="mgrPhone" placeholder="관리자 연락처" />');
			mgrPhoneWrap.append('<button type="button" class="mgrBtn" id="mgrBtn'+mgrCnt+'"><img class = "mgrImg" src = "/resources/img/Mgrdel.png"></button>');
			mgrPhoneWrap.find('input[name=mgrPhone]').phoneFomatter();
			
			mgrPhoneWrap.append('</div>');
						
			divMgrPhone.append(mgrPhoneWrap);
			
		}
		
		//관리자 추가 버튼 클릭 이벤트
		$('#btnMgrAdd').on('click',function(){
			
			//get div manager count
			var divMgr = document.getElementsByClassName('form-text MgrName');								
			var mgrCnt = (divMgr.length);
					
			if(mgrCnt > 3){
				alert("관리자 정보는 5개까지 등록가능합니다.")
				return;
			}
			
			addMgrDiv(mgrCnt);

 			$('#mgrBtn0').unbind('click').bind('click',function(){
				$('#mgrDivNm0').remove();
				$('#mgrDivPhone0').remove();		
			}); 			
				
			$('#mgrBtn1').unbind('click').bind('click',function(){
				$('#mgrDivNm1').remove();
				$('#mgrDivPhone1').remove();		
				});
			
			$('#mgrBtn2').unbind('click').bind('click',function(){
				$('#mgrDivNm2').remove();
				$('#mgrDivPhone2').remove();		
				});
			
			$('#mgrBtn3').unbind('click').bind('click',function(){
				$('#mgrDivNm3').remove();
				$('#mgrDivPhone3').remove();		
			});		 
		});
		
	});
</script>

<style>
 .row-box { margin-top:20px; font-size:0; position:relative; }
 .contents-title-wrap .title { width:auto; display:inline-block; box-sizing:border-box; padding:0 16px; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; text-align:right; }
 .title { width:156px; display:inline-block; box-sizing:border-box; padding:0 16px; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; text-align:right; }
 .form-text { width:calc(100% - 156px); height:36px; display:inline-block; padding-left:12px; box-sizing:border-box; border:1px solid #707070; border-radius:2px; background:#F6F6F6; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; }
 .mgrBtn{ width:40px; height:36px; position:absolute; right:0; border-radius:4px; letter-spacing:0.9px;}
 .mgrImg{    border: 1px solid; width: 40px;  height: 36px;  position: relative; right: 0px;  bottom: 1px;}
 
 .btn-box{text-align:right;}
 .mgrAdd { width:142px; height:36px; background:#157ffb; color:#FFF; border-radius:2px; font-size:16px; }
 
 #nothingDiv {
 	visibility: hidden;
 }
</style>

<div class="contents-title-wrap">
	<div class="title">기본정보관리</div>
	<div>장례식장 정보를 관리할 수 있습니다.</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">장례식장 정보</div>
	</div>
	<div class="search-right-wrap">
		<button type="button" class="right-button upd">저장</button>
	</div>
</div>

<div class="contents-body-wrap">
	<form id="dataForm">
		<div class="full-size">
			<div class="pb-info-body half" style="padding:0px 10px 20px 0px;">
				<div class="pb-info-form">
					<div class="form-box-st-01 half">
						<div class="row-box">
							<label class="title">*장례식장명</label>
							<input type="text" class="form-text necessary" name="funeralName" placeholder="장례식장명"/>
						</div>
						<div class="row-box">
							<label class="title">대표전화번호</label>
							<input type="text" class="form-text" name="contact" placeholder="대표전화번호"/>
						</div>
						
					<div class="row-box">
						<div style="width:142px;height:36px" >							
							<button  type="button" class="row-button add"></button>							
						</div>
					</div>
										
					<div class="row-box" id="rowMgrNm">
						<label class="title">*관리자명</label>
						<input type="text" class="form-text necessary" name="calculateName" placeholder="관리자명"/>
					</div>						

						<div class="row-box">
							<label class="title">관리자이메일</label>
							<input type="text" class="form-text" name="calculateEmail" placeholder="관리자이메일"/>
						</div>
						<div class="row-box">
							<label class="title">대표이미지</label>
							<input type="file" id="funeralImg" name="funeralImg" accept="image/*"/>
							<button type="button" class="imagebox funeral-img"></button>
						</div>
					</div>
					<div class="form-box-st-01 half">
						<div class="row-box">
							<label class="title">*대표자명</label>
							<input type="text" class="form-text necessary" name="bossName" placeholder="대표자명"/>
						</div>
						<div class="row-box">
							<label class="title">식장홈페이지</label>
							<input type="text" class="form-text" name="homepage" placeholder="홈페이지 주소"/>
						</div>
						
					<div class="row-box">
						<div class="btn-box">							
							<button type="button" class="mgrAdd" id="btnMgrAdd">관리자 추가</button>							
						</div>
					</div>
										
					<div class="row-box" id="rowMgrPhone">
						<label class="title">*관리자연락처</label>
						<input type="text" class="form-text necessary" name="calculateContact" placeholder="관리자연락처"/>
					</div>	
					
					<div class="row-box" id="nothingDiv">
							<label class="title">-</label>
							
						</div>
					
					<div class="row-box">							
						<label class="title">직인 이미지</label>
						<input type="file" id="sealImg" name="sealImg" accept="image/*"/>
						<button type="button" class="imagebox seal-img"></button>
					</div>					

					</div>
					<div class="form-box-st-01">
						<div class="row-box">
							<label class="title">로고 이미지</label>
							<input type="file" id="logoImg" name="logoImg" accept="image/*"/>
							<button type="button" class="imagebox logo-img"></button>
						</div>
						
						<div class="row-box">
							<label class="title">분할 이미지</label>
							<div class="div-divide">
								<input type="file" id="divide02" name="divide02" accept="image/*"/>
								<button type="button" class="imagebox divide-img"></button>
								
								<input type="file" id="divide04" name="divide04" accept="image/*"/>
								<button type="button" class="imagebox divide-img"></button>
								
								<input type="file" id="divide06" name="divide06" accept="image/*"/>
								<button type="button" class="imagebox divide-img"></button>
								
								<input type="file" id="divide08" name="divide08" accept="image/*"/>
								<button type="button" class="imagebox divide-img"></button>
							</div>
						</div>
					</div>
					
					<div class="form-box-st-01 half">
						<div class="row-box">
							<label class="title">*장애인편의시설</label>
							<input type="radio" class="form-text" name="disabledPersonFacility" value="1"/>
							<input type="radio" class="form-text" name="disabledPersonFacility" value="0"/>
						</div>
						<div class="row-box">
							<label class="title">*운영종류</label>
							<input type="radio" class="form-text" name="operationKind" value="1"/>
							<input type="radio" class="form-text" name="operationKind" value="0"/>
						</div>
						<div class="row-box">
							<label class="title">*빈소수</label>
							<input type="text" class="form-text necessary" name="funeralCnt" placeholder="빈소수"/>
						</div>
					</div>
					
					<div class="form-box-st-01 half">
						<div class="row-box">
							<label class="title">*유족휴게실</label>
							<input type="radio" class="form-text" name="waitingRoom" value="1"/>
							<input type="radio" class="form-text" name="waitingRoom" value="0"/>
						</div>
						<div class="row-box">
							<label class="title">*주차장가능대수</label>
							<input type="text" class="form-text necessary" name="parkingCnt" placeholder="주차장가능대수"/>
						</div>
					</div>
				</div>
			</div>
			<div class="pb-info-body half" style="padding:0px 0px 20px 10px;">
				<div id="map" style="height:832px;"></div>
			</div>
		</div>
	</form>
</div>
