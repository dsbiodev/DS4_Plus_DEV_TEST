<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script src="/resources/js/compressor.js"></script>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.photoManagerNo = ('${sessionScope.loginProcess.LV}' == 39 ? '${sessionScope.loginProcess.USER_NO}':'');
		searchObj.order = 'FUNERAL_NAME DESC';
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };
		theadObj.colGroup = new Array(5, 25, 15, '*');
		theadObj.theadRow = new Array(['', '번호'], ['FUNERAL_NAME', '장례식장'], ['BOSS_NAME', '대표자'], ['ADDRESS', '주소']);
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj);
		});
		
		$('#dmPhotoEdit').on('change', function() {
			var _ = $(this);
			var _regex = /(\.png|\.jpg|\.jpeg|\.gif)$/i;
			
			if(_.val()) {
				
				var _fileName = _[0].files[0].name;
				
				var _fileSize = _[0].files[0].size;
				var maxSize= 15*1024*1024;
				
				
				if(_regex.test(_fileName) == false) { 
					alert("파일 형식이 올바르지 않습니다");
					$(this).val('');
				}
				
				/* HYH - 영정 파일 용량 체크 추가 
					220414 이미지 체크 주석처리
				*/
								
				else if(_fileSize > maxSize){
					$(this).val('');
					return alert("파일 용량이 15MB 이상입니다. \n15MB 이하의 파일만 가능합니다.");
				}
				
				else {
					$.each(_[0].files, function(idx) {
						var _thisFile = this;
						var reader = new FileReader();
						reader.onload = function(rst) {
							var _target = $('.photo-item > .photo.run');
							var _formData = new FormData();
							_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
							_formData.append('funeralNo', _target.parent('.photo-item').data('FUNERAL_NO'));
							_formData.append('eventNo', _target.parent('.photo-item').data('EVENT_NO'));
							_formData.append('dmPhoto', _thisFile);
							_formData.append('updatePhoto', true); // 영정사진 수정인지 로테이션 수정인지 구분값
							
							$('.ajax-loading').show();
							
							$.pb.ajaxUploadForm('/admin/updatePhotoManager.do', _formData, function(result) {
								$('.ajax-loading').hide();
								if(result) {
									
									console.log(result);
									
									//220414 이미지 체크 결과처리
									if(result == "9999"){
										return alert("파일 용량이 2MB 이상입니다.\n2MB 이하의 파일만 가능합니다.");
									}									
																		
									_target.css('background-image', 'url(\''+rst.target.result+'\')').addClass('ac');
									alert('저장완료');
								} else alert('저장 실패 관리자에게 문의하세요');
							}, true);
							
							$('#dmPhotoEdit').val('');
						};
						
						reader.readAsDataURL(_thisFile);
					});
				}
			}
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectPhotoManagerList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx;
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td class="c">'+isNull(this.BOSS_NAME, '-')+'</td>');
					_tr.append('<td class="c">'+this.ADDRESS+'</td>');
					_tr.on('click', function(e) {
						$.pb.ajaxCallHandler('/admin/selectEventList.do', { funeralNo:_tr.data('FUNERAL_NO'), statusPlate:true, eventAliveFlag:true, order:'EXPOSURE ASC, APPELLATION ASC' }, function(binsoList) {
							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
								_thisLayer.find('.top-button.register').val('');
								_thisLayer.find('.pb-popup-title').html(_tr.data('FUNERAL_NAME'));
								
								$('.photo-item-wrap').html('');
								$.each(binsoList.list, function() {
									var _item = $('<div class="photo-item"></div>');
									_item.data(this);
									
									_item.append('<div style="background-image:url(\'/resources/img/dead_man_default.svg\');" class="photo"></div>');
									if(this.DM_PHOTO) _item.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
									if(this.DM_PHOTO_ROTATION) _item.find('.photo').addClass('rotation');
									_item.find('.photo').on('click', function() { 
										$('.photo-item > .photo').removeClass('run');
										$('#dmPhotoEdit').trigger('click');
										$(this).addClass('run');
									});
									
									_item.append('<div class="photo-info"><div class="info">'+this.APPELLATION+'<br/>'+isNull(this.DM_NAME, '-')+'</div></div>');
									_item.append('<button type="button" class="transform">이미지회전</button>');
									_item.find('button.transform').on('click', function() {
										if($(this).siblings('.photo').hasClass('rotation')) $(this).siblings('.photo').removeClass('rotation');
										else $(this).siblings('.photo').addClass('rotation');
										var _formData = new FormData();
										_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
										_formData.append('funeralNo', _item.data('FUNERAL_NO'));
										_formData.append('eventNo', _item.data('EVENT_NO'));
										_formData.append('dmPhotoRotation', ($(this).siblings('.photo').hasClass('rotation') ? 180:''));
										$.pb.ajaxUploadForm('/admin/updatePhotoManager.do', _formData, function(result) {
											if(result) {
												alert('저장완료');
											} else alert('저장 실패 관리자에게 문의하세요');
										}, true);
									});
									
									$('.photo-item-wrap').append(_item);
								});
							});
						});
					});
					
					_table.find('tbody').append(_tr);
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
		};
		createTable(searchObj);
		
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	.popup-body-top > .top-title > .text-row { color:#707070; font-size:16px; font-weight:500; letter-spacing:0.8px; }
	.photo-item-wrap { padding:0 10px; font-size:0; text-align:left; }
	.photo-item-wrap > .photo-item { width:calc(50% - 20px); height:126px; box-sizing:border-box; display:inline-block; margin:20px 10px 0 10px; border:1px #707070 solid; vertical-align:top; }
	.photo-item-wrap > .photo-item > .photo { width:100px; height:100%; box-sizing:border-box; display:inline-block; border-right:1px solid #707070; background-repeat:no-repeat; background-size:cover; cursor:pointer; background-size: 100% 100%; }
	.photo-item-wrap > .photo-item > .photo.rotation { transform:rotate(180deg); }
	.photo-item-wrap > .photo-item > .photo-info { width:calc(100% - 200px); height:100%; display:inline-block; color:#333333; font-size:22px; font-weight:500; text-align:center; letter-spacing:1.1px; vertical-align:top; }
	.photo-item-wrap > .photo-item > .photo-info > .info { margin-top:27px; }
	.photo-item-wrap > .photo-item > .transform { width:100px; height:100%; box-sizing:border-box; display:inline-block; padding-top:64px; border-left:1px solid #707070; background-image:url('/resources/img/icon_rotation.svg'); background-color:#FAFAFA; background-repeat:no-repeat; background-position:center 20px; color:#333333; font-size:16px; font-weight:500; vertical-align:top; }
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title"></div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title" style="padding:0;">
					<div class="text-row">규격 : 11R [가로 - 11인치(28cm)] [세로 - 14인치(36cm)]</div>
					<div class="text-row">파일 : jpg, png 등</div>
				</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<input type="file" id="dmPhotoEdit"/>
				<div class="photo-item-wrap"></div>
			</div>
		</div>
	</div>
</form>
<div class="contents-title-wrap">
	<div class="title">영정관리</div>
	<div class="title-right-wrap">
<!-- 		<button type="button" class="title-button" id="btnRegister">신규등록</button> -->
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">장례식장 목록</div>
	</div>
<!-- 	<div class="search-right-wrap"> -->
<!-- 		<input type="text" class="search-text rb" placeholder="업체명, 담당자, 아이디로 검색"/> -->
<!-- 		<button type="button" class="search-text-button">검색</button> -->
<!-- 	</div> -->
</div>
<div class="contents-body-wrap">
	<table class="pb-table list">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>