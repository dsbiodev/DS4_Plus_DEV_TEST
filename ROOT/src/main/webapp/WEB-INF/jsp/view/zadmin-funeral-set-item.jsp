<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.order = 'A.SET_NAME ASC';
		
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
					$('.classification-table tbody').html("");
					$('.item-list').html("");
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
			_table.find('tbody').html('');
			$('.paging').html("");
			$('.classification-table tbody').html("");
			$('.item-list').html("");
			
			$.pb.ajaxCallHandler('/adminSec/selectSetList.do', _searchObj, function(tableData) {
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.SET_NAME+'</td>');
					_tr.append('<td class="r">'+(this.PRICE ? $.pb.targetMoney(this.PRICE) : '0')+'원</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							$.pb.ajaxCallHandler('/adminSec/selectSetItemList.do', {setNo : _tr.data('SET_NO')}, function(itemData) {
								$('.order-table').find('tbody').html("");
								if(itemData.list.length > 0){
									$.each(itemData.list, function(idx) {
										var _tr = $('<tr>');
										_tr.data(this);
										_tr.append('<td><input type="checkbox" name="chk"></td>');
										_tr.find('input[name=chk]').pbCheckbox({ addText:[], matchParent:false });
										_tr.append('<td>'+this.ITEM_NAME+'</td>');
										_tr.append('<td>'+this.UNIT+'</td>');
										_tr.append('<td><input type="text" name="cnt"></td>');
										_tr.find('input[name=cnt]').plusMinusBox(
												function(){_tr.find('.total-price').text($.pb.targetMoney(_tr.data('PRICE')*_tr.find('input[name=cnt]').val())+"원");
													if(_tr.find('input[name=cnt]').val() == 0) _tr.remove();
													calTotalPrice();
											},
												function(){_tr.find('.total-price').text($.pb.targetMoney(_tr.data('PRICE')*_tr.find('input[name=cnt]').val())+"원")
													calTotalPrice();
											}
										);
										_tr.find('input').val(this.CNT);
										_tr.append('<td class="r">'+$.pb.targetMoney(this.PRICE)+'원</td>');
										_tr.append('<td class="r total-price">'+$.pb.targetMoney(this.PRICE*this.CNT)+'원</td>');
										$('.order-table').find('tbody').append(_tr);
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
		};
// 		createTable(searchObj);
		
		// 품목 등록 버튼
		$('#btnRegister').on('click', function(){
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			else{
				$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
					_thisLayer.find('.top-button.register').val('');
					_thisLayer.find('.top-button.delete').hide();
					$('.order-table').find('tbody').html("");
					$('.total-wrap .total-price').text('0원');
					createPartner(searchObj);
					layerInit(_thisLayer);
				});
			};
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
			$('.classification-table').find('tbody').html("");
			$('.item-list').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralClassificationList.do', {partnerNo : _partnerNo}, function(data) {

				var _tTr = $('<tr>');
				_tTr.append('<td>전체분류</td>');
				$('.classification-table').find('tbody').append(_tTr);
				_tTr.on('click', function(){
					$(this).addClass('ac').siblings('tr').removeClass('ac');
					createItem("", _partnerNo);
				});
				
				$.each(data.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+this.NAME+'</td>');
					$('.classification-table').find('tbody').append(_tr);
					_tr.on('click', function(){
						$(this).addClass('ac').siblings('tr').removeClass('ac');
						createItem(_tr.data('CLASSIFICATION_NO'), _partnerNo);
					});
				});
				$('.classification-table').find('tbody tr:eq(0)').addClass('ac').click();
			});
		};
		

		var createItem = function(_ClassificationNo, _partnerNo) {
			$('.item-list').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralItemList.do', {classificationNo : _ClassificationNo, partnerNo : _partnerNo, order : 'IDX, ITEM_NO DESC' }, function(data) {
				$.each(data.list, function(idx) {
					
					var _div = $('<div class="item">');
					_div.data(this);
					_div.append('<div class="name">'+this.ITEM_NAME+'</div>');
					_div.append('<div>'+this.UNIT+'</div>');
					_div.append('<div>'+$.pb.targetMoney(this.PRICE)+'원</div>');
					$('.item-list').append(_div);
					_div.on('click', function(){
						addSetItem(_div.data());
					});
				});
			});
		};
		
		$('input[type="checkbox"][name="all"]').pbCheckbox({addText:[],fontSize:'18px'},
				{checked: function(_this){
					$('.order-table input[name=chk]').each(function(){
						if(!$(this).is(':checked')) $(this).click();
					});
				},
				unChecked: function(_this){
					$('.order-table input[name=chk]:checked').click();
				}
		});
		
		var addSetItem = function(_data) {
			var _tr = $('<tr>');
			_tr.data(_data);
			_tr.append('<td><input type="checkbox" name="chk"></td>');
			_tr.find('input[name=chk]').pbCheckbox({ addText:[], matchParent:false });
			_tr.append('<td>'+_data.ITEM_NAME+'</td>');
			_tr.append('<td>'+_data.UNIT+'</td>');
			_tr.append('<td><input type="text" name="cnt"></td>');
			_tr.find('input[name=cnt]').plusMinusBox(
				function(){_tr.find('.total-price').text($.pb.targetMoney(_data.PRICE*_tr.find('input[name=cnt]').val())+"원");
					calTotalPrice();
					if(_tr.find('input[name=cnt]').val() == 0) _tr.remove();
				},function(){ _tr.find('.total-price').text($.pb.targetMoney(_data.PRICE*_tr.find('input[name=cnt]').val())+"원")
					calTotalPrice();
				}
			);
			_tr.find('input').val(1);
			_tr.append('<td class="r">'+$.pb.targetMoney(_data.PRICE)+'원</td>');
			_tr.append('<td class="r total-price">'+$.pb.targetMoney(_data.PRICE)+'원</td>');

			
			var _tmp = 0;
			if($('.order-table').find('tbody tr').length == 0){
				$('.order-table').find('tbody').append(_tr);
				calTotalPrice();
			}
			else{
				$('.order-table').find('tbody tr').each(function(){
					if($(this).data('ITEM_NO') == _data.ITEM_NO){
						_tmp = 0;
						$(this).find('input[name=cnt]').val(parseInt($(this).find('input[name=cnt]').val()) + 1);
						$(this).find('.total-price').text($.pb.targetMoney(_data.PRICE*$(this).find('input[name=cnt]').val())+"원")
						calTotalPrice();
						return false;
					}else _tmp = 1;
				});
				if(_tmp != 0){
					$('.order-table').find('tbody').append(_tr);
					calTotalPrice();
				}
			}
		};
		
		$('.del-item').on('click', function(){
			$('.order-table').find('tbody tr').each(function(){
				if($(this).find('input[name=chk]').is(':checked'))
					$(this).remove();
			});
		});
		
		var calTotalPrice = function(){
			var _price = 0;
			if($('.order-table').find('tbody tr').length > 0){
				$('.order-table').find('tbody tr').each(function(){
					_price += ($(this).find('input[name=cnt]').val()*$(this).data('PRICE'));
				});
				$('.total-wrap .total-price').text($.pb.targetMoney(_price) + "원");
			}else{
				$('.total-wrap .total-price').text("0원");
			}
		};
		
		
		// 품목 저장 버튼
		$('.pb-right-popup-wrap .register').on('click', function(){
			if($('.order-table tbody tr').length < 1) return alert("상품을 추가해 주세요.");
			if(!necessaryChecked($('#dataForm'))){
				var _url = $(this).val() ? '/adminSec/updateSet.do' : '/adminSec/insertSet.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('setNo', $(this).val());
				_formData.append('funeralNo', $('.select-box-wrap .table-search').data('funeralNo'));
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
				var _setItemList = [];
				$('.order-table tbody tr').each(function(){
					var $list = {
							setNo : $('.pb-right-popup-wrap .register').val(),
							itemNo : $(this).data('ITEM_NO'),
							cnt : $(this).find('input[name=cnt]').val()
					}
					_setItemList.push($list);
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
			if(!necessaryChecked($('#dataForm'))){
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
	
	.pb-popup-body > .popup-body-top > .item-button-wrap { position:absolute; top:0; right:0; }
	.pb-popup-body > .popup-body-top > .item-button-wrap > .top-button { width:170px; height:48px; margin-left:8px; border-radius:4px; background:#FFF; color:#333; font-size:18px; font-weight:500; letter-spacing:0.9px; border:1px solid #707070; }

	.popup-body-top > .row-box { margin-top:20px; font-size:0; }
	.popup-body-top > .row-box > label.title { width:156px; display:inline-block; box-sizing:border-box; padding:0 16px; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; text-align:right; }
	.popup-body-top > .row-box > label.title.full { width:100%; text-align:left; }
	.popup-body-top > .row-box > .form-text { width:calc(100% - 156px); height:36px; display:inline-block; padding-left:12px; box-sizing:border-box; border:1px solid #707070; border-radius:2px; background:#F6F6F6; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; }
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
		<div class="pb-popup-body half">
			<div class="popup-body-top">
				<div class="row-box" style="margin:8px 0px 4px;">
					<label class="title" style="font-size:20px;">세트상품명</label>
					<input type="text" class="form-text necessary" name="setName" style="height:48px;" placeholder="세트상품명을 입력 해주세요."/>
				</div>
			</div> 
			
			<div class="event-info-box">
				<div class="company-box"></div>
				<div class="item-box">
					<div class="classification-box">
						<table class="classification-table">
							<tbody></tbody>
						</table>
					</div>
					<div class="item-box">
						<div class="item-list"></div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="pb-popup-body half">
			<div class="popup-body-top">
				<div class="top-title">세트상품 구성</div>
				<div class="item-button-wrap">
					<button type="button" class="top-button del-item">선택항목삭제</button>
				</div>
				
			</div>
			
			<div class="event-info-box">
				<div class="table-head">
					<div style="width:5%;"><input type="checkbox" name="all" value="1"></div>
					<div style="width:25%;">품목</div>
					<div style="width:10%;">수량</div>
					<div style="width:15%;">단위</div>
					<div style="width:20%;">단가</div>
					<div style="width:25%;">금액</div>
				</div>
				<div class="order-box" style="height:548px;">
					<table class="order-table">
						<colgroup>
							<col width="5%"/>
							<col width="25%"/>
							<col width="10%"/>
							<col width="15%"/>
							<col width="20%"/>
							<col width="25%"/>
						</colgroup>
<!-- 						<thead> -->
<!-- 							<tr><td><input type="checkbox" name="all" value="1"></td><td>품목</td><td>수량</td><td>단위</td><td>단가</td><td>금액</td></tr> -->
<!-- 						</thead> -->
						<tbody>
						</tbody>
					</table>
				</div>
				<div class="total-wrap">
					<div class="total-text">주문 금액</div>
					<div class="total-price">1000000</div>
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