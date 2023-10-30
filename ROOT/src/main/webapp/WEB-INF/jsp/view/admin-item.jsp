<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.order = 'CLASSIFICATION_NO DESC';
		
		var _table = $('.pb-table.list');
		
		$('.search-right-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) {
				$('.search-text-button').click();
			}
		});
		
		$('.search-text-button').on('click', function(){
			searchObj.currentPage = 1;
			searchObj.queryPage = 0;
			searchObj.searchText = $('.search-right-wrap .search-text').val();
			
			var _pageData = { paging:searchObj };
			var _urlSplit = $(location)[0].pathname.split('/');
			history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
			createTable(searchObj);
		});
		
		var theadObj = {
			table: _table,
			colGroup:new Array(25, 25, 25, 25),
			theadRow:[['', '번호'], ['CLASSIFICATION_NAME', '분류'], ['CODE', '품목코드'], ['ITEM_NAME', '품목이름']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		
		var _CList = "";
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectStockItemList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td class="c">'+this.CODE+'</td>');
					_tr.append('<td class="c">'+this.ITEM_NAME+'</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap.item').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').val(_tr.data('ITEM_NO'));
							_thisLayer.find('.top-button.delete').val(_tr.data('ITEM_NO')).show();
							_thisLayer.find('.top-button.delete').data('stockCnt', _tr.data('STOCK_CNT'));
							_thisLayer.find('.table-search.icon-search, .pb-table-wrap').hide();
							classificationList(_tr.data('CLASSIFICATION_NO'));
							layerInit(_thisLayer, _tr.data());
// 							_thisLayer.find('select[name=classification]').val(_tr.data('CLASSIFICATION_NO'));
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
		
		//분류 등록 클릭
		$('#btnRegisterClassification').on('click', function() {
			$('.pb-right-popup-wrap.classification').openLayerPopup({}, function(_thisLayer) {
				$('.classificationList').html("");
				layerInit(_thisLayer);
				_thisLayer.find('.top-button.register').val('');
				$.pb.ajaxCallHandler('/adminSec/selectStockClassificationList.do', {}, function(tableData) {
					_CList = tableData.list;
					$.each(tableData.list, function(idx) {
						var _div = $('<div class="row-box-02">');
						_div.data(this);
						_div.append('<label class="title">분류</label>');
						_div.append('<input type="text" class="form-text" name="classificationName" value="'+this.NAME+'" placeholder="분류명"/>');
						_div.append('<button type="button" class="row-button upd">수정</button>');
						_div.append('<button type="button" class="row-button del">삭제</button></div>');
						_div.find('.upd').on('click', function(){
							if(!_div.find('input[name=classificationName]').val()) return alert("분류명을 입력해 주세요.");
							var _tmp = false;
							$.each(_CList, function(){
								if(_div.find('input[name=classificationName]').val() == this.NAME)
									return _tmp = true;
							});
							if(_tmp) return alert("중복된 분류명입니다.");
							var _formData = new FormData();
							_formData.append('classificationNo', _div.data('CLASSIFICATION_NO'));
							_formData.append('name', _div.find('input[name=classificationName]').val());
							_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
							$.pb.ajaxUploadForm('/adminSec/updateStockClassification.do', _formData, function(result) {
								$('.top-button-wrap').find('button').prop('disabled', true);
								if(result != 0) {
									$('#btnRegisterClassification').click();
									createTable(searchObj);
									$('.top-button-wrap').find('button').prop('disabled', false);
								} else alert('저장 실패 관리자에게 문의하세요');
							}, '${sessionScope.loginProcess}');
						});
						_div.find('.del').on('click', function(){
							if(_div.data('ITEM_CNT') > 0) return alert("해당 분류에 품목이 존재하여 삭제가 불가능 합니다.");
							var _formData = new FormData();
							_formData.append('classificationNo', _div.data('CLASSIFICATION_NO'));
							_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
							$.pb.ajaxUploadForm('/adminSec/deleteStockClassification.do', _formData, function(result) {
								$('.top-button-wrap').find('button').prop('disabled', true);
								if(result != 0) {
									$('#btnRegisterClassification').click();
									$('.top-button-wrap').find('button').prop('disabled', false);
									createTable(searchObj);
								} else alert('저장 실패 관리자에게 문의하세요');
							}, '${sessionScope.loginProcess}');
						});
						$('.classificationList').append(_div);
					});
				});
			});
		});
		
		// 분류 저장
		$('.pb-right-popup-wrap.classification .register').on('click', function(){
			if($('input[name=name]').val()) {
				var _tmp = false;
				$.each(_CList, function(){
					if($('input[name=name]').val() == this.NAME)
						return _tmp = true;
				});
				if(_tmp) return alert("중복된 분류명입니다.");
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('name', $('input[name=name]').val());
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				$.pb.ajaxUploadForm('/adminSec/insertStockClassification.do', _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						$('#btnRegisterClassification').click();
						$('.top-button-wrap').find('button').prop('disabled', false);
						createTable(searchObj);
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}else{
				return alert("분루명을 입력 해주세요.");
			}
		});
		
		// 품목 등록 버튼
		$('#btnRegisterItem').on('click', function(){
			$('.pb-right-popup-wrap.item').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register').val('');
				_thisLayer.find('.top-button.delete').hide();
				$('.form-dup').css('display', 'none');
				layerInit(_thisLayer);
				classificationList();
			});
		});
		
		// 품목 저장 버튼
		$('.pb-right-popup-wrap.item .register').on('click', function(){
			if($('.form-dup').css('display') != 'block' && !necessaryChecked($('#dataForm'))){
				var _url = $(this).val() ? '/adminSec/updateStockItem.do' : '/adminSec/insertStockItem.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('itemNo', $(this).val());
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
				$.pb.ajaxUploadForm(_url, _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						createTable(searchObj);
						$('.top-button-wrap').find('button').prop('disabled', false);
						$('.pb-popup-close').click();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}else{
				if(!$('input[name=code]').val()) return alert("품목코드를 입력해 주세요.");
				if(!$('input[name=itemName]').val()) return alert("품목명을 입력해 주세요.");
			}
		});
		
		// 품목 삭제 버튼
		$('.pb-right-popup-wrap.item .delete').on('click', function(){
			if($(this).data('stockCnt') > 0) return alert("해당 품목은 재고로 등록된 내역이 있습니다.");
			var _formData = new FormData($('#dataForm')[0]);
			_formData.append('itemNo', $(this).val());
			_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
			if(confirm('삭제하시겠습니까?')){
				$.pb.ajaxUploadForm('/adminSec/deleteStockItem.do', _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						createTable(searchObj);
						$('.top-button-wrap').find('button').prop('disabled', false);
						$('.pb-popup-close').click();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}
		});
		
		// 품목코드 중복체크
		$('input[name=code]').on('focusout', function(){
			var _this = $(this);
			$.pb.ajaxCallHandler('/adminSec/dupStockItemCode.do', {dupCode:$(this).val()}, function(cnt) {
				if(cnt > 0) _this.siblings('.form-dup').css('display','block');
				else _this.siblings('.form-dup').css('display','none');
			});
			
		});
		
			
		//품목 등록시 분류리스트 가져오기
		var classificationList = function(_no){
			$('select[name=classification]').html("");
			$.pb.ajaxCallHandler('/adminSec/selectStockClassificationList.do', {}, function(tableData) {
				$.each(tableData.list, function(idx) {
					$('select[name=classification]').append('<option value="'+this.CLASSIFICATION_NO+'">'+this.NAME+'</option>');
				});
				if(_no) $('select[name=classification]').val(_no);
			});
		};

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<form id="dataForm">
	<div class="pb-right-popup-wrap classification">
		<div class="pb-popup-title">분류 정보관리</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">신규등록</div>
				<div class="top-button-wrap">
					<input type="text" class="form-text" name="name" placeholder="분류명을 입력 해주세요."/>
					<button type="button" class="top-button register">추가</button>
				</div>
			</div>
			
			<div class="pb-popup-form">
				<div class="form-box-st-01 classificationList">
<!-- 					<div class="row-box-02"> -->
<!-- 						<label class="title">분류</label> -->
<!-- 						<input type="text" class="form-text" name="classificationName" placeholder="분류명"/> -->
<!-- 						<button type="button" class="row-button upd">수정</button> -->
<!-- 						<button type="button" class="row-button del">삭제</button> -->
<!-- 					</div> -->
				</div>
			</div>
			
		</div>
	</div>
	
	<div class="pb-right-popup-wrap item">
		<div class="pb-popup-title">품목 정보관리</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">신규등록</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
					<button type="button" class="top-button delete">삭제</button>
				</div>
			</div>
			
			<div class="pb-popup-form">
				<div class="form-box-st-01">
					<div class="row-box" style="position:relative;">
						<label class="title">* 품목코드</label>
						<input type="text" class="form-text necessary" name="code" placeholder="직접입력"/>
						<span class="form-dup">중복된 품목코드 입니다.</span>
					</div>
					<div class="row-box">
						<label class="title">* 품목명</label>
						<input type="text" class="form-text necessary" name="itemName" placeholder="직접입력"/>
					</div>
					<div class="row-box">
						<label class="title">분류</label>
						<select class="form-select" name="classification"></select>
					</div>
				</div>
			</div>
			
		</div>
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">물품 관리</div>
	<div class="title-right-wrap">
		<button type="button" class="title-button" id="btnRegisterClassification">분류등록</button>
		<button type="button" class="title-button" id="btnRegisterItem">품목등록</button>
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">물품목록</div>
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