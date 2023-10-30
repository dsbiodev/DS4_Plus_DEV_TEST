<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$('input[type=radio][name=flag]').pbRadiobox({ addText:['기독교', '천주교', '불교', '원불교', '국가유공자', '무교'], fontSize:'16px' });
		for(i=1; i<=14; i++){
			var _div = $('<div>');
			_div.append('<input type="radio" name="religion"><img src="http://211.251.237.150:7080/dsfiles/religion/christian/christian_'+i+'.png" value='+i+'>');
			$('.religion-wrap').find('.rel-box.christian').append(_div);
		}
		for(i=1; i<=19; i++){
			var _div = $('<div>');
			_div.append('<input type="radio" name="religion"><img src="http://211.251.237.150:7080/dsfiles/religion/catholic/catholic_'+i+'.png" value='+i+'>');
			$('.religion-wrap').find('.rel-box.catholic').append(_div);
		}
		for(i=1; i<=26; i++){
			var _div = $('<div>');
			_div.append('<input type="radio" name="religion"><img src="http://211.251.237.150:7080/dsfiles/religion/buddhism/buddhism_'+i+'.png" value='+i+'>');
			$('.religion-wrap').find('.rel-box.buddhism').append(_div);
		}
		
		for(i=1; i<=2; i++){
			var _div = $('<div>');
			_div.append('<input type="radio" name="religion"><img src="http://211.251.237.150:7080/dsfiles/religion/wonbuddhism/wonbuddhism_'+i+'.png" value='+i+'>');
			$('.religion-wrap').find('.rel-box.wonbuddhism').append(_div);
		}
		for(i=1; i<=10; i++){
			var _div = $('<div>');
			_div.append('<input type="radio" name="religion"><img src="http://211.251.237.150:7080/dsfiles/religion/merit/merit_'+i+'.png" value='+i+'>');
			$('.religion-wrap').find('.rel-box.merit').append(_div);
		}
		for(i=1; i<=11; i++){
			var _div = $('<div>');
			_div.append('<input type="radio" name="religion"><img src="http://211.251.237.150:7080/dsfiles/religion/etc/etc_'+i+'.png" value='+i+'>');
			$('.religion-wrap').find('.rel-box.etc').append(_div);
		}
		$('.religion-wrap').find('.rel-box div img').on('click', function(){
			$(this).siblings('input').click();
		});
		
		$.pb.ajaxCallHandler('/common/selectCommonCode.do', { target:'RELIGION' }, function(codeResult) {
			var _screenWrap = $('<div class="screen-wrap">');
			_screenWrap.append('<div class="screen-item-wrap"></div>');
			
			$.each(codeResult, function(idx) {
				var _this = this;
				var _screenItem = $('<div class="screen-item religion" data-religion-no="'+this.VALUE+'">');
				_screenItem.append('<input type="file"/>');
				_screenItem.append('<div class="image"></div>');
				_screenItem.append('<div class="title">'+this.KO+'</div>');
				_screenItem.css('margin-left', (idx%6 == 0 ? '0':''));
				_screenItem.on('click', function() { 
					$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
						_thisLayer.find('.register').val(_this.VALUE);
						_thisLayer.find('input[name=flag]').on('click', function(){
							_thisLayer.find('.religion-wrap .rel-box').removeClass('ac');
							if($(this).val() == 1) _thisLayer.find('.religion-wrap .rel-box.christian').addClass('ac');
							else if($(this).val() == 2) _thisLayer.find('.religion-wrap .rel-box.catholic').addClass('ac');
							else if($(this).val() == 3) _thisLayer.find('.religion-wrap .rel-box.buddhism').addClass('ac');
							else if($(this).val() == 4) _thisLayer.find('.religion-wrap .rel-box.wonbuddhism').addClass('ac');
							else if($(this).val() == 5) _thisLayer.find('.religion-wrap .rel-box.merit').addClass('ac');
							else _thisLayer.find('.religion-wrap .rel-box.etc').addClass('ac');
						});
						$('input[name=flag][value='+_this.VALUE+']').click();
					});
				});
				
				_screenWrap.find('.screen-item-wrap').append(_screenItem);
			});
			
			$.pb.ajaxCallHandler('/admin/selectStatusPlateBg.do', { funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}' }, function(bgRst) {
				$.each(bgRst, function() {
					var _rTarget = $('.screen-item[data-religion-no="'+this.RELIGION_NO+'"]');
					if(_rTarget.length) {
						_rTarget.find('.image').css('background-image', 'url("'+this.FILE+'")');
					}
					var _this = this;
					if(this.FILE.indexOf('christian') != -1) {
						$('.row-box').find('input[name=flag]:eq(0)').click();
						$('.religion-wrap .rel-box').removeClass('ac');
						$('.religion-wrap .rel-box.christian').addClass('ac');
					} else if(this.FILE.indexOf('catholic') != -1){
						$('.row-box').find('input[name=flag]:eq(1)').click();
						$('.religion-wrap .rel-box').removeClass('ac');
						$('.religion-wrap .rel-box.catholic').addClass('ac');
					} else if(this.FILE.indexOf('buddhism') != -1){
						$('.row-box').find('input[name=flag]:eq(2)').click();
						$('.religion-wrap .rel-box').removeClass('ac');
						$('.religion-wrap .rel-box.buddhism').addClass('ac');
					} else if(this.FILE.indexOf('wonbuddhism') != -1){
						$('.row-box').find('input[name=flag]:eq(3)').click();
						$('.religion-wrap .rel-box').removeClass('ac');
						$('.religion-wrap .rel-box.wonbuddhism').addClass('ac');
					} else if(this.FILE.indexOf('merit') != -1){
						$('.row-box').find('input[name=flag]:eq(4)').click();
						$('.religion-wrap .rel-box').removeClass('ac');
						$('.religion-wrap .rel-box.merit').addClass('ac');
					} else{
						$('.row-box').find('input[name=flag]:eq(5)').click();
						$('.religion-wrap .rel-box').removeClass('ac');
						$('.religion-wrap .rel-box.etc').addClass('ac');
					}
					$('.religion-wrap').find('img').each(function(){
						if($(this).attr('src') == _this.FILE)
							$(this).siblings('input[name=religion]').click();
					});
				});
			});
			
			$('.register').on('click', function(){
				var _formObj = new FormData();
				_formObj.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formObj.append('religionNo', $(this).val());
				_formObj.append('file', $('.religion-wrap input[name=religion]:checked').siblings('img').attr('src'));
				_formObj.append('selClass', 10);
				$.pb.ajaxUploadForm('/admin/insertStatusPlateBg.do', _formObj, function(result) {
					if(result) location.reload();
					else alert('업로드 실패');
				}, '${sessionScope.loginProcess}');
			});
			
			$('#btnRegister').on('click', function() {
				if(confirm('종교이미지를 초기화 하시겠습니까?')) {
					var _formObj = new FormData();
					_formObj.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
					$.pb.ajaxUploadForm('/admin/resetStatusPlateBg.do', _formObj, function(result) {
						if(result) location.reload();
						else alert('업로드 실패');
					}, '${sessionScope.loginProcess}');
				}
			});
			
			
			$('.contents-body-wrap').append(_screenWrap);
			$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
		});
	});
</script>
<style>
	.screen-wrap > .screen-item-wrap > .screen-item.religion { padding:0; width:calc(100% / 6 - 18px); }
	.screen-wrap > .screen-item-wrap > .screen-item.religion:hover { background:#FFFFFF; }
	.screen-wrap > .screen-item-wrap > .screen-item.religion > .image { height:200px; box-sizing:border-box; border-bottom:1px solid #B2B2B2; background-color:#F6F6F6; background-image:url('/resources/img/icon_image_attach.svg'); background-repeat:no-repeat; background-position:50%; }
	.screen-wrap > .screen-item-wrap > .screen-item.religion > .title { padding:25px 0 26px 0; }
	
	@media ( max-width: 800px ) {
		.screen-wrap > .screen-item-wrap > .screen-item.religion { padding:0px; width:calc(100% / 2 ); margin:0px; }
		.pb-popup-body > .popup-body-top > .top-button-wrap > .top-button { width:90px; }
		.pb-popup-form > .form-box-st-01 > .row-box > label.title { width:70px; }
		.pb-popup-form > .form-box-st-01 > .religion-wrap .rel-box > div > img { width:90px; height:90px;}
		.pb-popup-form > .form-box-st-01 > .religion-wrap { padding:0px; width:100%; }
		.pb-popup-form > .form-box-st-01 > .religion-wrap .rel-box > div { margin:0px; }
		.pb-popup-form > .form-box-st-01 > .religion-wrap .rel-box { text-align:center; }
	}
</style>

<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">종교이미지 관리</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">종교 이미지</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
					<button type="button" class="top-button delete">삭제</button>
				</div>
			</div>
			
			<div class="pb-popup-form">
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">구분</label>
						<input type="radio" name="flag" value="1">
						<input type="radio" name="flag" value="2">
						<input type="radio" name="flag" value="3">
						<input type="radio" name="flag" value="4">
						<input type="radio" name="flag" value="5">
						<input type="radio" name="flag" value="6">	
					</div>
				</div>
				
				<div class="form-box-st-01">
					<div class="religion-wrap">
						<div class="rel-box christian"></div>
						<div class="rel-box catholic"></div>
						<div class="rel-box buddhism"></div>
						<div class="rel-box wonbuddhism"></div>
						<div class="rel-box merit"></div>
						<div class="rel-box etc"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<div class="contents-title-wrap">
	<div class="title">종교이미지 관리</div>
	<div class="title-right-wrap">
		<button type="button" class="title-button" id="btnRegister">종교이미지 초기화</button>
	</div>
</div>
<div class="contents-body-wrap">
</div>