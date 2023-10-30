<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.order = 'IDX*1, ITEM_NO DESC';
		
		var _table = $('.pb-table.list');

		$('input[type=radio][name=reflectFlag]').siteRadio({ addText:['반영', '미반영'], fontSize:'16px' });
		$('input[type=radio][name=vatFlag]').siteRadio({ addText:['여', '부'], fontSize:'16px' });
		$('input[type=text][name=price]').targetMoney();
		$('input[type=text][name=wPrice]').targetMoney();
		
		
		var createPartner = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectFuneralItemPartner.do', _searchObj, function(data) {
				$.each(data.list, function(idx) {
					var _div = $('<div class="partner">'+this.NAME+'<br><span>'+this.BUS_NO+'</span></div>');
					_div.data(this);
					_div.on('click', function(){
						$(this).addClass('ac').siblings('div').removeClass('ac');
						searchObj.partnerNo = $(this).data('PARTNER_NO');
						createTable(searchObj);
					});
					$('.partner-box').append(_div);
				});
				$('.partner-box').find('.partner:eq(0)').click();
			});
		};createPartner(searchObj);
		
		
		var theadObj = {
			table: _table,
			colGroup:new Array(5, 20, 20, 15, 10, 10, 10, 10),
			theadRow:[['', '번호'], ['CLASSIFICATION_NAME', '분류'], ['ITEM_NAME', '품목이름'], ['CODE', '품목코드'], ['ITEM_NAME', '품목우선순위'], ['UNIT', '단위'], ['W_PRICE', '입고가'], ['PRICE', '단가']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		
		var createTable = function(_searchObj) {
			
			$.pb.ajaxCallHandler('/adminSec/selectFuneralItemList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c" style="text-align: left;">'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td class="c" style="text-align: left;">'+this.ITEM_NAME+'</td>');
					_tr.append('<td class="c" style="text-align: left;">'+this.CODE+'</td>');
					_tr.append('<td class="c">'+this.IDX+'</td>');
					_tr.append('<td class="c">'+this.UNIT+'</td>');
					_tr.append('<td class="c" style="text-align: right;" name="WpriceTd">'+this.W_PRICE.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'</td>');
					_tr.append('<td class="c" style="text-align: right;" name="priceTd">'+this.VAT_PRICE.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap.item').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.form-dup').hide();
							_thisLayer.find('.top-button.register').val(_tr.data('ITEM_NO'));
							_thisLayer.find('.top-button.delete').val(_tr.data('ITEM_NO')).show();
							_thisLayer.find('.top-button.delete').data('stockCnt', _tr.data('STOCK_CNT'));
							_thisLayer.find('.table-search.icon-search, .pb-table-wrap').hide();
							classificationList(_tr.data('CLASSIFICATION_NO'));
							layerInit(_thisLayer, _tr.data());
							_thisLayer.find('input[name=price]').val($.pb.targetMoney(_tr.data('PRICE')));
							_thisLayer.find('input[name=wPrice]').val($.pb.targetMoney(_tr.data('W_PRICE')));
							_thisLayer.find('input[name=code]').attr('disabled', true);
						});
					});
					_table.find('tbody').append(_tr);
				});
				_searchObj.total = tableData.total;
				$('.contents-body-wrap .paging').createPaging(_searchObj, function(_page) {
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
		
		//분류 등록 클릭
		var _CList = "";
		$('#btnRegisterClassification').on('click', function() {
			$('.pb-right-popup-wrap.classification').openLayerPopup({}, function(_thisLayer) {
				$('.classificationList').html("");
				layerInit(_thisLayer);
				_thisLayer.find('.top-button.register').val('');
				$.pb.ajaxCallHandler('/adminSec/selectFuneralClassificationList.do', searchObj, function(tableData) {
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
							_formData.append('partnerNo', searchObj.partnerNo);
							_formData.append('name', _div.find('input[name=classificationName]').val());
							_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
							$.pb.ajaxUploadForm('/adminSec/updateFuneralClassification.do', _formData, function(result) {
								$('.top-button-wrap').find('button').prop('disabled', true);
								if(result != 0) {
									$('#btnRegisterClassification').click();
									$('.top-button-wrap').find('button').prop('disabled', false);
									createTable(searchObj);
								} else alert('저장 실패 관리자에게 문의하세요');
							}, '${sessionScope.loginProcess}');
						});
						_div.find('.del').on('click', function(){
							if(_div.data('ITEM_CNT') > 0) return alert("해당 분류에 품목이 존재하여 삭제가 불가능 합니다.");
							var _formData = new FormData();
							_formData.append('classificationNo', _div.data('CLASSIFICATION_NO'));
							_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
							$.pb.ajaxUploadForm('/adminSec/deleteFuneralClassification.do', _formData, function(result) {
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
			if(!searchObj.partnerNo) return alert("업체를 먼저 등록해 주세요.");
			if(!$('input[name=name]').val()) return alert("분류명을 입력해 주세요.");
			else{
				var _tmp = false;
				$.each(_CList, function(){
					if($('input[name=name]').val() == this.NAME)
						return _tmp = true;
				});
				if(_tmp) return alert("중복된 분류명입니다.");
				var _formData = new FormData();
				_formData.append('partnerNo', searchObj.partnerNo);
				_formData.append('name', $('input[name=name]').val());
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				$.pb.ajaxUploadForm('/adminSec/insertFuneralClassification.do', _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						$('#btnRegisterClassification').click();
						$('.top-button-wrap').find('button').prop('disabled', false);
						createTable(searchObj);
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}
		});
		
		// 품목 등록 버튼
		$('#btnRegisterItem').on('click', function(){
			$('.pb-right-popup-wrap.item').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('input[name=code]').attr('disabled', false);
				_thisLayer.find('.top-button.register').val('');
				_thisLayer.find('.top-button.delete').hide();
				_thisLayer.find('.form-dup').hide();
				layerInit(_thisLayer);
				_thisLayer.find('input[name=vatFlag][value=1]').click();
				classificationList();
			});
		});
		
		// 품목 저장 버튼
		$('.pb-right-popup-wrap.item .register').on('click', function(){
			if(!searchObj.partnerNo) return alert('업체를 먼저 등록해 주세요.');

			if($('.form-dup').css('display') == 'block') return alert("중복된 품목코드 입니다.");
			if(!necessaryChecked($('#dataForm'))){
				var _url = $(this).val() ? '/adminSec/updateFuneralItem.do' : '/adminSec/insertFuneralItem.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('itemNo', $(this).val());
				_formData.append('partnerNo', searchObj.partnerNo);
				_formData.append('code', $('input[name=code]').val());
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
				if(!$('input[name=unit]').val()) return alert("단위를 입력해 주세요.");
				if(!$('input[name=wPrice]').val()) return alert("입고가를 입력해 주세요.");
				if(!$('input[name=price]').val()) return alert("단가를 입력해 주세요.");
			}
		});
		
		// 품목 삭제 버튼
		$('.pb-right-popup-wrap.item .delete').on('click', function(){
			if($(this).data('stockCnt') > 0) return alert("해당 품목은 재고로 등록된 내역이 있습니다.");
			var _formData = new FormData($('#dataForm')[0]);
			_formData.append('itemNo', $(this).val());
			_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
			$.pb.ajaxUploadForm('/adminSec/deleteFuneralItem.do', _formData, function(result) {
				$('.top-button-wrap').find('button').prop('disabled', true);
				if(result != 0) {
					createTable(searchObj);
					$('.top-button-wrap').find('button').prop('disabled', false);
					$('.pb-popup-close').click();
				} else alert('삭제 실패 관리자에게 문의하세요');
			}, '${sessionScope.loginProcess}');
		});
		
		// 품목코드 중복체크
		$('input[name=code]').on('focusout', function(){
			var _this = $(this);
			$.pb.ajaxCallHandler('/adminSec/dupFuneralItemCode.do', {dupCode:$(this).val(), partnerNo:searchObj.partnerNo}, function(cnt) {
				if(cnt > 0) _this.siblings('.form-dup').css('display','block');
				else _this.siblings('.form-dup').css('display','none');
			});
		});
		
		//품목 등록시 분류리스트 가져오기
		var classificationList = function(_no){
			$('select[name=classification]').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralClassificationList.do', searchObj, function(tableData) {
				$.each(tableData.list, function(idx) {
					$('select[name=classification]').append('<option value="'+this.CLASSIFICATION_NO+'">'+this.NAME+'</option>');
				});
				if(_no) $('select[name=classification]').val(_no);
			});
		};

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
		
		
		// 품목 일괄 등록 버튼
		var _cList = [], _trIdx = 0;
		$('#btnRegisterItemList').on('click', function(){			
			$('.item-add-list').find('tbody').html('');	//HYH - 품목 일괄 등록 화면 초기화
			$('.pb-right-popup-wrap.full-size').openLayerPopup({}, function(_thisLayer) {
				_cList = []; _trIdx = 0;
				$.pb.ajaxCallHandler('/adminSec/selectFuneralClassificationList.do', searchObj, function(tableData) {
					_cList = tableData.list;
				});
			});
		});
		
		$('.btn-item-batch').on('click', function() {			
			var _tr = $('<tr>');
			_tr.append('<td><input type="text" class="form-text" name="idx" placeholder="품목 우선순위 입력하세요." maxlength="20"/></td>');
			_tr.append('<td><input type="text" class="form-text necessary" name="code" placeholder="품목 코드" maxlength="20"/></td>');
			_tr.append('<td><input type="text" class="form-text necessary" name="itemName" placeholder="품목명" maxlength="20"/></td>');
			_tr.append('<td><select class="form-select necessary" name="classification"></select></td>');
			$.each(_cList, function() { _tr.find('select[name=classification]').append('<option value="'+this.CLASSIFICATION_NO+'">'+this.NAME+'</option>'); });
			_tr.append('<td><input type="text" class="form-text necessary" name="unit" placeholder="품목 단위" maxlength="20"/></td>');
			_tr.append('<td><input type="text" class="form-text necessary" name="wPrice" placeholder="품목 입고가" value="0" maxlength="12"/></td>');
			_tr.find('input[type=text][name=wPrice]').targetMoney();
			_tr.append('<td><input type="text" class="form-text necessary" name="price" placeholder="품목 단가" value="0" maxlength="12"/></td>');
			_tr.find('input[type=text][name=price]').targetMoney();
			_tr.append('<td><input type="radio" class="form-text reflectFlag" name="reflectFlag'+_trIdx+'" value="1"><input type="radio" class="form-text reflectFlag" name="reflectFlag'+_trIdx+'" value="2"></td>');
			_tr.find('input[name=reflectFlag'+_trIdx+']').siteRadio({ addText:['반영', '미반영'], fontSize:'16px', width: '80px', defaultValue: '1' });
			_tr.append('<td><input type="radio" class="form-text vatFlag" name="vatFlag'+_trIdx+'" value="1"><input type="radio" class="form-text vatFlag" name="vatFlag'+_trIdx+'" value="2"></td>');
			_tr.find('input[name=vatFlag'+_trIdx+']').siteRadio({ addText:['여', '부'], fontSize:'16px', width: '80px', defaultValue: '1' });
			_tr.append('<td><input type="text" class="form-text" name="company" placeholder="업체명" maxlength="20"/></td>');
			_tr.append('<td><button type="button">삭제</button></td>');
			_tr.find('button').on('click', function() { _tr.remove(); });
			
			$('.item-add-list tbody').append(_tr);
			_trIdx += 1;
		});
		

		$('.btn-item-reg').on('click', function() {
			if(confirm('저장하시겠습니까?')) {
				var _list = [];
				$('.item-add-list tbody tr').each(function() {
					var $list = {
							partnerNo : searchObj.partnerNo,
							idx : $(this).find('select[name=idx]').val(),
							code : $(this).find('input[name=code]').val(),
							itemName : $(this).find('input[name=itemName]').val(),
							classification : $(this).find('select[name=classification]').val(),
							unit : $(this).find('input[name=unit]').val(),
							wPrice : $(this).find('input[name=wPrice]').val(),
							price : $(this).find('input[name=price]').val(),
							reflectFlag : $(this).find('.reflectFlag:checked').val(),
							createUserNo : '${sessionScope.loginProcess.USER_NO}',
							vatFlag : $(this).find('.vatFlag:checked').val(),
							company : $(this).find('input[name=company]').val()
					}
					_list.push($list);
				});
				
				var _formData = new FormData($('#eventSubForm')[0]);
	 			_formData.append('list', JSON.stringify(_list));
	 			$.pb.ajaxUploadForm('/adminSec/insertFuneralItemBatch.do', _formData, function(result) {
					$('.form-box-st-01.btn-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						createTable(searchObj);
						$('.form-box-st-01.btn-wrap').find('button').prop('disabled', false);
						$('.pb-popup-close').click();
	 				} else alert('저장 실패 관리자에게 문의하세요');
	 			}, '${sessionScope.loginProcess}');
			}
		});
	});
</script>
<style>
	.item-add-wrap { min-height: 500px; max-height: 500px; overflow-y: auto; }
	.item-add-list { width: 100%; font-size:16px; margin: 14px 0px 14px 14px;  border: 1px solid #707070; background: #FFFFFF; }
	.item-add-list th { padding: 8px 0; border-right: 1px solid #707070; border-bottom: 1px solid #707070; background: linear-gradient(to bottom, #FFFFFF, #EBEDEE); color: #333333; font-size: 16px; font-weight: 500; letter-spacing: 0.8px; text-align: center; cursor: pointer; }
	.item-add-list tbody tr td { text-align: center; height: 50px; padding: 8px 0px; }
	.item-add-list tbody tr td select { width: 90%; height: 100%; padding-left: 14px; }
	.item-add-list tbody tr td input { width: 90%; height: 100%; }
	.item-add-list tbody tr td button { width: 90%; height: 100%; background: #de3a3a; }
	
	
	.form-box-st-01.btn-wrap { text-align: center; }
	.form-box-st-01.btn-wrap button { width: 200px; height: 48px; margin-left: 8px; border-radius: 4px; background: #157FFB; color: #FFFFFF; font-size: 18px; font-weight: 500; letter-spacing: 0.9px; }
</style>
<div class="pb-right-popup-wrap classification">
	<div class="pb-popup-title">상품관리</div>
	<span class="pb-popup-close"></span>
	<div class="pb-popup-body">
		<div class="popup-body-top">
			<div class="top-title">신규등록</div>
			<div class="top-button-wrap">
				<input type="text" class="form-text" name="name" placeholder="분류명을 입력해 주세요."/>
				<button type="button" class="top-button register">추가</button>
			</div>
		</div>
		<div class="pb-popup-form">
			<div class="form-box-st-01 classificationList">
			</div>
		</div>
	</div>
</div>

<form id="dataForm">
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
					<div class="row-box">
						<label class="title">품목우선순위</label>
						<input type="text" class="form-text" name="idx" placeholder="품목 우선순위 입력하세요." maxlength="20"/>
					</div>
					<div class="row-box" style="position:relative;">
						<label class="title">* 품목코드</label>
						<input type="text" class="form-text necessary" name="code" placeholder="품목 코드를 입력하세요." maxlength="20"/>
						<span class="form-dup">중복된 품목코드 입니다.</span>
					</div>
					<div class="row-box">
						<label class="title">* 품목명</label>
						<input type="text" class="form-text necessary" name="itemName" placeholder="품목명을 입력하세요." maxlength="20"/>
					</div>
					<div class="row-box">
						<label class="title">분류</label>
						<select class="form-select necessary" name="classification"></select>
					</div>
					<div class="row-box">
						<label class="title">* 단위</label>
						<input type="text" class="form-text necessary" name="unit" placeholder="품목의 단위를 입력하세요." maxlength="20"/>
					</div>
					<div class="row-box">
						<label class="title">* 입고가</label>
						<input type="text" class="form-text necessary" name="wPrice" placeholder="품목의 입고가를 입력하세요." maxlength="12"/>
					</div>
					<div class="row-box">
						<label class="title">* 단가</label>
						<input type="text" class="form-text necessary" name="price" placeholder="품목의 단가를 입력하세요." maxlength="12"/>
					</div>
					<div class="row-box">
						<label class="title">재고반영</label>
						<input type="radio" class="form-text" name="reflectFlag" value="1">
						<input type="radio" class="form-text" name="reflectFlag" value="2">
					</div>
					
					<div class="row-box">
						<label class="title">부가세 여부</label>
						<input type="radio" class="form-text" name="vatFlag" value="1">
						<input type="radio" class="form-text" name="vatFlag" value="2">
					</div>
					<div class="row-box">
						<label class="title">업체명</label>
						<input type="text" class="form-text" name="company" placeholder="업체명을 입력하세요." maxlength="20"/>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>


<div class="pb-right-popup-wrap full-size">
	<div class="pb-popup-title">품목 정보관리</div>
	<span class="pb-popup-close"></span>
	<div class="pb-popup-body">
		<div class="popup-body-top">
			<div class="top-title">신규등록</div>
			<div class="top-button-wrap">
				<button type="button" class="top-button btn-item-reg">저장</button>
				<button type="button" class="top-button pb-popup-close">취소</button>
			</div>
		</div>
		
		<div class="pb-popup-form">
			<div class="form-box-st-01 item-add-wrap">
				<table class="item-add-list">
					<colgroup>
						<col width="6%">
						<col width="8%">
						<col width="*">
						<col width="8%">
						<col width="8%">
						<col width="8%">
						<col width="8%">
						<col width="10%">
						<col width="10%">
						<col width="8%">
						<col width="8%">
					</colgroup>
					<thead>
						<tr>
							<th>품목우선순위</th>
							<th>*품목코드</th>
							<th>*품목명</th>
							<th>분류</th>
							<th>*단위</th>
							<th>*입고가</th>
							<th>*단가</th>
							<th>재고반영<button type="button">변경</button></th>
							<th>부가세 여부<button type="button">변경</button></th>
							<th>업체명</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
			<div class="form-box-st-01 btn-wrap">
				<button type="button" class="btn-item-batch">추가</button>
			</div>
		</div>
	</div>
</div>

<div class="contents-title-wrap">
	<div class="title">상품관리</div>
	<div>업체를 선택하신 후 상품을 등록하세요.</div>
	<div class="title-right-wrap">
		<button type="button" class="title-button" id="btnRegisterClassification">분류등록</button>
		<button type="button" class="title-button" id="btnRegisterItem">품목등록</button>
		<button type="button" class="title-button" id="btnRegisterItemList">품목일괄등록</button>
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">업체목록</div>
	</div>
</div>
<div class="contents-body-wrap">
	<div style="display:flex;">
		<div class="partner-box" style="overflow-y: auto; height: 75vh;">
			<div class="partner-head">업체선택</div>
		</div>
		<div style="width:83%;">
			<table class="pb-table list" style="width:100%;">
				<colgroup></colgroup>
				<thead></thead>
				<tbody></tbody>
			</table>
			<div class="paging"></div>
		</div>
	</div>
</div>