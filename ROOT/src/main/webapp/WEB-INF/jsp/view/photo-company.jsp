<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:10):0);
		searchObj.display = (_param.display ? _param.display:10);
		searchObj.lv = '39';
		searchObj.order = 'USER_NO DESC';
		
		var _table = $('.contents-body-wrap .pb-table.list');
// 		$('.pb-right-popup-wrap input[name=id]').on('keyup', function(){ $(this).val($(this).val().replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/gi, '')); });
		$('.pb-right-popup-wrap input[name=id]').on('change', function() {
			var _ = $(this);
			var _inputId = $(this).val();
			$.pb.ajaxCallHandler('/common/overlapChecked.do', { userId:_inputId }, function(result) { 
				if(result) _.siblings('.pb-warning').hide();
				else _.siblings('.pb-warning').show();
			});
		});
		
		$('.pb-right-popup-wrap input[type=radio][name=aliveFlag]').siteRadio({addText:['활성', '비활성']});
		$('.form-text.tel').phoneFomatter();
		
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
		
		var crtFuneralHallList = function() {
			$('.pb-right-popup-wrap .pb-table.list > tbody').html('');
			$.pb.ajaxCallHandler('/admin/selectAllFuneralHallList.do', { order:'FUNERAL_NAME ASC', overlap:true }, function(result) {
				$.each(result.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this).addClass(idx%2 ? 'alt':'').addClass(this.PHOTO_MANAGER_NO ? 'already':'')
					.attr('data-funeral-no', this.FUNERAL_NO).attr('data-photo-manager-no', this.PHOTO_MANAGER_NO);
					
					_tr.append('<td>'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td>'+this.ADDRESS+'</td>');
					_tr.on('click', function() {
						if($(this).hasClass('ac')) $(this).removeClass('ac');
						else if(!$(this).hasClass('already'))$(this).addClass('ac');
					});
	
					$('.pb-right-popup-wrap .pb-table.list > tbody').append(_tr);
				});
			});
		};
		
		var theadObj = {
			table: _table,
			colGroup: new Array(5, 10, 15, '*', 10, 15, 8, 12),
			theadRow: new Array(['', '번호'], ['LV', '구분'], ['ID', '아이디'], ['COMPANY_NAME', '업체명'], ['NAME', '담당자'], ['', '제휴 장례식장 수'], ['ALIVE_FLAG', '계정상태'], ['CREATE_DT', '생성일'])
		};
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/common/selectUserInfoList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.LV_NAME+'</td>');
					_tr.append('<td>'+this.ID+'</td>');
					_tr.append('<td>'+this.COMPANY_NAME+'</td>');
					_tr.append('<td class="c">'+this.NAME+'</td>');
					_tr.append('<td class="c">'+(this.USER_FUNERAL_NO ? this.USER_FUNERAL_NO.split(',').length:0)+'개</td>');
					_tr.append('<td class="c">'+(this.ALIVE_FLAG ? '활성':'비활성')+'</td>');
					_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
					_tr.on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').val(_tr.data('USER_NO'));
							_thisLayer.find('input[name=id]').attr('disabled', true);
							_thisLayer.find('.pb-table-wrap tr').removeClass('ac');
							_thisLayer.find('.pb-table-wrap tr[data-photo-manager-no]').addClass('already');
							_thisLayer.find('.table-search.icon-search').val('').trigger('keyup').show();

							if(_tr.data('USER_FUNERAL_NO')) {
								$.each(_tr.data('USER_FUNERAL_NO').split(','), function(idx, _value) {
									_thisLayer.find('.pb-table-wrap tr[data-funeral-no="'+_value+'"]').removeClass('already').addClass('ac');
								});
							}
							
							layerInit(_thisLayer, _tr.data());
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
		
		crtFuneralHallList();
		createTable(searchObj);
		
		$('#btnRegister').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register').val('');
				_thisLayer.find('input[name=id]').attr('disabled', false);
				_thisLayer.find('.pb-table-wrap tr').removeClass('ac');
				_thisLayer.find('.pb-table-wrap tr[data-photo-manager-no]').addClass('already');
				_thisLayer.find('.table-search.icon-search').val('').trigger('keyup').show();
				layerInit(_thisLayer);
			});
		});
		
		$('.pb-right-popup-wrap .table-search').on('keyup', function() {
			$('.pb-right-popup-wrap .pb-table.list > tbody > tr').hide();
			if($(this).val()) $('.pb-right-popup-wrap .pb-table.list > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
			else $('.pb-right-popup-wrap .pb-table.list > tbody > tr').show();
		});
		
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			
			var _funeralNo = [];
			$.each($('.pb-table.list tr.ac'), function(idx) { _funeralNo.push($(this).data('FUNERAL_NO')); });
			
			if($('.pb-warning:visible').length) return alert('이미 사용중인 아이디입니다.');
			else if(!$('.pb-table.list tr.ac').length) return alert('장례식장을 선택해주세요.');
			else if(_btnValue || !necessaryChecked($('#dataForm'))) {
				var _uploadUrl = _btnValue ? '/common/updateUser.do':'/common/insertUser.do';
				var _formData = new FormData($('#dataForm')[0]);
				
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('userNo', _btnValue ? _btnValue:'');
				_formData.append('photoManagerNo', _btnValue ? _btnValue:'');
				_formData.append('lv', 39);
				_formData.append('funeralNoList', _funeralNo);
				
				$.pb.ajaxUploadForm(_uploadUrl, _formData, function(result) {
					if(result) {
						closeLayerPopup();
						crtFuneralHallList();
						createTable(searchObj);
					} else alert('저장 실패 관리자에게 문의하세요');
				}, true);
			}else{
				if(!$('input[name=id]').val()) return alert("아이디를 입력해 주세요.");
				if(!$('input[name=companyName]').val()) return alert("업체명을 입력해 주세요.");
				if(!$('input[name=password]').val()) return alert("비밀번호를 입력해 주세요.");
			}
		});
		$('.pb-popup-close, .popup-mask').on('click', function(){ closeLayerPopup(); });
	});
</script>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">영정업체 계정관리</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">사용자 정보</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
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
						<label class="title">계정활성여부</label>
						<input type="radio" name="aliveFlag" value="1"/><input type="radio" name="aliveFlag" value="0"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">* 업체명</label>
						<input type="text" class="form-text necessary" name="companyName" placeholder="업체명"/>
					</div>
					<div class="row-box">
						<label class="title">담당자명</label>
						<input type="text" class="form-text" name="name" placeholder="담당자명"/>
					</div>
					<div class="row-box">
						<label class="title">연락처</label>
						<input type="text" class="form-text tel" name="phone" placeholder="연락처"/>
					</div>
				</div>
			</div>
			<input type="text" class="table-search icon-search" placeholder="장례식장검색"/>
			<div class="pb-table-wrap" style="height:calc(100% - 364px);">
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
	</div>
</form>
<div class="contents-title-wrap">
	<div class="title">영정업체 관리</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">신규 계정등록</button></div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">계정 목록</div>
	</div>
	<div class="search-right-wrap">
		<input type="text" class="search-text rb" placeholder="업체명, 담당자, 아이디로 검색"/>
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