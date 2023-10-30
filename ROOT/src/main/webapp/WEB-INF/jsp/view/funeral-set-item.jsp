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
		searchObj.order = 'A.SET_NAME ASC';
		
		var _table = $('.pb-table.list');
		
		var theadObj = {
			table: _table,
			colGroup:new Array(25, 25, 25),
			theadRow:[['SET_NO', '번호'], ['SET_NAME', '세트명'], ['PRICE', '세트단가']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});

		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectSetList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.SET_NAME+'</td>');
					_tr.append('<td class="r">'+(this.VAT_PRICE ? $.pb.targetMoney(this.VAT_PRICE) : '0')+'원</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							$.pb.ajaxCallHandler('/adminSec/selectSetItemList.do', { setNo : _tr.data('SET_NO') }, function(itemData) {
								$('.order-box').find('tbody').html("");
								if(itemData.list.length > 0){
									$.each(itemData.list, function(idx) {
										var _tr = $('<tr class="order">');
										var _this  = this
										_tr.data(this);
										_tr.append('<td>'+(this.ITEM_NAME ? this.ITEM_NAME : this.SET_NAME)+'</td>');
										_tr.append('<td>'+(this.UNIT ? this.UNIT : '1세트')+'</div>');
										_tr.append('<td class="pm-box"><input type="text" name="cnt" value="0" maxlength="3"></td>');
										_tr.find('input[name=cnt]').plusMinusBox(
							 				function(){
							 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _this.CNT))+"원");
							 					calTotalPrice();
							 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
							 				},function(){ 
							 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _this.CNT))+"원")
							 					calTotalPrice();
							 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
							 				},function(){
							 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _this.CNT))+"원")
							 					calTotalPrice();
							 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
							 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
							 				}, 'gray'
							 			);
										_tr.append('<td class="order-cnt">'+this.CNT+'</td>');
										_tr.append('<td>'+this.CLASSIFICATION_NAME+'</td>');
										_tr.append('<td class="r">'+$.pb.targetMoney(this.VAT_PRICE)+'원</td>');
										_tr.append('<td class="r total-price">'+$.pb.targetMoney(this.CNT * this.VAT_PRICE)+'원</td>');
										_tr.append('<td><button type="button" class="btn-del">삭제</button></td>');
										_tr.find('.btn-del').on('click', function() {
											$(this).parents('tr').remove();
										})
										$('.order-box tbody').prepend(_tr);
									});
								}
								calTotalPrice();
							});
							_thisLayer.find('.top-button.register').val(_tr.data('SET_NO'));
							_thisLayer.find('.top-button.delete').val(_tr.data('SET_NO')).show();
							_thisLayer.find('.table-search.icon-search, .pb-table-wrap').hide();
							createPartner(searchObj);
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
		};createTable(searchObj);
		
		// 품목 등록 버튼
		$('#btnRegister').on('click', function(){
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register').val('');
				_thisLayer.find('.top-button.delete').hide();
				$('.order-box').find('tbody').html("");
				$('.order-info .total-price').text('0원');
				createPartner(searchObj);
				layerInit(_thisLayer);
			});
		});
		
		
		var createPartner = function(_searchObj) {
			$('.company-box').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralItemPartner.do', _searchObj, function(data) {
				$.each(data.list, function(idx) {
					var _div = $('<div class="company">'+this.NAME+'</div>');
					_div.data(this);
					_div.on('click', function(){
						$(this).addClass('ac').siblings('div').removeClass('ac');
						createClassification(_div.data('PARTNER_NO'));
					});
					$('.company-box').append(_div);
				});
				$('.company-box').find('.company:eq(0)').addClass('ac').click();
			});
		};
		
		
		var createClassification = function(_partnerNo) {
			$('.classification-box').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralClassificationList.do', {partnerNo : _partnerNo}, function(data) {
				$('.classification-box').append('<div>전체분류</div>');
				$.each(data.list, function(idx) {
					var _div = $('<div>'+this.NAME+'</div>');
					_div.data(this);
					$('.classification-box').append(_div);
				});
				$('.classification-box div').on('click', function() {
					$(this).addClass('ac').siblings('div').removeClass('ac');
					createItem($(this).data('CLASSIFICATION_NO'), _partnerNo);
				});
				$('.classification-box div:eq(0)').addClass('ac').click();
			});
		};
		

		var createItem = function(_classificationNo, _partnerNo) {
			$('.item-box').html("");
			if(_partnerNo){
				$.pb.ajaxCallHandler('/adminSec/selectFuneralItemList.do', {classificationNo : _classificationNo, partnerNo : _partnerNo, order : 'IDX, ITEM_NO DESC' }, function(data) {
					$.each(data.list, function(idx) {
						var _div = $('<div class="item">');
						_div.data(this);
						_div.append('<div class="name">'+this.ITEM_NAME+'</div>');
						_div.append('<div>'+this.UNIT+'</div>');
						_div.append('<div>'+$.pb.targetMoney(this.VAT_PRICE)+'원</div>');
						$('.item-box').append(_div);
						_div.on('click', function(){
							addSetItem(_div.data());
						});
					});
				});
			}else{
				$.pb.ajaxCallHandler('/adminSec/selectSetList.do', {funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}', order: 'SET_NO DESC'}, function(data) {
					$.each(data.list, function(idx) {
						var _div = $('<div class="item">');
						_div.data(this);
						_div.append('<div class="name">'+this.SET_NAME+'</div>');
						_div.append('<div>1세트</div>');
						_div.append('<div>'+$.pb.targetMoney(this.VAT_PRICE)+'원</div>');
						$('.item-box').append(_div);
						_div.on('click', function(){
							$.pb.ajaxCallHandler('/adminSec/selectSetItemList.do', {setNo : _div.data('SET_NO')}, function(data) {
								$.each(data.list, function(idx) {
									addSetItem(this);
								});
							});
						});
					});
				});
			};
		};
		
		
		var addSetItem = function(_data) {
			var _tr = $('<tr class="order">');
			_tr.data(_data);
			_tr.append('<td>'+(_data.ITEM_NAME ? _data.ITEM_NAME : _data.SET_NAME)+'</td>');
			_tr.append('<td>'+(_data.UNIT ? _data.UNIT : '1세트')+'</td>');
			_tr.append('<td class="pm-box"><input type="text" name="cnt" value="0" maxlength="3"></td>');
			_tr.find('input[name=cnt]').plusMinusBox(
				function(){
 					_tr.find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _tr.find('.order-cnt').text()*1))+"원");
 					calTotalPrice();
 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
 				},function(){ 
 					_tr.find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _tr.find('.order-cnt').text()*1))+"원")
 					calTotalPrice();
 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
 				},function(){
 					_tr.find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _tr.find('.order-cnt').text()*1))+"원")
 					calTotalPrice();
 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
 				}, 'gray'
 			);
			_tr.append('<td class="order-cnt">0</td>');
			_tr.append('<td>'+_data.CLASSIFICATION_NAME+'</td>');
			_tr.append('<td class="r">'+$.pb.targetMoney(_data.VAT_PRICE)+'원</td>');
			_tr.append('<td class="r total-price">'+$.pb.targetMoney(_data.VAT_PRICE)+'원</td>');
			_tr.append('<td><button type="button" class="btn-del">삭제</button></td>');
			_tr.find('.btn-del').on('click', function() {
				$(this).parents('tr').remove();
			})
			
			
			var _tmp = 0;
			if($('.order-box tbody tr').length == 0) {
				_tr.addClass('ac').find('input[name=cnt]').val(1);
				$('.order-box tbody').append(_tr);
				calTotalPrice();
			}
			else {
				$('.order-box tbody tr').each(function() {
					if($(this).data('ITEM_NO') == _data.ITEM_NO) {
						_tmp = 0;
						$(this).find('input[name=cnt]').val(parseInt($(this).find('input[name=cnt]').val()) + (_data.CNT ? _data.CNT : 1));
						$(this).find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE * ($(this).find('input[name=cnt]').val()*1 + $(this).find('.order-cnt').text()*1))+"원")
						if($(this).find('input[name=cnt]').val() > 0) $(this).addClass('ac');
						$('.order-box tbody tr:eq(0)').before($(this));
						calTotalPrice();
						return false;
					} else _tmp = 1;
				});
				if(_tmp != 0) {
					_tr.addClass('ac').find('input[name=cnt]').val(1);
					$('.order-box tbody tr:eq(0)').before(_tr);
					calTotalPrice();
				}
			}
		};
		
		var calTotalPrice = function(){
			var _price = 0;
			if($('.order-box').find('tbody tr').length > 0){
				$('.order-box').find('tbody tr').each(function() {
					_price += (($(this).find('input[name=cnt]').val()*1 + ($(this).data('CNT') ? $(this).data('CNT')*1 : 0)) * $(this).data('VAT_PRICE'));
				});
				$('.order-info .total-price').text($.pb.targetMoney(_price) + "원");
			}else{
				$('.order-info .total-price').text("0원");
			}
		};
		
		// 품목 저장 버튼
		$('.pb-right-popup-wrap .register').on('click', function(){
// 			if($('.order-box tbody tr').length < 1) return alert("상품을 추가해 주세요.");
// 			else {
// 				var _chk = true;
// 				$('.order-box tbody tr').each(function(){
// 					if($(this).find('input[name=cnt]').val() > 0) return _chk = false;
// 				});
// 				if(_chk) return alert("상품을 주문해 주세요.");
// 			}
			
			if(!necessaryChecked($('#dataForm'))){
				var _url = $(this).val() ? '/adminSec/updateSet.do' : '/adminSec/insertSet.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('setNo', $(this).val());
				_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
				var _setItemList = [];
				$('.order-box tbody tr').each(function(){
					if($(this).find('input[name=cnt]').val()*1+$(this).find('.order-cnt').text()*1 > 0) {
						var $list = {
							setNo : $('.pb-right-popup-wrap .register').val(),
							itemNo : $(this).data('ITEM_NO'),
							cnt : $(this).find('input[name=cnt]').val(),
							oriCnt : $(this).find('.order-cnt').text()
						}
						_setItemList.push($list);
					}
				});
	 			_formData.append('setItemList', JSON.stringify(_setItemList));
				
				$.pb.ajaxUploadForm(_url, _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						createTable(searchObj);
						$('.top-button-wrap').find('button').prop('disabled', false);
						$('.pb-popup-close').click();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}else{
				if(!$('input[name=setName]').val()) return alert("세트상품명을 입력해 주세요.");
			}
		});
		
		$('.pb-right-popup-wrap .delete').on('click', function(){
			if(confirm('세트상품을 삭제하시겠습니까?')) {
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('setNo', $(this).val());
				_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
				$.pb.ajaxUploadForm('/adminSec/deleteSet.do', _formData, function(result) {
					$('.top-button-wrap').find('button').prop('disabled', true);
					if(result != 0) {
						createTable(searchObj);
						$('.top-button-wrap').find('button').prop('disabled', false);
						$('.pb-popup-close').click();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}
		});
		
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	.pb-right-popup-wrap > .top-button-wrap { position:absolute; top:23px; right:95px; }
	.pb-right-popup-wrap > .top-button-wrap > .top-button { width:200px; height:48px; margin-left:8px; border-radius:4px; background:#157FFB; color:#FFFFFF; font-size:18px; font-weight:500; letter-spacing:0.9px; }
	.popup-body-top > .row-box { margin-top:20px; font-size:0; }
	.popup-body-top > .row-box > label.title { width:156px; display:inline-block; box-sizing:border-box; padding:0 16px; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; text-align:right; }
	.popup-body-top > .row-box > label.title.full { width:100%; text-align:left; }
	.popup-body-top > .row-box > .form-text { width:calc(50% - 156px); height:36px; display:inline-block; padding-left:12px; box-sizing:border-box; border:1px solid #707070; border-radius:2px; background:#F6F6F6; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; }
	.event-info-box { height: calc(100% - 85px); }
	.order-info { display: flex; justify-content: flex-end; align-items: center; width: 100%; height: 72px; font-size: 25px; }
	.order-info .title { display: flex; justify-content: center; align-items: center; width: 200px; height: 50px; background-image: linear-gradient(to bottom, #FFF, #ebedee); border:1px solid #707070; }
	.order-info .total-price { display: flex; justify-content: center; align-items: center; width: 250px; height: 50px; background: #FFF; border:1px solid #707070; }
	.event-info-box .list-wrap { height: calc(100% - 100px); }
</style>

<form id="dataForm" onsubmit="return false">
	<div class="pb-right-popup-wrap full-size">
		<div class="pb-popup-title">세트상품 정보관리</div>
		<div class="top-button-wrap">
			<button type="button" class="top-button register">저장</button>
			<button type="button" class="top-button pb-popup-close">취소</button>
			<button type="button" class="top-button delete">삭제</button>
		</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="row-box" style="margin:8px 0px 4px;">
					<label class="title" style="font-size:20px;">세트상품명</label>
					<input type="text" class="form-text necessary" name="setName" style="height:48px;" placeholder="세트상품명을 입력 해주세요."/>
				</div>
			</div> 
			<div class="event-info-box or acc" style="width:390px; padding-right:16px;">
				<div class="top-box">사업자 분류</div>
				<div class="mid-box company-box"></div>
				<div class="list-wrap">
					<div class="list-box classification-box">
					</div>
				</div>
			</div>
			
			<div class="event-info-box or acc" style="width:390px; padding-right:16px;">
				<div class="top-box">주문 물품표</div>
				<div class="mid-box item-mid">
					<div style="width:54.4%">상품</div>
					<div style="width:15.1%">단위</div>
					<div style="width:35.8%">단가</div>
				</div>
				<div class="list-wrap item-wrap">
					<div class="list-box item-box">
					</div>
				</div>
			</div>
			
			
			<div class="event-info-box or acc" style="width:calc(100% - 780px);">
				<div class="top-box">주문내역</div>
				<div class="mid-box">
					<div style="width:22.6%">상품</div>
					<div style="width:7.2%">단위</div>
					<div style="width:12.1%">주문</div>
					<div style="width:7.2%">총 수량</div>
					<div style="width:20.4%">분류</div>
					<div style="width:9.1%">단가</div>
					<div style="width:12.4%">금액</div>
					<div style="width:9%">삭제</div>
					
				</div>
				<div class="list-wrap order-wrap" style="height: calc(100% - 140px);">
					<table class="order-box">
						<colgroup>
							<col width="22.9%"/>
							<col width="7.3%"/>
							<col width="12.3%"/>
							<col width="7.3%"/>
							<col width="20.7%"/>
							<col width="9.3%"/>
							<col width="12.7%"/>
							<col width="7.5%"/>
						</colgroup>
						<tbody></tbody>
					</table>
				</div>
				<div class="order-info">
					<div class="title">총금액</div>
					<div class="total-price"></div>
				</div>
			</div>
		</div>
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">세트상품 관리</div>
	<div>세트상품을 관리할 수 있습니다.</div>
	<div class="title-right-wrap">
		<button type="button" class="title-button" id="btnRegister">세트상품추가</button>
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">세트상품 목록</div>
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