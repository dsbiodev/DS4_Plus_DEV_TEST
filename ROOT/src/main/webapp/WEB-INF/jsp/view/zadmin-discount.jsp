<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.order = 'DISCOUNT_NO DESC';
		var _table = $('.pb-table.list');
		
		$.pb.ajaxCallHandler('/admin/selectAllFuneralHallList.do', { }, function(funeralData) {
			$.each(funeralData.list, function(){
				$('select[name=funeralNo]').append('<option value='+this.FUNERAL_NO+'>'+this.FUNERAL_NAME+'</option>')
			});
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
		
		
		
		var theadObj = {
			table: _table,
			colGroup:new Array(25, 25, 25, 25),
			theadRow:[['', '번호'], ['DISCOUNT_INFO', '할인정보'], ['PARTNER_NAME', '사업자'], ['DISCOUNT_RATE', '할인율']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectDiscountList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				_total = tableData.total;
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.DISCOUNT_INFO+'</td>');
					_tr.append('<td class="c">'+this.PARTNER_NAME+'</td>');
					_tr.append('<td class="c">'+this.DISCOUNT_RATE+'</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').val(_tr.data('DISCOUNT_NO'));
							_thisLayer.find('.top-button.delete').val(_tr.data('DISCOUNT_NO'));
	 						$('.pb-right-popup-wrap .delete').show();
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
// 		createTable(searchObj);

		$('#btnRegister').on('click', function() {
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				partnerList();
				_thisLayer.find('.top-button.register, .top-button.delete').val('');
				_thisLayer.find('.top-button.delete').hide();
				layerInit(_thisLayer);
			});
		});
		
		$('.register').on('click', function(){
			if(!necessaryChecked($('#dataForm'))) {
				var _url = $(this).val() ? '/adminSec/updateDiscount.do' : '/adminSec/insertDiscount.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('discountNo', $(this).val());
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
				if(!$('input[name=discountInfo]').val()) return alert("할인정보를 입력해 주세요.");
			}
		});
		
		$('.delete').on('click', function(){
			var _formData = new FormData($('#dataForm')[0]);
			_formData.append('discountNo', $(this).val());
			$.pb.ajaxUploadForm('/adminSec/deleteDiscount.do', _formData, function(result) {
				$('.top-button-wrap').find('button').prop('disabled', true);
				if(result != 0) {
					createTable(searchObj);
					$('.top-button-wrap').find('button').prop('disabled', false);
					$('.pb-popup-close').click();
				} else alert('저장 실패 관리자에게 문의하세요');
			}, '${sessionScope.loginProcess}');
		});
		
		//품목 등록시 분류리스트 가져오기
		var partnerList = function(_no){
			$('select[name=partnerNo]').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralItemPartner.do', searchObj, function(tableData) {
				$.each(tableData.list, function(idx) {
					$('select[name=partnerNo]').append('<option value="'+this.PARTNER_NO+'">'+this.NAME+'</option>');
				});
				if(_no) $('select[name=partnerNo]').val(_no);
			});
		};partnerList();

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<form id="dataForm" onsubmit="return false">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">할인관리</div>
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
						<label class="title">할인업체</label>
						<select class="form-select" name="partnerNo"></select>
					</div>
					<div class="row-box">
						<label class="title">* 할인정보</label>
						<input type="text" class="form-text necessary" name="discountInfo" placeholder="직접입력"/>
					</div>
					<div class="row-box">
						<label class="title">할인율</label>
						<select class="form-select" name="discountRate">
							<option value="5">5</option>
							<option value="10">10</option>
							<option value="15">15</option>
							<option value="20">20</option>
							<option value="25">25</option>
							<option value="30">30</option>
							<option value="35">35</option>
							<option value="40">40</option>
							<option value="45">45</option>
							<option value="50">50</option>
							<option value="55">55</option>
							<option value="60">60</option>
							<option value="65">65</option>
							<option value="70">70</option>
							<option value="75">75</option>
							<option value="80">80</option>
							<option value="85">85</option>
							<option value="90">90</option>
							<option value="95">95</option>
							<option value="100">100</option>
						</select>
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
	<div class="title">할인관리</div>
	<div>할인을 관리할 수 있습니다.</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">할인등록</button></div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">할인정보</div>
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