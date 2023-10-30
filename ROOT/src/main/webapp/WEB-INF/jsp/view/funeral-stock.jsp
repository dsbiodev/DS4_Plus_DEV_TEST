<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$('.select-from-year').createYear({begin:2018});
		$('.select-to-year').createYear({begin:2018});
		$('.select-from-month').createMonth();
		$('.select-to-month').createMonth();
		$('.select-from-day').createDay();
		$('.select-to-day').createDay();
		
		$('.calendar.year').createYear({begin:2018});
		$('.calendar.month').createMonth();
		$('.calendar.day').createDay();

		$('.select-from-year').val(new Date((Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24)).getFullYear());
		$('.select-from-month').val(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1 < 10 ? "0"+(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1) : new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1);
		$('.select-from-day').val(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getDate() < 10 ? "0"+new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getDate() : new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getDate());
		
		$('.select-to-month').val(new Date().getMonth()+1 < 10 ? "0"+(new Date().getMonth()+1) : new Date().getMonth()+1);
		$('.select-to-day').val(new Date().getDate() < 10 ? "0"+new Date().getDate() : new Date().getDate());
		
		$('.calendar.month').val(new Date().getMonth()+1 < 10 ? "0"+(new Date().getMonth()+1) : new Date().getMonth()+1);
		$('.calendar.day').val(new Date().getDate() < 10 ? "0"+new Date().getDate() : new Date().getDate());
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.calFrom = $('.select-from-year').val()+$('.select-from-month').val()+$('.select-from-day').val();
		searchObj.calTo = $('.select-to-year').val()+$('.select-to-month').val()+$('.select-to-day').val();
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.stockFlag = $('.stock-flag').val();
		searchObj.order = 'STOCK_NO DESC';
		
		
		var _table = $('.pb-table.list');
		$('input[type=radio][name=stockFlag]').pbRadiobox({ addText:['입고', '출고'], fontSize:'16px', matchParent:true });
		$('input[type=radio][name=stockDetailFlag]').pbRadiobox({ addText:['일반입고', '주문내역', '일반출고', '반품내역', '기타'], fontSize:'16px', matchParent:false });
		
		var createSubTable = function(){
			$('.sub-table.list tbody').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralStockTotalStatusList.do', { funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(tableData) {
				var _colspan = 1;
				var _idx = 0;
				var _val = "";
// 				$('.sub-table.list').css('width', tableData.list.length*100);
// 				$('.sub-table.list').find('tbody tr').not('.not').html('');
				
// 				var tempHead = {};
// 				$.each(tableData.list, function(idx, _value) {
// 					$.each(Object.keys(_value), function(jdx, _value2) {
// 						if(_value2 == 'CLASSIFICATION_NAME') {
// 							if(tempHead[_value.CLASSIFICATION_NAME]) tempHead[_value.CLASSIFICATION_NAME] += 1;
// 							else tempHead[_value.CLASSIFICATION_NAME] = 1;
// 						}
// 					});
					
// 					$('.sub-table.list').find('.item').append('<th>'+this.ITEM_NAME+'</th>');
// 					$('.sub-table.list').find('.in').append('<th>'+this.IN_CNT+'</th>');
// 					$('.sub-table.list').find('.out').append('<th>'+this.OUT_CNT+'</th>');
// 					$('.sub-table.list').find('.total').append('<th>'+this.TOTAL_CNT+'</th>');
// 				});
				
// 				$.each(Object.keys(tempHead), function(idx, _value) {
// 					$('.sub-table.list').find('.classification').append('<th colspan="'+tempHead[_value]+'">'+_value+'</th>');
// 				});
			
				$.each(tableData.list, function(idx, _value) {
					var _tr = $('<tr>');
					_tr.append('<td class="c">'+this.ITEM_NAME+'('+this.CODE+')</td>');
					_tr.append('<td class="c">'+this.IN_CNT+'</td>');
					_tr.append('<td class="c">'+this.OUT_CNT+'</td>');
					_tr.append('<td class="c">'+this.TOTAL_CNT+'</td>');
					$('.sub-table.list tbody').append(_tr);
				});
				
			});
		};createSubTable();
		
		var popup_list = function(){
			$('.allList').html("");$('.userList').html("");
			$('.popup-table').find('tbody').html('');
			$.pb.ajaxCallHandler('/adminSec/selectFuneralStockItemList.do', { funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(tableData) {
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td>'+this.ITEM_NAME+'</td>');
					_tr.append('<td><input type="number" class="form-text" name="cnt" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" style="ime-mode:disabled;"/></td>');
					$('.popup-table').find('tbody').append(_tr);
				});
			});
		};popup_list();
		
		$('.search-right-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) {
				$('.search-text-button').click();
			}
		});
		
		$('.search-text-button').on('click', function(){
			if(($('.select-from-year').val() + $('.select-from-month').val() + $('.select-from-day').val()) > ($('.select-to-year').val() + $('.select-to-month').val() + $('.select-to-day').val()))
				return alert("기간이 잘못됬습니다.");
			
			searchObj.currentPage = 1;
			searchObj.queryPage = 0;
			searchObj.searchText = $('.search-right-wrap .search-text').val();
			searchObj.calFrom = $('.select-from-year').val()+$('.select-from-month').val()+$('.select-from-day').val();
			searchObj.calTo = $('.select-to-year').val()+$('.select-to-month').val()+$('.select-to-day').val();
			searchObj.stockFlag = $('.stock-flag').val();
			
			var _pageData = { paging:searchObj };
			var _urlSplit = $(location)[0].pathname.split('/');
			history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
			createTable(searchObj);
		});
		
		var theadObj = {
			table: _table,
			colGroup:new Array(10, 10, 10, '*', 15),
			theadRow:[['STOCK_DT', '일자'], ['STOCK_FLAG_NAME', '구분'], ['STOCK_DETAIL_FLAG_NAME', '구분상세'], ['LIST', '내역'], ['REMARKS', '비고']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		

		var scrollValue = 0; 
		$(window).scroll(function () { scrollValue = $(document).scrollTop(); });
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectFuneralStockList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+this.STOCK_DT+'</td>');
					_tr.append('<td class="c">'+this.STOCK_FLAG_NAME+'</td>');
					_tr.append('<td class="c">'+this.STOCK_DETAIL_FLAG_NAME+'</td>');
					var _list = this.LIST ? this.LIST.replace(_searchObj.searchText, '<span style="color:#F00;">'+_searchObj.searchText+'</span>') : '-';
					_tr.append('<td>'+_list+'</td>');
					
					_tr.append('<td>'+(this.REMARKS ? this.REMARKS : '-')+'</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							$('body').css('overflow', 'hidden');
							$('.pb-right-popup-wrap').css('top', scrollValue+'px');
							
 							
							_thisLayer.find('.top-button.register, .top-button.delete').val(_tr.data('STOCK_NO'));
	 						$('.pb-right-popup-wrap .delete').show();
// 	 						$('input[name=cnt]').val(0);
	 						$('.calendar.year').val(_tr.data('STOCK_DT').substring(0,4));
	 						$('.calendar.month').val(_tr.data('STOCK_DT').substring(5,7));
	 						$('.calendar.day').val(_tr.data('STOCK_DT').substring(8,10));
							layerInit(_thisLayer, _tr.data());
							$.pb.ajaxCallHandler('/adminSec/selectFuneralStockStatusList.do', {stockNo:_tr.data('STOCK_NO')}, function(data) {
								$('.popup-table.list tbody tr').find('input').val("");
								$.each(data.list, function(idx){
									var _this = this;
									
									$('.popup-table.list tbody tr').each(function(){
										if($(this).data('ITEM_NO') == _this.STOCK_ITEM_NO) {
											$(this).val(_this.STATUS_NO);
											$(this).find('input[name=cnt]').val(_this.CNT);
										}
									});
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
		

		$('#btnRegister').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register, .top-button.delete').val('');
				_thisLayer.find('.top-button.delete').hide();
				_thisLayer.find('.pb-table-wrap').show().find('.pb-table.list tr').removeClass('ac');
				_thisLayer.find('.row-button.upd,.row-button.del').hide();
				_thisLayer.find('.row-button.add').show();
				$('input[name=cnt]').val("");
				layerInit(_thisLayer);
			});
		});
		
		
		$('.register').on('click', function(){
			if(!necessaryChecked($('#dataForm'))) {
				var _url = $(this).val() ? '/adminSec/updateFuneralStock.do' : '/adminSec/insertFuneralStock.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('stockNo', $(this).val());
				_formData.append('stockDt', $('.calendar.year').val()+$('.calendar.month').val()+$('.calendar.day').val());
				_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
				
				var arr_list = [];
				$('.popup-table > tbody tr').each(function(idx){
					var $list = { 
							statusNo : $(this).val(),
							stockNo : $('.register').val(),
							stockItemNo : $(this).data('ITEM_NO'),
							cnt : $(this).find('.form-text').val()
					};
					if($(this).find('.form-text').val())arr_list.push($list);
				});
				_formData.append('list', JSON.stringify(arr_list));
				
				$.pb.ajaxUploadForm(_url, _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						createTable(searchObj);
						createSubTable();
						$('.top-button-wrap').find('button').prop('disabled', false);
						$('.pb-popup-close').click();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}
		});
		
		$('.delete').on('click', function(){
			var _formData = new FormData($('#dataForm')[0]);
			_formData.append('stockNo', $(this).val());
			$.pb.ajaxUploadForm('/adminSec/deleteFuneralStock.do', _formData, function(result) {
				if(result != 0) {
					createTable(searchObj);
					createSubTable();
					$('.pb-popup-close').click();
				} else alert('저장 실패 관리자에게 문의하세요');
			}, '${sessionScope.loginProcess}');
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { 
			$('body').css('overflow', 'auto');
			closeLayerPopup(); 
		});
		
	});
</script>
<style>
	.sub-box-wrap { display:block; } 
	.sub-table.fixed { display:table; width:100%; border:none; }
	.sub-table-wrap { width:100%; overflow-y:scroll; overflow-x:hidden; border-bottom:1px solid #707070; border-right:1px solid #707070; height:400px; }
	
	.sub-table.list { margin-top:-1px; width:100%; border-collapse:collapse; margin-left:1px; }
	.sub-table.list th { border:1px solid #707070; }
	.sub-table.list td { border:1px solid #707070; }
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">입/출고 관리</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">입출고 정보</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
					<button type="button" class="top-button delete">삭제</button>
				</div>
			</div>
			
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">입출고 날짜</label>
						<select class="form-select calendar year" style="width:106px !important;"></select>
						<select class="form-select calendar month" style="width:85px !important;"></select>
						<select class="form-select calendar day" style="width:85px !important;"></select>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">비고</label>
						<input type="text" class="form-text" name="remarks" placeholder="직접입력"/>
					</div>
				</div>
				
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">구분</label>
						<input type="radio" name="stockFlag" value="1">
						<input type="radio" name="stockFlag" value="2">
					</div>
					<div class="row-box">
						<label class="title">상세구분</label>
						<input type="radio" name="stockDetailFlag" value="1">
						<input type="radio" name="stockDetailFlag" value="2">
						<input type="radio" name="stockDetailFlag" value="3">
						<input type="radio" name="stockDetailFlag" value="4">
						<input type="radio" name="stockDetailFlag" value="5">
					</div>
				</div>
			</div>
			
			<div style="overflow-y:auto; height:505px; border:1px solid #707070; margin-top:20px;">
				<table class="popup-table list" style="border:none; margin-top:0px;">
					<colgroup>
						<col width="33%"/>
						<col width="*"/>
						<col width="33%"/>
					</colgroup>
					<thead>
						<tr>
							<th>분류</th>
							<th>품목</th>
							<th>수량</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
			
		</div>
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">재고관리</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">입출고관리</button></div>
</div>

<div class="sub-box-wrap">
	<table class="sub-table fixed">
<!-- 		<thead> -->
<!-- 			<tr class="classification not"><th class="title">분류</th></tr> -->
<!-- 			<tr class="item not"><th class="title">품목</th></tr> -->
<!-- 		</thead> -->
<!-- 		<tbody> -->
<!-- 			<tr class="in not white"><th>입고</th></tr> -->
<!-- 			<tr class="out not white"><th>출고</th></tr> -->
<!-- 			<tr class="total not gray"><th>재고계</th></tr> -->
<!-- 		</tbody> -->
	</table>

	<div class="table-head-sub">
		<div style="width:25%;">품명</div>
		<div style="width:25%;">입고</div>
		<div style="width:25%;">출고</div>
		<div style="width:25%;">재고계</div>
	</div>
	<div class="sub-table-wrap">
		<table class="sub-table list">
			
<!-- 			<tbody> -->
<!-- 				<tr class="in not white"></tr> -->
<!-- 				<tr class="out not white"></tr> -->
<!-- 				<tr class="total not gray"></tr> -->
<!-- 			</tbody> -->

			<colgroup>
				<col width="25%"/>
				<col width="25%"/>
				<col width="25%"/>
				<col width="25%"/>
			</colgroup>
<!-- 			<thead> -->
<!-- 				<tr><th class="title">품명</th><th class="title">입고</th><th class="title">출고</th><th class="title">재고계</th></tr> -->
<!-- 			</thead> -->
			<tbody>
			</tbody>
		</table>
	</div>
</div>



<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">입/출고 내역</div>
	</div>
	<div class="search-right-wrap">
		<select class="select-from-year"></select>
		<select class="select-from-month"></select>
		<select class="select-from-day"></select>
		<div class="text">부터</div>
		<select class="select-to-year"></select>
		<select class="select-to-month"></select>
		<select class="select-to-day"></select>
		<div class="text">까지</div>
		
		<div class="text" style="font-size:20px; color:#707070;">분류명</div>
		<select class="stock-flag">
			<option value="">전체</option>
			<option value="1">입고</option>
			<option value="2">출고</option>
		</select>
		
		<input type="text" class="search-text rb" placeholder="내역 검색"/>
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