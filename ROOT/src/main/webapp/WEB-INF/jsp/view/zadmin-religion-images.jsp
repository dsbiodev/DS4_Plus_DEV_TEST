<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$('input[type=radio][name=flag]').pbRadiobox({ addText:['기독교', '천주교', '불교', '기타'], fontSize:'16px' });
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
		for(i=1; i<=11; i++){
			var _div = $('<div>');
			_div.append('<input type="radio" name="religion"><img src="http://211.251.237.150:7080/dsfiles/religion/etc/etc_'+i+'.png" value='+i+'>');
			$('.religion-wrap').find('.rel-box.etc').append(_div);
		}
		$('.religion-wrap').find('.rel-box div img').on('click', function(){
			$(this).siblings('input').click();
		});
		
		
		$.pb.ajaxCallHandler('/adminSec/selectFuneralList.do', { }, function(funeralData) {
			$('.select-box-wrap .allList tbody').append('<tr><td>선택해주세요</td>');
			$.each(funeralData.list, function(){
				var _tr = $('<tr>').data(this);
				_tr.append('<td value='+this.FUNERAL_NO+'>'+this.FUNERAL_NAME+'('+this.GUNGU_NAME+')</td>');
				$('.select-box-wrap .allList').find('tbody').append(_tr);
			});
			$('.select-box-wrap .allList tbody tr').on('click', function(){
				$('.select-box-wrap .allList tr').removeClass('ac');
				$(this).addClass('ac');
				
				if($(this).data('FUNERAL_NO')){
					$('.select-box-wrap .table-search').val($(this).find('td').text());
					$('.select-box-wrap .table-search').data('funeralNo', $(this).data('FUNERAL_NO'));
						createTable();
					}else{
					$('.select-box-wrap .table-search').val("");
					$('.select-box-wrap .table-search').data('funeralNo', null);
					$('.contents-body-wrap').html("");
				}
			});
			
			$('.select-box-wrap .table-search').on('keyup', function() {
				$('.select-box-wrap .allList > tbody > tr').removeClass('ac');
				$('.select-box-wrap .allList > tbody > tr').hide();
				if($(this).val()) $('.select-box-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
				else $('.select-box-wrap .allList > tbody > tr').show();
			});
		});
		
		
		
		var createTable = function(){
			$('.contents-body-wrap').html("");
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
					
// 					if(this.VALUE != 6){
// 						_screenItem.on('click', function() { 
// 							$(this).addClass('active').siblings('.screen-item.religion').removeClass('active');
// 							$('input[name=backgroundFile]').trigger('click'); 
// 						});
// 					}else{
						_screenItem.on('click', function() { 
							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
								_thisLayer.find('.register').val(_this.VALUE);
								_thisLayer.find('input[name=flag]').on('click', function(){
									_thisLayer.find('.religion-wrap .rel-box').removeClass('ac');
									if($(this).val() == 1) _thisLayer.find('.religion-wrap .rel-box.christian').addClass('ac');
									else if($(this).val() == 2) _thisLayer.find('.religion-wrap .rel-box.catholic').addClass('ac');
									else if($(this).val() == 3) _thisLayer.find('.religion-wrap .rel-box.buddhism').addClass('ac');
									else _thisLayer.find('.religion-wrap .rel-box.etc').addClass('ac');
								});
							});
						});
// 					}
					_screenWrap.find('.screen-item-wrap').append(_screenItem);
				});

				$.pb.ajaxCallHandler('/admin/selectStatusPlateBg.do', { funeralNo:$('.select-box-wrap .table-search').data('funeralNo') }, function(bgRst) {
					$.each(bgRst, function() {
						var _rTarget = $('.screen-item[data-religion-no="'+this.RELIGION_NO+'"]');
						if(_rTarget.length) {
							_rTarget.find('.image').css('background-image', 'url("'+this.FILE+'")');
						}
// 						if(this.RELIGION_NO == 6){
							var _this = this;
							if(this.FILE.indexOf('christian') != -1){
								$('.row-box').find('input[name=flag]:eq(0)').click();
								$('.religion-wrap .rel-box').removeClass('ac');
								$('.religion-wrap .rel-box.christian').addClass('ac');
							}else if(this.FILE.indexOf('catholic') != -1){
								$('.row-box').find('input[name=flag]:eq(1)').click();
								$('.religion-wrap .rel-box').removeClass('ac');
								$('.religion-wrap .rel-box.catholic').addClass('ac');
							}else if(this.FILE.indexOf('buddhism') != -1){
								$('.row-box').find('input[name=flag]:eq(2)').click();
								$('.religion-wrap .rel-box').removeClass('ac');
								$('.religion-wrap .rel-box.buddhism').addClass('ac');
							}else{
								$('.row-box').find('input[name=flag]:eq(3)').click();
								$('.religion-wrap .rel-box').removeClass('ac');
								$('.religion-wrap .rel-box.etc').addClass('ac');
							}
							$('.religion-wrap').find('img').each(function(){
								if($(this).attr('src') == _this.FILE)
									$(this).siblings('input[name=religion]').click();
							});
// 						}
					});
				});
				
				$('.register').on('click', function(){
					var _formObj = new FormData();
					_formObj.append('funeralNo', $('.select-box-wrap .table-search').data('funeralNo'));
					_formObj.append('religionNo', $(this).val());
					_formObj.append('file', $('.religion-wrap input[name=religion]:checked').siblings('img').attr('src'));
					_formObj.append('selClass', 10);
					$.pb.ajaxUploadForm('/admin/insertStatusPlateBg.do', _formObj, function(result) {
						if(result) location.reload();
						else alert('업로드 실패');
					}, '${sessionScope.loginProcess}');
				});
				$('.contents-body-wrap').append(_screenWrap);
			});
		};

		//$('.contents-body-wrap').append(_screenWrap);
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	.screen-wrap > .screen-item-wrap > .screen-item.religion { padding:0; width:calc(100% / 6 - 18px); }
	.screen-wrap > .screen-item-wrap > .screen-item.religion:hover { background:#FFFFFF; }
	.screen-wrap > .screen-item-wrap > .screen-item.religion > .image { height:200px; box-sizing:border-box; border-bottom:1px solid #B2B2B2; background-color:#F6F6F6; background-image:url('/resources/img/icon_image_attach.svg'); background-repeat:no-repeat; background-position:50%; background-position:50%; }
	.screen-wrap > .screen-item-wrap > .screen-item.religion > .title { padding:25px 0 26px 0; }
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">종교 이미지관리</div>
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
					</div>
				</div>
				
				<div class="form-box-st-01">
					<div class="religion-wrap">
						<div class="rel-box christian ac"></div>
						<div class="rel-box catholic"></div>
						<div class="rel-box buddhism"></div>
						<div class="rel-box etc"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<div class="select-box-wrap">
	<input type="text" class="form-text table-search">
	<div class="funeral-box">
		<table class="allList">
			<colgroup><col width="100%"/></colgroup>
			<tbody></tbody>
		</table>
	</div>
</div>

<div class="contents-title-wrap">
	<div class="title">종교이미지 관리</div>
</div>
<div class="contents-body-wrap">
	<input type="file" name="backgroundFile"/>
</div>