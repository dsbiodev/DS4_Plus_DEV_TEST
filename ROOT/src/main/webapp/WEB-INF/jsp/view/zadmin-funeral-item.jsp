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
		searchObj.order = 'IDX, ITEM_NO DESC';
		
		
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
						createPartner(searchObj);
					}else{
					$('.select-box-wrap .table-search').val("");
					$('.select-box-wrap .table-search').data('funeralNo', null);
					$('.partner-box').html("");
					$('.partner-box').append('<div class="partner-head">업체선택</div>');
					$('.pb-table.list tbody').html("");
					$('.paging').html("");
					$('.classificationList').html("");
				}
			});
			
			$('.select-box-wrap .table-search').on('keyup', function() {
				$('.select-box-wrap .allList > tbody > tr').removeClass('ac');
				$('.select-box-wrap .allList > tbody > tr').hide();
				if($(this).val()) $('.select-box-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
				else $('.select-box-wrap .allList > tbody > tr').show();
			});
		});
		
		
		var _table = $('.pb-table.list');
		
		$('input[type=radio][name=reflectFlag]').siteRadio({ addText:['반영', '미반영'], fontSize:'16px', matchParent:false });
		$('input[type=text][name=price]').targetMoney();
		
		var createPartner = function(_searchObj) {
			$('.partner-box').html("");
			$('.partner-box').append('<div class="partner-head">업체선택</div>');
			_table.find('tbody').html('');
			$('.paging').html("");
			$('.classificationList').html("");
			searchObj.partnerNo = "";
			
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
		};
// 		createPartner(searchObj);
		
		
		var theadObj = {
			table: _table,
			colGroup:new Array(20, 20, 20, 20, 20),
			theadRow:[['', '번호'], ['CLASSIFICATION_NAME', '분류'], ['ITEM_NAME', '품목이름'], ['CODE', '품목코드'], ['ITEM_NAME', '품목우선순위']]
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
					_tr.append('<td class="c">'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td class="c">'+this.ITEM_NAME+'</td>');
					_tr.append('<td class="c">'+this.CODE+'</td>');
					_tr.append('<td class="c">'+this.IDX+'</td>');
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
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			else{
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
			};
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
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			else{
				$('.pb-right-popup-wrap.item').openLayerPopup({}, function(_thisLayer) {
					_thisLayer.find('input[name=code]').attr('disabled', false);
					_thisLayer.find('.top-button.register').val('');
					_thisLayer.find('.top-button.delete').hide();
					_thisLayer.find('.form-dup').hide();
					layerInit(_thisLayer);
					classificationList();
				});
			};
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
				} else alert('저장 실패 관리자에게 문의하세요');
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
	});
</script>
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
						<select class="form-select" name="idx">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>
					</div>
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
						<select class="form-select necessary" name="classification"></select>
					</div>
					<div class="row-box">
						<label class="title">* 단위</label>
						<input type="text" class="form-text necessary" name="unit" placeholder="직접입력"/>
					</div>
					<div class="row-box">
						<label class="title">* 단가</label>
						<input type="text" class="form-text necessary" name="price" placeholder="직접입력"/>
					</div>
					<div class="row-box">
						<label class="title">재고반영</label>
						<input type="radio" class="form-text" name="reflectFlag" value="1">
						<input type="radio" class="form-text" name="reflectFlag" value="2">
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
	<div class="title">상품관리</div>
	<div>업체를 선택하신 후 상품을 등록하세요.</div>
	<div class="title-right-wrap">
		<button type="button" class="title-button" id="btnRegisterClassification">분류등록</button>
		<button type="button" class="title-button" id="btnRegisterItem">품목등록</button>
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">업체목록</div>
	</div>
</div>
<div class="contents-body-wrap">
	<div style="display:flex;">
		<div class="partner-box">
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