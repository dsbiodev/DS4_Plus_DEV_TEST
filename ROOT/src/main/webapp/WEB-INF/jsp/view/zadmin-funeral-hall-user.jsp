<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
// 		searchObj.lv = (_param.lv == 90 ? '90, 91':_param.lv);
		searchObj.lv = 20;
// 		searchObj.funeralNo = (_param.funeralNo ? _param.funeralNo:'');
		searchObj.order = 'FUNERAL_NO DESC';
		
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
						searchObj.funeralNo = $(this).data('FUNERAL_NO');
						createTable(searchObj);
					}else{
					$('.select-box-wrap .table-search').val("");
					$('.select-box-wrap .table-search').data('funeralNo', null);
						$('.pb-table.list tbody').html("");
						$('.paging').html("");
					}
			});
			
			$('.select-box-wrap .table-search').on('keyup', function() {
				$('.select-box-wrap .allList > tbody > tr').removeClass('ac');
				$('.select-box-wrap .allList > tbody > tr').hide();
				if($(this).val()) $('.select-box-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
				else $('.select-box-wrap .allList > tbody > tr').show();
			});
		});
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };

		
		
// 		$.pb.ajaxCallHandler('/common/selectAllMenu.do', { funeralNo:(_param.lv == 20 ? '${sessionScope.loginProcess.FUNERAL_NO}':''), lv:(_param.lv == 20 ? 29:_param.lv) }, function(menuData) {
		$.pb.ajaxCallHandler('/common/selectAllMenu.do', { funeralNo:$('.select-box-wrap .table-search').data('funeralNo'), lv:29 }, function(menuData) {
			$('.pb-right-popup-wrap .menu-tree').crtMenuTree(menuData);
// 			if(_param.lv == 20) {
				$.each($('.menu-tree').find('.item.parents'), function(idx) {
					var _menuNo = $(this).data('menu-no');
					if(!$('.item.child[data-parents="'+_menuNo+'"]').length) $(this).remove();
				});
// 			}
		});
		
// 		$('.pb-right-popup-wrap input[name=id]').on('keyup', function(){ $(this).val($(this).val().replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/gi, '')); });
		$('.pb-right-popup-wrap input[name=id]').on('change', function() {
			var _ = $(this);
			var _inputId = $(this).val();
			$.pb.ajaxCallHandler('/common/overlapChecked.do', { userId:_inputId }, function(result) { 
				if(result) _.siblings('.pb-warning').hide();
				else _.siblings('.pb-warning').show();
			});
		});
		
		$('input[type=radio][name=aliveFlag]').siteRadio({addText:['활성', '비활성']});
		$('.form-text.tel').phoneFomatter();
		
		var menuTreeControll = function(_tr) {
			var _calculate = new Array(290201,290202,290203,290204,290301,290701);
			$('#funeralMenuTitle').html(_tr.data('CALCULATE_FLAG') ? '해당 장례식장은 정산 사용 장례식장입니다.':'해당 장례식장은 정산 <span style="color:red;">미사용</span> 장례식장입니다.');
			
			$('.menu-tree .item').removeClass('calculate');
			if(!_tr.data('CALCULATE_FLAG')) {
				$.each(_calculate, function(idx, _value){
					$('.menu-tree .item[data-menu-no="'+_value+'"]').addClass('calculate');
				});
			}
		};
		
		var crtFuneralHallList = function(_lv) {
			var _obj = { overlap:true, order:'FUNERAL_NAME ASC' };
			if(_lv == 29) _obj.registerFlag = true;
			
			$('.pb-right-popup-wrap .pb-table.list > tbody').html('');
			$.pb.ajaxCallHandler('/admin/selectAllFuneralHallList.do', _obj, function(result) {
				$.each(result.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this).addClass(idx%2 ? 'alt':'').attr('data-funeral-no', this.FUNERAL_NO).attr('data-manager-no', this.MANAGER_NO);
					
					_tr.append('<td>'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td>'+this.ADDRESS+'</td>');
					_tr.on('click', function() {
// 						if(_param.lv == 29) {
// 							$('input[name=funeralNo]').val($(this).data('FUNERAL_NO'));
// 							$(this).addClass('ac').siblings('tr').removeClass('ac');
							
// 							menuTreeControll(_tr);
// 							$('.menu-tree').show();
// 						}
					});

					$('.pb-right-popup-wrap .pb-table.list > tbody').append(_tr);
				});
			});
		};
		
// 		if(_param.lv == 20) {
			$('.contents-title-wrap > .title, .pb-popup-title').html('직원관리');
			theadObj.colGroup = new Array(5, 15, '*', 15, 15, 15);
			theadObj.theadRow = new Array(['', '번호'], ['', '이름'], ['ID', '아이디'], ['', '연락처'], ['', '담당구역'], ['CREATE_DT', '생성일']);
			
			$('input[name=lv]').parents('.row-box').remove();
			$('#funeralMenuTitle').html('장례식장을 선택해주세요.');
			$('.pb-popup-form.modify, .pb-right-popup-wrap .table-search.icon-search').remove();
			
			$('.pb-popup-form:eq(0) > .form-box-st-01.half:eq(0)').append('<div class="row-box"><label class="title">역할</label><input type="text" class="form-text" name="userRole"/></div>')
// 		} else if(_param.lv == 29) {
// 			$('.contents-title-wrap > .title, .pb-popup-title').html('장례식장 계정 관리');
// 			theadObj.colGroup = new Array(5, '*', 12, 10, 15, 10, 10, 15);
// 			theadObj.theadRow = new Array(['', '번호'], ['FUNERAL_NAME', '업체명'], ['LV', '구분'], ['NAME', '담당자'], ['ID', '아이디'], ['ALIVE_FLAG', '계정상태'], ['CALCULATE_FLAG', '정산이용 여부'], ['CREATE_DT', '생성일']);
			
// 			$('input[name=lv]').parents('.row-box').remove();
// 			$('#funeralMenuTitle').html('장례식장을 선택해주세요.');
// 		} else if(_param.lv == 90) {
// 			$('.contents-title-wrap > .title, .pb-popup-title').html('동성바이오 계정 관리');
// 			theadObj.colGroup = new Array(5, 15, 10, '*', 15, 15, 10, 15);
// 			theadObj.theadRow = new Array(['', '번호'], ['LV', '구분'], ['NAME', '담당자'], ['ID', '아이디'], ['PHONE', '연락처'], ['', '관리장례식장 수'], ['ALIVE_FLAG', '계정상태'], ['CREATE_DT', '생성일']);
			
// 			$('input[name=lv]').siteRadio({addText:['영업직','비영업직']});
// 			$('.pb-right-popup-wrap .pb-table-wrap').css('height', 'calc(100% - 282px)').css('margin-top', '20px').hide();
// 			$('.pb-popup-form.modify, input[name=funeralNo], .pb-right-popup-wrap .table-search.icon-search').remove();
// 			$('#funeralMenuTitle').html('동성바이오 직원의 권한을 설정할 수 있습니다.');
// 		}
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj); 
		});
		
		$('.search-box-wrap .search-text-button').on('click', function() {
			searchObj.currentPage = 1;
			searchObj.queryPage = 0;
			searchObj.searchText = $(this).prev('.search-text').val();
			
			var _pageData = { paging:searchObj };
			var _urlSplit = $(location)[0].pathname.split('/');
			history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
			createTable(searchObj);
		});
		
		$('.search-box-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) $(this).next('.search-text-button').trigger('click');
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/common/selectUserInfoList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx;
					
					_tr.append('<td class="c">'+_tableNo+'</td>');
					
// 					if(_param.lv == 20) {
						_tr.append('<td class="c">'+this.NAME+'</td>');
						_tr.append('<td>'+this.ID+'</td>');
						_tr.append('<td class="c">'+$.pb.phoneFomatter(this.PHONE)+'</td>');
						_tr.append('<td class="c">'+isNull(this.USER_ROLE, '-')+'</td>');
						_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
						_tr.on('click', function() {
							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
								_thisLayer.find('.top-button.register').val(_tr.data('USER_NO'));
								_thisLayer.find('.pb-popup-form.modify').show().find('#funeralName').val(_tr.data('FUNERAL_NAME'));
								_thisLayer.find('.table-search.icon-search, .pb-table-wrap').hide();
								_thisLayer.find('.menu-tree .folder.unfold').trigger('click');
								_thisLayer.find('.menu-tree > .item > .check-box').removeClass('checked half');
								_thisLayer.find('input[name=id]').attr('disabled', true);
								
								menuTreeControll(_tr);
								if(_tr.data('USER_MENU_NO')) {
									$.each(_tr.data('USER_MENU_NO').split(','), function(idx, _value) {
										_thisLayer.find('.menu-tree > .item[data-menu-no="'+_value+'"]').find('.check-box').trigger('click');
									});
								}
	
								layerInit(_thisLayer, _tr.data());
							});
						});
// 					} else if(_param.lv == 29) {
// 						_tr.append('<td>'+this.FUNERAL_NAME+'</td>');
// 						_tr.append('<td class="c">'+this.NAME+'</td>');
// 						_tr.append('<td class="c">'+this.NAME+'</td>');
// 						_tr.append('<td>'+this.ID+'</td>');
// 						_tr.append('<td class="c">'+(this.ALIVE_FLAG ? '활성':'비활성')+'</td>');
// 						_tr.append('<td class="c">'+(this.CALCULATE_FLAG ? '사용':'미사용')+'</td>');
// 						_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
// 						_tr.on('click', function() {
// 							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
// 								_thisLayer.find('.top-button.register').val(_tr.data('USER_NO'));
// 								_thisLayer.find('.pb-popup-form.modify').show().find('#funeralName').val(_tr.data('FUNERAL_NAME'));
// 								_thisLayer.find('.table-search.icon-search, .pb-table-wrap').hide();
// 								_thisLayer.find('.menu-tree .folder.unfold').trigger('click');
// 								_thisLayer.find('.menu-tree > .item > .check-box').removeClass('checked half');
// 								_thisLayer.find('input[name=id]').attr('disabled', true);
								
// 								menuTreeControll(_tr);
// 								if(_tr.data('USER_MENU_NO')) {
// 									$.each(_tr.data('USER_MENU_NO').split(','), function(idx, _value) {
// 										_thisLayer.find('.menu-tree > .item[data-menu-no="'+_value+'"]').find('.check-box').trigger('click');
// 									});
// 								}
	
// 								layerInit(_thisLayer, _tr.data());
// 							});
// 						});
// 					} else if(_param.lv == 90) {
// 						_tr.append('<td class="c">'+this.NAME+'</td>');
// 						_tr.append('<td class="c">'+this.NAME+'</td>');
// 						_tr.append('<td>'+this.ID+'</td>');
// 						_tr.append('<td class="c">'+$.pb.phoneFomatter(this.PHONE)+'</td>');
// 						_tr.append('<td class="c">'+(this.USER_FUNERAL_NO ? this.USER_FUNERAL_NO.split(',').length:0)+'개</td>');
// 						_tr.append('<td class="c">'+(this.ALIVE_FLAG ? '활성':'비활성')+'</td>');
// 						_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
// 						_tr.on('click', function() {
// 							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
// 								_thisLayer.find('.top-button.register').val(_tr.data('USER_NO'));
// 								_thisLayer.find('.top-button.delete').val(_tr.data('USER_NO')).show();
// 								_thisLayer.find('.menu-tree .folder.unfold').trigger('click');
// 								_thisLayer.find('.menu-tree > .item > .check-box').removeClass('checked half');
// 								_thisLayer.find('input[name=id]').attr('disabled', true);
// 								_thisLayer.find('.pb-table-wrap').show().find('tbody tr').show().not('[data-manager-no="'+_tr.data('USER_NO')+'"]').hide();
								
// 								if(_tr.data('USER_MENU_NO')) {
// 									$.each(_tr.data('USER_MENU_NO').split(','), function(idx, _value) {
// 										_thisLayer.find('.menu-tree > .item[data-menu-no="'+_value+'"]').find('.check-box').trigger('click');
// 									});
// 								}
								
// 								layerInit(_thisLayer, _tr.data());
// 							});
// 						});
// 					}
					
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
		
		crtFuneralHallList(20);
// 		createTable(searchObj);
		
		$('#btnRegister').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register').val('');
				_thisLayer.find('.top-button.delete').val('').hide();
				_thisLayer.find('.pb-popup-form.modify').hide();
				_thisLayer.find('.menu-tree > .item > .check-box').removeClass('checked half');
				_thisLayer.find('input[name=id]').attr('disabled', false);
				_thisLayer.find('.menu-tree .folder.unfold').trigger('click');
				
				var settingData = {};
// 				if(_param.lv == 20) {
					settingData.FUNERAL_NO = $('.select-box-wrap .table-search').data('funeralNo');
					_thisLayer.find('.pb-table-wrap').hide();
// 				} else if(_param.lv == 29) {
// 					_thisLayer.find('#funeralMenuTitle').html('장례식장을 선택해주세요.');
// 					_thisLayer.find('.table-search.icon-search').val('').trigger('keyup').show();
// 					_thisLayer.find('.pb-table-wrap').show().find('.pb-table.list tr').removeClass('ac');
// 				} else if(_param.lv == 90) {
// 					_thisLayer.find('.pb-table-wrap').hide();
// 				}
				
				layerInit(_thisLayer, settingData);
			});
		});
		
		$('.pb-right-popup-wrap .table-search').on('keyup', function() {
			$('.pb-right-popup-wrap .pb-table.list > tbody > tr').hide();
			if($(this).val()) $('.pb-right-popup-wrap .pb-table.list > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
			else $('.pb-right-popup-wrap .pb-table.list > tbody > tr').show();
		});
		
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			
			var _menuNo = [];
			$.each($('.menu-tree .item.child .check-box.checked').parent('.item'), function(idx) { _menuNo.push($(this).data('MENU_NO')); });
			
			if($('.pb-warning:visible').length) return alert('이미 사용중인 아이디입니다.');
// 			else if(_param.lv == 29 && !_btnValue && !$('.pb-table.list tr.ac').length) return alert('장례식장을 선택해주세요.');
// 			else if(!_btnValue && !$('.pb-table.list tr.ac').length) return alert('장례식장을 선택해주세요.');
			else if(!_menuNo.length) return alert('메뉴권한을 선택해주세요.');
			else if(_btnValue || !necessaryChecked($('#dataForm'))) {
				var _uploadUrl = _btnValue ? '/common/updateUser.do':'/common/insertUser.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('userNo', _btnValue ? _btnValue:'');
				_formData.append('lv', 20);
				_formData.append('menuNoList', _menuNo);
				
				$.pb.ajaxUploadForm(_uploadUrl, _formData, function(result) {
					if(result) {
						closeLayerPopup();
						createTable(searchObj);
// 						if(_param.lv == 29 || _param.lv == 20) crtFuneralHallList();
						crtFuneralHallList();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, true);
			}else{
				if(!$('input[name=id]').val()) return alert("아이디를 입력해 주세요.");
				if(!$('input[name=name]').val()) return alert("담당자를 입력해 주세요.");
				if(!$('input[name=password]').val()) return alert("비밀번호를 입력해 주세요.");
			}
		});
		
		$('.pb-right-popup-wrap .top-button.delete').on('click', function() {
			var _rpiId = $(this).val();
			if(confirm('삭제하시겠습니까?')) {
				$.pb.ajaxCallHandler('/admin/deleteRaspberry.do', { raspberryId:_rpiId }, function(result) {
					if(result) {
						closeLayerPopup();
						createTable(searchObj);
					} else alert('저장 실패 관리자에게 문의하세요');
				});
			}
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<form id="dataForm">
	<div class="pb-right-popup-wrap full-size">
		<input type="hidden" name="funeralNo" value=""/>
		<div class="pb-popup-title"></div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body half">
			<div class="popup-body-top">
				<div class="top-title">계정정보</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">* 아이디</label>
						<input type="text" class="form-text necessary" name="id" placeholder="아이디"/>
						<div class="pb-warning">이미 사용중인 아이디입니다.</div>
					</div>
					<div class="row-box">
						<label class="title">* 비밀번호</label>
						<input type="password" class="form-text necessary" name="password" placeholder="비밀번호"/>
					</div>
					<div class="row-box">
						<label class="title">직종</label>
						<input type="radio" name="lv" value="90"/>
						<input type="radio" name="lv" value="91"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">* 담당자</label>
						<input type="text" class="form-text necessary" name="name" placeholder="담당자명"/>
					</div>
					<div class="row-box">
						<label class="title">연락처</label>
						<input type="text" class="form-text tel" name="phone" placeholder="담당자연락처"/>
					</div>
					
					<div class="row-box">
						<label class="title">계정상태</label>
						<input type="radio" name="aliveFlag" value="1"/><input type="radio" name="aliveFlag" value="0"/>
					</div>
				</div>
			</div>
			<div class="pb-popup-form modify" style="display:none; margin-top:20px;">
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">장례식장</label>
						<input type="text" class="form-text" id="funeralName" readonly/>
					</div>
				</div>
			</div>
			<input type="text" class="table-search icon-search" placeholder="장례식장검색"/>
			<div class="pb-table-wrap funeral-hall" style="height:calc(100% - 330px);">
				<table class="pb-table list">
					<colgroup>
						<col width="40%"/>
						<col width="60%"/>
					</colgroup>
					<thead>
						<tr>
							<th>상호</th>
							<th>장례식장 주소</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		<div class="pb-popup-body half">
			<div class="popup-body-top">
				<div class="top-title">권한설정</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button delete">삭제</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title full" id="funeralMenuTitle"></label>
					</div>
				</div>
			</div>
			<div class="menu-tree"></div>
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
	<div class="title">직원관리</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">신규 계정등록</button></div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">계정 목록</div>
	</div>
	<div class="search-right-wrap">
		<input type="text" class="search-text rb" placeholder="이름, 아이디로 검색"/>
		<button type="button" class="search-text-button">검색</button>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>