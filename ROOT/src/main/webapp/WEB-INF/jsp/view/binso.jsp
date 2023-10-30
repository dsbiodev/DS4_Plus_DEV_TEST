<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:10):0);
		searchObj.display = (_param.display ? _param.display:10);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.order = 'APPELLATION ASC';
		var _table = $('.binso-list');
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectBinsoList.do', _searchObj, function(tableData) {
				_table.html('');
				$.each(tableData.list, function(idx) {
					var _div = $('<div class="binso-box">');
					_div.data(this);
					_div.append('<div class="appellation">'+this.APPELLATION+'</div>');
					_div.append('<div class="floor">'+this.FLOOR+'</div><div class="area-size">'+this.AREA_SIZE+'</div>');

					if(this.MAIN_IMG) _div.append('<div class="binso-img-box"><img src='+this.MAIN_IMG+'></div>');
					else _div.append('<div class="binso-img-box d"><img src="/resources/img/btn_img_basic.svg"></div>');
						
					_div.on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').val(_div.data('RASPBERRY_CONNECTION_NO'));
							layerInit(_thisLayer, _div.data());
							$.pb.ajaxCallHandler('/adminSec/selectBinsoImgList.do', {respberryConnectionNo : _div.data('RASPBERRY_CONNECTION_NO')}, function(data) {
								$('.binso-img').removeClass('add').html("");
								$.each(data.list, function(idx) {
									$('.binso-img:eq('+idx+')').data(this);
									$('.binso-img:eq('+idx+')').addClass('add').html('<img src='+this.PATH+' class="images"/>');
								});

							});
						});
					});
					_table.append(_div);
				});
				
				_searchObj.total = tableData.total;
				$('.contents-body-wrap > .paging').createPaging(_searchObj, function(_page) {
					var pageObj = _searchObj;
		        	pageObj.pk = _page;
		        	pageObj.currentPage = _page;
		        	pageObj.queryPage = (_page-1)*(_searchObj.display*1);
		        	
					var _urlSplit = $(location)[0].pathname.split('/');
					history.pushState({ paging:pageObj }, '', '/'+_urlSplit[1]+'/'+pageObj.currentPage);
					createTable(pageObj);
		        });
				
				_table.tableEmptyChecked('검색 결과가 없습니다.');
			});
		};createTable(searchObj);
		
		
		$('.binso-img').bind('click', function() {
			if($(this).hasClass('add')){
				$(this).prev('input[type=file][id=binsoImg]').val("");
				$(this).removeClass('add').html("");
			}else $(this).prev('input[type=file][id=binsoImg]').click();
		});
		
		$("input[type=file][id=binsoImg]").bind("change", function() {
			var $this = $(this);
			var $files = $this[0].files;
			$.each($files, function() {
				var reader = new FileReader();
				var f = this;
				reader.onload = function(rst) {
					$this.next('.binso-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
				};
				reader.readAsDataURL(f);
			});
		});
		
		$('.register').on('click', function(){
			if(!necessaryChecked($('#dataForm'))) {
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('respberryConnectionNo', $(this).val());
				_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
				var _imgList = [];
				$('.binso-img').each(function(){
					if($(this).find('img').length && !$(this).prev('input').val()){
						var $list = {
								fileKey : $(this).prev('input').attr('name'),
								fileFullPath : $(this).data('PATH')
						}
						_imgList.push($list);
					}
				});
				_formData.append('imgList', JSON.stringify(_imgList));
	 			
				$.pb.ajaxUploadForm('/adminSec/updateBinso.do', _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						createTable(searchObj);
						$('.top-button-wrap').find('button').prop('disabled', false);
						$('.pb-popup-close').click();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}else{
				if(!$('input[name=appellation]').val()) return alert("빈소명을 입력해 주세요.");
			}
			
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	.binso-list { }
	.binso-list .binso-box { box-sizing:border-box; display:inline-block; width:20%; padding:10px; text-align:center; font-size:16px; font-weight:500; cursor:pointer; vertical-align:top; }
	.binso-list .binso-box .appellation { background:linear-gradient(to bottom, #FFFFFF, #EBEDEE); border:1px solid #707070; border-bottom:none; padding:3px 0px; font-size:23px; }
	.binso-list .binso-box .floor { background:linear-gradient(to bottom, #FFFFFF, #EBEDEE); border:1px solid #707070; width:50%; display:inline-block; box-sizing:border-box; padding:9px 0px; min-height:44px; vertical-align:top; }
	.binso-list .binso-box .area-size { background:linear-gradient(to bottom, #FFFFFF, #EBEDEE); border:1px solid #707070; width:50%; display:inline-block; box-sizing:border-box; border-left:none; padding:9px 0px; min-height:44px; vertical-align:top; }	
	.binso-list .binso-box .binso-img-box { background:#FFF; border:1px solid #707070; border-top:none; height:194px; position:relative; }
	.binso-list .binso-box .binso-img-box img{ position:absolute; top:50%; left:50%; transform:translateX(-50%) translateY(-50%); max-width:100%; max-height:100%; }
	.binso-list .binso-box .binso-img-box.d:before { content:"빈소이미지"; position:absolute; color:#707070; bottom:50px; width:100%; left:0; }
	
	
	@media ( max-width: 700px ) {

  		.binso-list .binso-box { width:48%; }
  		.pb-popup-body > .popup-body-top > .top-button-wrap > .top-button { width:90px; }
  		.pb-popup-form > .form-box-st-01 > .row-box > label.title { width:46%; font-size:12px; }
  		.pb-popup-form > .form-box-st-01 > .row-box > .form-text { width:52%; }
	}
	
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">빈소정보변경</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">빈소이미지(16:9)</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			
			
			<div class="pb-popup-form">
				<div class="form-box-st-01" style="padding:0px 10px;">
					<div class="row-box" style="display:flex;">
						<input type="file" id="binsoImg" name="binso01" accept="image/*"/>
						<button type="button" class="imagebox binso-img main"></button>
						<input type="file" id="binsoImg" name="binso02" accept="image/*"/>
						<button type="button" class="imagebox binso-img"></button>
						<input type="file" id="binsoImg" name="binso03" accept="image/*"/>
						<button type="button" class="imagebox binso-img"></button>
						<input type="file" id="binsoImg" name="binso04" accept="image/*"/>
						<button type="button" class="imagebox binso-img"></button>
						<input type="file" id="binsoImg" name="binso05" accept="image/*"/>
						<button type="button" class="imagebox binso-img"></button>
					</div>
				</div>
			</div>
			
			<div class="popup-body-top" style="margin-top:20px;">
				<div class="top-title">빈소 세부정보</div>
			</div>
			
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">*빈소명</label>
						<input type="text" class="form-text necessary" name="appellation" placeholder="빈소명을 입력하세요."/>
					</div>
					<div class="row-box">
						<label class="title">층수</label>
						<input type="text" class="form-text" name="floor" placeholder="층수(숫자만 입력해 주세요.)"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">건물명</label>
						<input type="text" class="form-text" name="buildingName" placeholder="건물명"/>
					</div>
					<div class="row-box">
						<label class="title">평형</label>
						<input type="text" class="form-text" name="areaSize" placeholder="평형"/>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">빈소관리</div>
	<div>빈소정보를 관리할 수 있습니다.</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">빈소목록</div>
	</div>
</div>
<div class="contents-body-wrap">
	<div class="binso-list"></div>
	<div class="paging"></div>
</div>