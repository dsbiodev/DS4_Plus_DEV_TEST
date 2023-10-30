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
		searchObj.stockFlag = $('.stock-flag').val(); 
		searchObj.order = 'A.STOCK_DT DESC, A.STOCK_FLAG ASC';
		
		var _table = $('.pb-table.list');
		$('input[type=radio][name=stockFlag]').pbRadiobox({ addText:['입고', '출고', '파기'], fontSize:'16px', matchParent:true });
		$('input[type=radio][name=stockDetailFlag]').pbRadiobox({ addText:['신규', '추가설치', '불량교체', '철거', '기타'], fontSize:'16px', matchParent:false });
		$('input[type=radio][name=allItemStockFlag]').pbRadiobox({ addText:['전체신품', '전체중고'], fontSize:'16px', matchParent:false });
		$('input[type=radio][name=allItemStockFlag]').on('change', function(){
			if($(this).val() == 1) $('input[type=radio][class=itemStockFlag][value=1]').click();
			else $('input[type=radio][class=itemStockFlag][value=2]').click();
		});
		
		var createSubTable = function(){
			$.pb.ajaxCallHandler('/adminSec/selectStockTotalStatusList.do', {}, function(tableData) {
				var _colspan = 1;
				var _idx = 0;
				var _val = "";
				$('.sub-table.list').css('width', tableData.list.length*100);
				$('.sub-table.list').find('thead .not').html('');
				$('.sub-table.list').find('tbody .not').html('');

				var tempHead = {};
				$.each(tableData.list, function(idx, _value) {
					$.each(Object.keys(_value), function(jdx, _value2) {
						if(_value2 == 'CLASSIFICATION_NAME') {
							if(tempHead[_value.CLASSIFICATION_NAME]) tempHead[_value.CLASSIFICATION_NAME] += 1;
							else tempHead[_value.CLASSIFICATION_NAME] = 1;
						}
					});
					
					$('.sub-table.list').find('.item').append('<th>'+this.ITEM_NAME+'</th>');
					$('.sub-table.list').find('.new-in').append('<th>'+this.NEW_IN_CNT+'</th>');
					$('.sub-table.list').find('.old-in').append('<th>'+this.OLD_IN_CNT+'</th>');
					$('.sub-table.list').find('.in-all').append('<th>'+this.IN_CNT+'</th>');
					$('.sub-table.list').find('.new-out').append('<th>'+this.NEW_OUT_CNT+'</th>');
					$('.sub-table.list').find('.old-out').append('<th>'+this.OLD_OUT_CNT+'</th>');
					$('.sub-table.list').find('.out-all').append('<th>'+this.OUT_CNT+'</th>');
					$('.sub-table.list').find('.new-stock').append('<th>'+this.NEW_STOCK_CNT+'</th>');
					$('.sub-table.list').find('.old-stock').append('<th>'+this.OLD_STOCK_CNT+'</th>');
					$('.sub-table.list').find('.new-des').append('<th>'+this.NEW_DES_CNT+'</th>');
					$('.sub-table.list').find('.old-des').append('<th>'+this.OLD_DES_CNT+'</th>');
					$('.sub-table.list').find('.stock-total').append('<th>'+this.STOCK_TOTAL_CNT+'</th>');
					$('.sub-table.list').find('.user-total').append('<th>'+this.USER_TOTAL_CNT+'</th>');
					$('.sub-table.list').find('.total').append('<th>'+this.TOTAL_CNT+'</th>');
				});
				
				$.each(Object.keys(tempHead), function(idx, _value) {
					$('.sub-table.list').find('.classification').append('<th colspan="'+tempHead[_value]+'">'+_value+'</th>');
				});
			});
		};createSubTable();
		
		
		var popup_list = function(){
			$('.allList tbody').html("");
			$('.userList').html("");
			$('.popup-table').find('tbody').html('');
			$.pb.ajaxCallHandler('/adminSec/selectStockCompanyList.do', {order : 'CLASSIFICATION_NO, ITEM_NAME'}, function(tableData) {
				$.each(tableData.funeralList, function(idx) {
					var _tr = $('<tr>');
					_tr.append('<td value=F'+this.FUNERAL_NO+'>'+this.FUNERAL_NAME+'('+this.GUNGU_NAME+')</td>');
					$('.allList').find('tbody').append(_tr);
				});

				$('.pb-right-popup-wrap .table-search').on('keyup', function() {
					$('.pb-right-popup-wrap .allList > tbody > tr').removeClass('ac');
					$('.pb-right-popup-wrap .allList > tbody > tr').hide();
					if($(this).val()) $('.pb-right-popup-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
					else $('.pb-right-popup-wrap .allList > tbody > tr').show();
				});
				
				$('.userList').append('<option value="">담당자를 선택해 주세요.</option>');	
				$.each(tableData.userList, function(idx) {
					var _tr = $('<tr>');
					_tr.append('<td value=U'+this.USER_NO+'>'+this.NAME+'</td>');
					$('.allList').find('tbody').append(_tr);
					$('.userList').append('<option value="'+this.USER_NO+'">'+this.NAME+'</option>');		
				});
				$('.allList').append('<tr><td value="E">기타</td></tr>');
				
				$('.pb-right-popup-wrap .allList tr').on('click', function() {
					$('.pb-right-popup-wrap .allList tr').removeClass('ac');
					$(this).addClass('ac');
					$('.pb-right-popup-wrap .table-search').val($(this).find('td').text());
				});
				
				$.each(tableData.itemList, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td>'+this.ITEM_NAME+'</td>');
					_tr.append('<td><input type="text" class="form-text" name="cnt" value="0" onkeypress="return isNumberKey(event)" style="ime-mode:disabled;"/></td>');
					_tr.append('<td><input type="radio" class="itemStockFlag" name="itemStockFlag'+idx+'" value="1"></td>');
					_tr.append('<td><input type="radio" class="itemStockFlag" name="itemStockFlag'+idx+'" value="2"></td>');
					$('.popup-table').find('tbody').append(_tr);
					_tr.find('input[type=radio][name=itemStockFlag'+idx+']').pbRadiobox({ addText:['신품', '중고'], fontSize:'16px', matchParent:true });
				});
			});
		};popup_list();
		
		$('.search-right-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) {
				$('.search-text-button').click();
			}
		});
		
		$('.search-text-button').on('click', function(){
			if(($('.select-from-year').val() + $('.select-from-month').val()) > ($('.select-to-year').val() + $('.select-to-month').val()))
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
			colGroup:new Array(9, 15, 7, 8, 5, 7, '*', 10),
			theadRow:[['STOCK_DT', '일자'], ['COMPANY', '입/출고처'], ['SIDO', '시/도'], ['MANAGER', '담당자'], ['STOCK_FLAG_NAME', '구분'], ['STOCK_DETAIL_FLAG_NAME', '구분상세'], ['LIST', '내역'], ['REMARKS', '비고']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectStockList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+this.STOCK_DT+'</td>');
					_tr.append('<td class="c">'+this.COMPANY+'</td>');
					_tr.append('<td class="c">'+this.SIDO+'</td>');
					_tr.append('<td class="c">'+this.MANAGER_NAME+'</td>');
					_tr.append('<td class="c">'+this.STOCK_FLAG_NAME+'</td>');
					_tr.append('<td class="c">'+this.STOCK_DETAIL_FLAG_NAME+'</td>');
					var _list = this.LIST ? this.LIST.replace(_searchObj.searchText, '<span style="color:#F00;">'+_searchObj.searchText+'</span>') : '-';
					_tr.append('<td>'+_list+'</td>');
					
					_tr.append('<td class="c">'+(this.REMARKS ? this.REMARKS : '-')+'</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register, .top-button.delete').val(_tr.data('STOCK_NO'));
	 						$('.pb-right-popup-wrap .delete').show();
	 						$('input[name=cnt]').val(0);
	 						$('.calendar.year').val(_tr.data('STOCK_DT').substring(0,4));
	 						$('.calendar.month').val(_tr.data('STOCK_DT').substring(5,7));
	 						$('.calendar.day').val(_tr.data('STOCK_DT').substring(8,10));
	 						
	 						$('.pb-right-popup-wrap .table-search').val(_tr.data('COMPANY'));
	 						$('.pb-right-popup-wrap .allList tr').removeClass('ac');
	 						$('.pb-right-popup-wrap .allList tr').each(function(){
	 							if($(this).find('td').text() == _tr.data('COMPANY'))
	 								$(this).addClass('ac');
	 						});
	 						
							layerInit(_thisLayer, _tr.data());
							$.pb.ajaxCallHandler('/adminSec/selectStockStatusList.do', {stockNo:_tr.data('STOCK_NO')}, function(data) {
								$('.popup-table.list tbody tr').find('input[name=cnt]').val(0);
								$.each(data.list, function(idx){
									var _this = this;
									$('.popup-table.list tbody tr').each(function(){
										if($(this).data('ITEM_NO') == _this.STOCK_ITEM_NO){
											$(this).val(_this.STATUS_NO);
											$(this).find('input[name=cnt]').val(_this.CNT);
											$(this).find('input[class=itemStockFlag][value="'+_this.STOCK_ITEM_FLAG+'"]').click();
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
		};createTable(searchObj);
		

		$('#btnRegister').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register, .top-button.delete').val('');
				_thisLayer.find('.top-button.delete').hide();
				_thisLayer.find('.pb-table-wrap').show().find('.pb-table.list tr').removeClass('ac');
				_thisLayer.find('.row-button.upd,.row-button.del').hide();
				_thisLayer.find('.row-button.add').show();
				$('input[name=cnt]').val(0);
				layerInit(_thisLayer);
				$('.table-search').val('');
				$('.pb-right-popup-wrap .allList tr').removeClass('ac');
			});
		});
		
		
		$('.register').on('click', function(){
			if(!$('.table-search').val()) return alert("입/출고처를 선택해 주세요.");
			if(!necessaryChecked($('#dataForm'))) {
				var _url = $(this).val() ? '/adminSec/updateStock.do' : '/adminSec/insertStock.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('stockNo', $(this).val());
				_formData.append('stockDt', $('.calendar.year').val()+$('.calendar.month').val()+$('.calendar.day').val());
				_formData.append('company', $('.pb-right-popup-wrap .allList tr.ac').find('td').attr('value'));
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
				var arr_list = [];
				$('.popup-table > tbody tr').each(function(idx){
					var $list = { 
							statusNo : $(this).val(),
							stockNo : $('.register').val(),
							stockItemNo : $(this).data('ITEM_NO'),
							stockItemFlag : $(this).find('input[name=itemStockFlag'+idx+']:checked').val(),
							cnt : $(this).find('.form-text').val()
					};
					if($(this).find('.form-text').val() > 0)arr_list.push($list);
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
			}else{
				if(!$('select[name=manager]').val()) return alert("입출고담당자를 선택해 주세요.");
			}
			
		});
		
		
		$('.delete').on('click', function(){
			if(confirm('삭제하시겠습니까?')){
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('stockNo', $(this).val());
				$.pb.ajaxUploadForm('/adminSec/deleteStock.do', _formData, function(result) {
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
		
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});

	function isNumberKey(evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        var _value = event.srcElement.value;       
    
        // 소수점(.)이 두번 이상 나오지 못하게
        var _pattern0 = /^\d*[.]\d*$/; // 현재 value값에 소수점(.) 이 있으면 . 입력불가
        if (_pattern0.test(_value)) {
            if (charCode == 46) {
                return false;
            }
        }
 
        // 소수점 둘째자리까지만 입력가능
        var _pattern2 = /^\d*[.]\d{2}$/; // 현재 value값이 소수점 둘째짜리 숫자이면 더이상 입력 불가
        if (_pattern2.test(_value)) {
            alert("소수점 둘째자리까지만 입력가능합니다.");
            return false;
        }     
        return true;
    }
	
</script>
<style>
	.sub-table.list th { cursor:auto; }
	.sub-table.fixed th { cursor:auto; }
	.allList tr:hover { background:#98C7FF; cursor:pointer; }
	.allList tr.ac { background:#98C7FF; cursor:pointer; }
	
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">입/출고 관리</div>
		<span class="pb-popup-close"></span>
		<div id="pb-body" class="pb-popup-body">
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
						<select class="form-select calendar month" style="width:80px !important;"></select>
						<select class="form-select calendar day" style="width:80px !important;"></select>
						
					</div>
					<div class="row-box">
						<label class="title">* 입출고 담당자</label>
						<select class="form-select userList necessary" name="manager"></select>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box" style="text-align:right;">
						<label class="title">* 입/출고처</label>
						<input type="text" class="form-text table-search necessary">
						<div style="font-size:16px; width:calc(100% - 159px); margin:0px 0px 0px 156px; height:100px; overflow-y:scroll; text-align:left; border:1px solid #707070; border-right:2px solid #707070;">
							<table class="allList" style="width:100%;">
								<tbody>
								</tbody>
							</table>
						</div>
					</div>
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
						<input type="radio" name="stockFlag" value="3">
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
			
			<table class="popup-table list">
				<colgroup>
					<col width="18%"/>
					<col width="*"/>
					<col width="15%"/>
					<col width="15%"/>
					<col width="15%"/>
				</colgroup>
				<thead>
					<tr>
						<th>분류</th>
						<th>품목</th>
						<th>수량</th>
						<th><input type="radio" name="allItemStockFlag" value="1"></th>
						<th><input type="radio" name="allItemStockFlag" value="2"></th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">창고재고</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">입출고관리</button></div>
</div>

<div class="sub-box-wrap">
	<table class="sub-table fixed">
		<thead>
			<tr class="classification not"><th class="title">분류</th></tr>
			<tr class="item not"><th class="title">품목</th></tr>
		</thead>
		<tbody>
			<tr class="new-in not white"><th class="title">입고(신품)</th></tr>
			<tr class="old-in not white"><th class="title">입고(중고)</th></tr>
			<tr class="in-all not gray"><th class="title">입고계</th></tr>
			<tr class="new-out not white"><th>출고(신품)</th></tr>
			<tr class="old-out not white"><th>출고(중고)</th></tr>
			<tr class="out-all not gray"><th>출고계</th></tr>
			<tr class="new-stock not white"><th>재고(신품)</th></tr>
			<tr class="old-stock not white"><th>재고(중고)</th></tr>
			<tr class="new-des not white"><th>파기(신품)</th></tr>
			<tr class="old-des not white"><th>파기(중고)</th></tr>
			<tr class="total not gray"><th>재고계</th></tr>
			<tr class="total not white"><th>차량계</th></tr>
			<tr class="total not gray"><th>합계</th></tr>
		</tbody>
	</table>
	
	<div class="sub-table-wrap">
		<table class="sub-table list">
			<thead>
				<tr class="classification not"></tr>
				<tr class="item not"></tr>
			</thead>
			<tbody>
				<tr class="new-in not white"></tr>
				<tr class="old-in not white"></tr>
				<tr class="in-all not gray"></tr>
				<tr class="new-out not white"></tr>
				<tr class="old-out not white"></tr>
				<tr class="out-all not gray"></tr>
				<tr class="new-stock not white"></tr>
				<tr class="old-stock not white"></tr>
				<tr class="new-des not white"></tr>
				<tr class="old-des not white"></tr>
				<tr class="stock-total not gray"></tr>
				<tr class="user-total not white"></tr>
				<tr class="total not gray"></tr>
			</tbody>
		</table>
	</div>
</div>



<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">입/출고 내역</div>
	</div>
	<div class="search-right-wrap">
		<select class="select-from-year" style="width:115px;"></select>
		<select class="select-from-month" style="width:100px;"></select>
		<select class="select-from-day" style="width:100px;"></select>
		<div class="text">부터</div>
		<select class="select-to-year" style="width:115px;"></select>
		<select class="select-to-month" style="width:100px;"></select>
		<select class="select-to-day" style="width:100px;"></select>
		<div class="text">까지</div>
		
		<div class="text" style="font-size:20px; color:#707070;">분류명</div>
		<select class="stock-flag">
			<option value="">전체</option>
			<option value="1">입고</option>
			<option value="2">출고</option>
			<option value="3">파기</option>
		</select>
		
		<input type="text" class="search-text rb" placeholder="장례식장명,담당자명으로 검색"/>
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